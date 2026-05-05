use std::collections::{HashMap};

use clap::builder::Str;
use serialport::new;

pub struct ForthWord {
    pub name: String,
    pub address: u32,
}

pub struct ForthState {
    pub words: HashMap<String, ForthWord>
}

impl ForthState {
    pub fn new() -> Self {
        Self {
            words: HashMap::new()
        }
    }
}
