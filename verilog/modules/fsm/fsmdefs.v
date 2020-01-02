`define RTYPE_OP 6'b000000

`define ADDI_OP 6'b001000
`define XORI_OP 6'b001110

`define LW_OP 6'b100011
`define SW_OP 6'b101011

`define BEQ_OP 6'b000100 // I-type instructions
`define BNE_OP 6'b000101 

`define J_OP 6'b000010 // J-type instructions
`define JAL_OP 6'b000011

`define JR_FUNCT   6'h8
`define ADD_FUNCT  6'h20
`define SUB_FUNCT  6'h22
`define XOR_FUNCT  6'h26
`define SLT_FUNCT  6'h2A
`define AND_FUNCT  6'h24
`define NOR_FUNCT  6'h27
`define OR_FUNCT   6'h25

// ALU commands
`define ADD_  3'd0
`define SUB_  3'd1
`define XOR_  3'd2
`define SLT_  3'd3
`define AND_  3'd4
`define NOR_  3'd6
`define OR_   3'd7

// Control signal definitions

`define REG_DEST_RT 2'b0
`define REG_DEST_RD 2'b1
`define REG_DEST_LINK 2'b10

`define ALU_SRC_RT 1'b0
`define ALU_SRC_IMM 1'b1

`define MEM_TO_REG_FROM_ALU 2'b0
`define MEM_TO_REG_FROM_MEM 2'b1
`define MEM_TO_REG_FROM_PC 2'b10
