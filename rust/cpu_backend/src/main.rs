mod modules;

use modules::noTop;
extern crate verilated;
extern crate verilated_module;

use std::time::Duration;
use std::net::TcpListener;
use std::thread::spawn;
use tungstenite::server::accept;
use tungstenite::Message;

use verilated_module::module;

#[module(top)]
pub struct Top {
    #[port(clock)]
    pub clk_i: bool,
    #[port(reset)]
    pub rst_i: bool,
    #[port(output)]
    pub count_o: [bool; 4],
}


// #[derive(Debug)]
// struct TopResult {
//     pub clk_i: bool,
//     pub rst_i: bool,
//     pub count_o: [bool; 4],
// }

// impl Top {
//     fn get(&self) -> TopResult {
//         TopResult {
//             clk_i: self.clk_i(),
//             rst_i: self.clk_i(),
//             count_o: self.count_o(),
//         }
//     }
// }


fn main() {
    let mut tb: Top = Top::default();
    tb.eval();
    tb.eval();

    tb.open_trace("counter.vcd", 99).unwrap();


    
    let server = TcpListener::bind("127.0.0.1:9001").unwrap();
    for stream in server.incoming() {
        spawn(move || {
            let mut websocket = accept(stream.unwrap()).unwrap();
            loop {
                let msg = websocket.read_message().unwrap();
                println!("Received: {}", msg);

                if msg.is_binary() || msg.is_text() {
                    println!("here is the message before I send it out: {:?}", msg);
                    websocket.write_message(msg).unwrap();
                }
            }
        });
    }



    // let mut clocks: u64 = 0;
    // while tb.count_o() < 10 {
    //     if clocks == 0 {
    //         tb.reset_toggle();
    //     } else if clocks == 2 {
    //         tb.reset_toggle();
    //     }

    //     tb.clock_toggle();
    //     tb.eval();
    //     tb.trace_at(Duration::from_nanos(20 * clocks));

    //     tb.clock_toggle();
    //     tb.eval();
    //     tb.trace_at(Duration::from_nanos(20 * clocks + 10));

    //     println!("{}: count_o = {}", clocks, tb.count_o());

    //     clocks += 1;
    // }
    // tb.trace_at(Duration::from_nanos(20 * clocks));

    tb.finish();
}
