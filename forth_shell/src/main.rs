use color_eyre::Result;
use crossterm::event::{self, KeyCode, KeyEventKind};
use ratatui::layout::{Constraint, Layout, Position, Direction};
use ratatui::style::{Color, Modifier, Style, Stylize};
use ratatui::text::{Line, Span, Text};
use ratatui::widgets::{Block, List, ListItem, Paragraph};
use ratatui::{DefaultTerminal, Frame};
use clap::Parser;
use std::time::Duration;
use serialport;

#[derive(Parser, Debug)]
#[command(version, about)]
struct Args {
    /// Serial port (e.g. /dev/ttyUSB0 or COM3)
    #[arg(short, long, default_value = "/dev/ttyUSB0")]
    port: String,
}


fn main() -> Result<()> {
    let args = Args::parse();

    color_eyre::install()?;
    ratatui::run(|terminal| App::new(args).run(terminal))
}

/// App holds the state of the application
struct App {
    /// Current value of the input box
    input: String,
    /// Position of cursor in the editor area.
    character_x: usize,
    character_y: usize,
    /// Current input mode
    input_mode: InputMode,
    scroll_serialterm: u16,
    port: Box<dyn serialport::SerialPort>,
    serialtermHeight: u16,
}

enum InputMode {
    Normal,
    Editing,
}

impl App {
    fn new(args: Args) -> Self {
        Self {
            input: String::new(),
            input_mode: InputMode::Normal,
            scroll_serialterm: 0,
            character_x: 0,
            character_y: 0,
            port: serialport::new(args.port, 115_200)
                .timeout(Duration::from_millis(100))
                .open()
                .expect("Failed to open port"),
            serialtermHeight: 0
        }
    }

    fn move_cursor_left(&mut self) {
        self.character_x -= 1;
    }

    fn move_cursor_down(&mut self) {
        self.character_y += 1;
        if self.character_y >= (self.serialtermHeight - 2) as usize {
            self.character_y = (self.serialtermHeight - 3) as usize;
        }
    }

    fn carriage_return(&mut self) {
        self.character_x = 0;
    }
    fn move_cursor_right(&mut self) {
        self.character_x += 1;
    }

    fn enter_char(&mut self, new_char: char) {
        self.input.push(new_char);
        self.move_cursor_right();
    }

    fn scroll_down(&mut self) {
        self.scroll_serialterm = self.scroll_serialterm.saturating_add(1);
    }

    fn scroll_up(&mut self) {
        self.scroll_serialterm = self.scroll_serialterm.saturating_sub(1);
    }
    
    fn delete_char(&mut self) {
        let is_not_cursor_leftmost = self.character_x != 0;
        if is_not_cursor_leftmost {
            self.input.pop();
            self.move_cursor_left();
        }
    }

    fn read_serial(&mut self) {
        let mut buf: [u8; 128] = [0; 128];
        match self.port.read(buf.as_mut_slice()) {
            Ok(value) => {
                for i in 0..value {
                    if buf[i] == 8 {
                        self.delete_char();
                        
                    }
                    else if buf[i] == 13 {
                        self.move_cursor_down();
                        self.carriage_return();
                    }
                    else {
                        self.enter_char(buf[i] as char);
                    }
                }
            }
            Err(_) => {}
        }
    }

    fn handle_input(&mut self) -> bool {
        if event::poll(Duration::from_millis(30))? {
            if let Some(key) = event::read()?.as_key_press_event() {
                match self.input_mode {
                    InputMode::Normal => match key.code {
                        KeyCode::Char('e') => {
                            self.input_mode = InputMode::Editing;
                        }
                        KeyCode::Char('q') => {
                            return true;
                        }
                        _ => {}
                    },
                    InputMode::Editing if key.kind == KeyEventKind::Press => match key.code {
                        KeyCode::Enter => {
                            let v :Vec<u8> = vec![ 13 as u8 ];
                            self.port.write(&v);
                        },
                        KeyCode::Char(to_insert) => {
                            let v :Vec<u8> = vec![ to_insert as u8 ];
                            self.port.write(&v);
                        },
                        KeyCode::Backspace => {
                            let v :Vec<u8> = vec![ 8 as u8 ];
                            self.port.write(&v);
                        },
                        KeyCode::Down => self.scroll_down(),
                        KeyCode::Up => self.scroll_up(),
                        KeyCode::Esc => self.input_mode = InputMode::Normal,
                        _ => {}
                    },
                    InputMode::Editing => {}
                }
            }
        }
        return false;
    }

    fn run(mut self, terminal: &mut DefaultTerminal) -> Result<()> {
        loop {
            if self.handle_input() {
                return Ok(());
            }
            self.read_serial();
            terminal.draw(|frame| self.render(frame))?;
        }
    }

    fn get_top_msg(&mut self) -> (Vec<Span<'static>>, Style) {
        match self.input_mode {
            InputMode::Normal => (
                vec![
                    "Press ".into(),
                    "q".bold(),
                    " to exit, ".into(),
                    "e".bold(),
                    " to start editing.".bold(),
                ],
                Style::default().add_modifier(Modifier::RAPID_BLINK),
            ),
            InputMode::Editing => (
                vec![
                    "Press ".into(),
                    "Esc".bold(),
                    " to stop editing, ".into(),
                    "Enter".bold(),
                    " to record the message".into(),
                ],
                Style::default(),
            ),
        }
    }

    fn render(&mut self, frame: &mut Frame) {

        let outer_chunks = Layout::default()
            .direction(Direction::Vertical)
            .constraints([
                Constraint::Length(1),
                Constraint::Min(0),
            ])
            .split(frame.size());

        let inner_chunks = Layout::default()
            .direction(Direction::Horizontal)
            .constraints([
                Constraint::Percentage(70),
                Constraint::Percentage(30),
            ])
            .split(outer_chunks[1]);

        let (msg, style) = self.get_top_msg();
        let mut inputCpy = self.input.clone();
        inputCpy += " ";
        let total_lines = inputCpy.lines().count() as u16;

        let visible_height = inner_chunks[0].height.saturating_sub(2); // minus borders if any
        self.serialtermHeight = inner_chunks[0].height;

        // 👇 auto-scroll so bottom is visible
        if total_lines > visible_height {
            self.scroll_serialterm = total_lines - visible_height ;
        } else {
            self.scroll_serialterm = 0;
        }

        let text = Text::from(Line::from(msg)).patch_style(style);
        let help_message = Paragraph::new(text);
        frame.render_widget(help_message, outer_chunks[0]);

        let input = Paragraph::new(self.input.as_str())
            .style(match self.input_mode {
                InputMode::Normal => Style::default(),
                InputMode::Editing => Style::default().fg(Color::Yellow),
            })
            .block(Block::bordered().title("Input"))
            .scroll((self.scroll_serialterm, 0));
        frame.render_widget(input, inner_chunks[0]);
        match self.input_mode {
            // Hide the cursor. `Frame` does this by default, so we don't need to do anything here
            InputMode::Normal => {}
            #[expect(clippy::cast_possible_truncation)]
            InputMode::Editing => frame.set_cursor_position(Position::new(
                // Draw the cursor at the current position in the input field.
                // This position can be controlled via the left and right arrow key
                inner_chunks[0].x + self.character_x as u16 + 1,
                // Move one line down, from the border to the input line
                inner_chunks[0].y + self.character_y as u16 + 1,
            )),
        }

        let messages: Vec<ListItem> = vec![];
        let messages = List::new(messages).block(Block::bordered().title("Messages"));
        frame.render_widget(messages, inner_chunks[1]);

        
    }
}