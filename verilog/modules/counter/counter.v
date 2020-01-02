//------------------------------------------------------------------------
// Simple resettable up-counter
// Used for fake cpu
//------------------------------------------------------------------------

module counter
#(
    parameter width = 16,
    parameter increment = 1,
    parameter init_val = 0
)
(
    output reg [width-1:0] count,
    input  clk,
    input reset
);

    always @(posedge clk, posedge reset) begin
	if (reset)  count <= init_val;
	else        count <= count + increment;
    end

endmodule