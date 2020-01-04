`include "modules/simd_core/core.v"
// From the top level directory:
// iverilog -o modules/simd_core/out.a modules/simd_core/core.t.v && ./modules/simd_core/out.a

module simd_core_test();

    parameter ALUWIDTH = 4;

    wire [31:0] alu_result;
    wire iszero;
    wire overflow;
    reg [31:0] operandA;
    reg [31:0] operandB;
    reg [2:0] command;

    // Set up the memory
    reg [31:0] OperandA_s [ALUWIDTH-1:0];
    reg [31:0] OperandB_s [ALUWIDTH-1:0];

    // Allow passing the memory directly to the module
    wire [(32 * ALUWIDTH) - 1 : 0] OperandA_s_;
    wire [(32 * ALUWIDTH) - 1 : 0] OperandB_s_;
    wire [(32 * ALUWIDTH) - 1 : 0] result_s;
    // wire [(32 * ALUWIDTH) - 1 : 0] result_s;

    // Intermediately assign the Operands
    genvar i;
    for (i=0; i< ALUWIDTH; i=i+1) assign OperandA_s_[(32*(i+1))-1:(32*(i))] = OperandA_s[i];
    for (i=0; i< ALUWIDTH; i=i+1) assign OperandB_s_[(32*(i+1))-1:(32*(i))] = OperandB_s[i];


    simdcore #(.ALUWIDTH(ALUWIDTH)) SIMDCORE_block (
        // .result(alu_result),
        // .iszero(iszero),
        // .overflow(overflow),
        // .operandA(operandA),
        // .operandB(operandB),
        .command(command),

        // Extended version for the multiple ALUs
        .result_s(result_s),
        .iszero_s(iszero_s),
        .overflow_s(overflow_s),
        .OperandA_s(OperandA_s_),
        .OperandB_s(OperandB_s_)
    );
    
    reg [31:0] op_index;
    initial begin
        // Load in the operands
        $readmemb("modules/simd_core/operandAs.mem", OperandA_s);
        $readmemb("modules/simd_core/operandBs.mem", OperandB_s);

        op_index = 2; # 10
        $display("OperandA_s: %b", OperandA_s_[32*op_index +: 32] );
        $display("OperandB_s: %b", OperandB_s_[(32*op_index) +:32]);

        command = `ADD_; #10
        $display("Reults: %b", result_s[(32*op_index) +:32]);

        // $display("Local opA: %b", SIMDCORE_block.loop_gen_block[0].local_opA );
        // $display("Local opB: %b", SIMDCORE_block.loop_gen_block[0].local_opB );

        // $display("Inner result: %b", SIMDCORE_block.loop_gen_block[0].local_result );
        // $display("Result: %b, expexcted: %b, Basic addition test", result_s[0]);
    end
endmodule