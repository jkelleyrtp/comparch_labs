`include "alu.v"

module alu_test ();

	wire [31:0] result;
	wire carryout;
	wire iszero;
	wire overflow;

	reg [31:0] operandA;
	reg [31:0] operandB;
	reg [2:0] command;

	alu DUT(.result(result),  
			.iszero(iszero), 
			.overflow(overflow), 
			.operandA(operandA), 
			.operandB(operandB), 
			.command(command));
	
	 initial begin

	    command = `ADD_; operandA = 32'd21; operandB = 32'd21; #1
        $display("Result: %b, expexcted: %b, Basic addition test", result, 32'd42);
        $display("Result: %b, expexcted: %b, Overflow addition test", overflow, 1'b0);
        
	    command = `ADD_; operandA = 32'd2147483647; operandB = 32'd2147483647; #1
	    $display("Result: %b, expexcted: %b, Max addition", overflow, 1'b1);

	    command = `SUB_; operandA = 32'd1000; operandB = 32'd998; #1
	    $display("Result: %b, expexcted: %b, Simple Subtraction", result, 32'd2);
	    
	    command = `SUB_; operandA = 32'd1111; operandB = 32'd1112; #1
	    $display("Result: %b, expexcted: %b, Twos complement", result, 32'b11111111111111111111111111111111);

	   	command = `XOR_; operandA = 32'b1111; operandB = 32'b1111; #1
	    $display("Result: %b, expexcted: %b, xor same number", result, 32'd0);
	   	
	   	command = `XOR_; operandA = 32'b1011; operandB = 32'b1001; #1
	    $display("Result: %b, expexcted: %b, xor diff number", result, 32'b1100);

	   	command = `AND_; operandA = 32'b0011; operandB = 32'b1100; #1
	    $display("Result: %b, expexcted: %b, AND Diff numbers", result, operandA & operandB);
	    
	   	command = `SLT_; operandA = 32'b0011; operandB = 32'b1111; #1
	    $display("Result: %b, expexcted: %b, SLT diff numbers", result, 32'b1);

	   	command = `NAND_; operandA = 32'b1011; operandB = 32'b0111; #1
	    $display("Result: %b, expexcted: %b, nand diff", result, ~(operandA & operandB));
	    
	   	command = `NOR_; operandA = 32'b1101010011; operandB = 32'b100011111; #1
	    $display("Result: %b, expexcted: %b, nor diff", result, ~(operandA | operandB));

	   	command = `OR_; operandA = 32'b10011011; operandB = 32'b1111; #1
	    $display("Result: %b, expexcted: %b, or diff", result, (operandA | operandB));	    
	 end

endmodule