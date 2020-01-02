// ==================================================
// Simple program counter
// 
// Original version was much more complicated.
// This version just sets the addr_out from the input
// The rest of the logic is handled in the CPU wiring
// ==================================================

module programcounter (
    output [31:0] addr_out,
    input [31:0] addr_in,
    input clk
);
    // Set up the initial addr_next
    reg[31:0] next_addr = 16'd0;

    // Continously assign addr_out to next addr
    assign addr_out = next_addr;

    always @(posedge clk) begin
        // And move the next addr from the input on clock cycles
        next_addr = addr_in;
    end 
endmodule
