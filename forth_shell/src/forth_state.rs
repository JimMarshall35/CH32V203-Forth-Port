use std::collections::{HashMap};

use clap::builder::Str;
use serialport::new;

#[derive(Clone)]
pub struct MCUMemoryDataWord {
    pub address: u32,
    pub data: u32
}

impl MCUMemoryDataWord {
    pub fn from_tokens(tokens: &Vec<&str>) -> Self {
        let t0 = tokens[0];
        let t = tokens[1];
        Self { 
            address: u32::from_str_radix(t0.trim_start_matches("0x"), 16).unwrap(), 
            data: u32::from_str_radix(t.trim_start_matches("0x"), 16).unwrap()
        }
    }
}

#[derive(Clone)]
pub struct ForthWord {
    pub name: String,
    pub address: u32,
    pub address_string: String,
    pub data: Vec<MCUMemoryDataWord>,
    pub is_primitive: bool,
    pub is_immediate: bool,
}

impl ForthWord {
    pub fn from_tokens(tokens: &Vec<&str>) -> Self {
        assert!(tokens.len() == 4);
        let address: u32 = u32::from_str_radix(tokens[0].trim_start_matches("0x"), 16).unwrap();
        let is_immediate: bool = u32::from_str_radix(tokens[2].trim_start_matches("0x"), 16).unwrap() != 0;
        let is_primititive: bool = u32::from_str_radix(tokens[3].trim_start_matches("0x"), 16).unwrap() != 0;
        Self {
            name: tokens[1].to_string(),
            address: address,
            address_string: format!("{:#010x}", address),
            data: vec![],
            is_immediate: is_immediate,
            is_primitive: is_primititive
        }
    }
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
