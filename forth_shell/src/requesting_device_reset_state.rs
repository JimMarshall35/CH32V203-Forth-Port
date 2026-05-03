use crate::device_connection_states::DeviceConnectionStateImplementation;
use crossterm::event::{self, KeyCode, KeyEventKind};
use std::time::Duration;

pub struct RequestingDeviceResetState {
    // data recieved from serial while in this state
    input: String
}

impl DeviceConnectionStateImplementation for RequestingDeviceResetState {
    fn handle_input(&mut self, port: &mut dyn serialport::SerialPort) -> bool {
        if event::poll(Duration::from_millis(30)).unwrap() {
            if let Some(key) = event::read().unwrap().as_key_press_event() {
                match key.code {
                    KeyCode::Char('q') => {
                        return true;
                    },
                    _ => {}
                }
            }
        }
        return false;
    }

    fn read_serial(&mut self, port:&mut dyn serialport::SerialPort) {
        let mut buf: [u8; 128] = [0; 128];
        match port.read(buf.as_mut_slice()) {
            Ok(value) => {
                for i in 0..value {
                    self.input.push(buf[i] as char);
                }

            }
            Err(ref e) if e.kind() == std::io::ErrorKind::TimedOut => {
                // no data available right now
            }
            Err(e) => {
            }
        }
    }

    fn render(&mut self, frame: &mut ratatui::Frame) {
        todo!()
    }

    fn on_enter_state(&mut self) {

    }

    fn on_exit_state(&mut self) {

    }

    fn next_state(&mut self) -> crate::device_connection_states::DeviceConnectionState {
        todo!()
    }
}