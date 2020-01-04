// This module looks and feels like an ALU but actually contains many ALUs
// Because of the SIMD behavior, each simdcore takes in buffers of operandA, operandB, and results


`include "modules/alu/alu.v"



module simdcore 
#(parameter ALUWIDTH=16)
(
    // Compatability to drop it into a normal ALU slot
    // output[31:0]  result,
    // output        	iszero,
    // output        	overflow,
    // input[31:0]   operandA,
    // input[31:0]   operandB,

    input[2:0]    	command,

    // Extended version for the multiple ALUs
    output [(32*ALUWIDTH)-1:0] result_s,
    output [ALUWIDTH-1:0] iszero_s,
    output [ALUWIDTH-1:0] overflow_s,
    input [(32*ALUWIDTH)-1:0] OperandA_s,
    input [(32*ALUWIDTH)-1:0] OperandB_s
);

    // reg [31:0] mem [ALUWIDTH:0];

    // Set up the first ALU as the leader
    // alu ALU(.result(result),                        
    //         .iszero(iszero), 
    //         .overflow(overflow), 
    //         .operandA(operandA),                             
    //         .operandB(operandB),                        
    //         .command(command));  

    // Fill the output array with the results and such
    // assign results_s = result;
    // assign iszero_s[31:0] = iszero;
    // assign overflow_s[31:0] = overflow;

    genvar i;
    generate
        for (i=0; i<ALUWIDTH; i=i+1) begin : loop_gen_block

            wire [31:0] local_result;
            wire local_zero;
            wire local_overflow;


            wire [31:0] local_opA;
            wire [31:0] local_opB;

            assign local_opA[31:0] = OperandA_s[ (32 * (i+1) ) -1 : (32 * (i)) ];
            assign local_opB[31:0] = OperandB_s[ (32 * (i+1) ) -1 : (32 * (i)) ];
            
            
            alu ALU(.result(local_result),                        
                    .iszero(local_zero), 
                    .overflow(local_overflow), 
                    .operandA( local_opA ),                             
                    .operandB(local_opB),                        
                    .command(command));  

            assign result_s[(32 * (i+1) ) -1 : (32 * (i))] = local_result;
            
        end
    endgenerate

    // assign result_s = 32'b0;
endmodule