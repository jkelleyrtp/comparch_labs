`include "modules/counter/counter.v"
`include "modules/memory/memory.v"
//------------------------------------------------------------------------
// Fake CPU with three "pipeline stages" A -> B -> C
//------------------------------------------------------------------------

module fake_cpu
(
    input clk,
    input reset
);

    //--------------------------------------------------------------------
    // Stage A - "Instruction Fetch"

    wire [31:0] PC_A;
    wire [31:0] INS_A;

    // Simplified PC generation unit - increments by 4 every cycle
    counter #(.width(32), .increment(4)) pc_incr(.count(PC_A), 
	                                         .clk(clk),
						 .reset(reset));


    // CPU memory
    //   In this fake CPU we only use the instruction port, so the data port
    //   signals are left unused (you will use them in your CPU for LW/SW)
    memory cpumem(.PC(PC_A), .instruction(INS_A),
	          .data_out(), .data_in(32'b0), .data_addr(32'b0),
		  .clk(clk),
		  .wr_en(1'b0)  // Disable data writes (unused in this example)
	         );


    //--------------------------------------------------------------------
    // Stages B and C - fake functionality to see more signals propagate

    reg [31:0] PC_B, PC_C;
    reg [31:0] INS_B, INS_C;

    // Op-code is the upper 6 bits, for all instruction formats
    wire [5:0] OP_B;
    reg  [5:0] OP_C;
    assign OP_B = INS_B[31:26];

    // Funct code is the lowest 6 bits for R type (not meaningful for others)
    wire [5:0] FUNCT_C;
    assign FUNCT_C = INS_C[5:0];

    // Register addresses (not meaningful for J-type instructions) 
    wire [4:0] RS_C, RT_C;
    assign RS_C = INS_C[25:21];
    assign RT_C = INS_C[20:16];


    //--------------------------------------------------------------------
    // Registers between pipeline stages
    
    always @(posedge clk) begin
	// A-B registers
        PC_B  <= PC_A;
	INS_B <= INS_A;

	// B-C registers
        PC_C  <= PC_B;
	INS_C <= INS_B;
	OP_C  <= OP_B;
    end

endmodule