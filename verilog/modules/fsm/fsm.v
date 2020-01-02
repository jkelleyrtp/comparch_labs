`include "modules/fsm/fsmdefs.v"
module fsm
    (
        output reg  RegWrite, ALUSrc, 
        output reg [1:0] RegDest, MemToReg,
        output reg [2:0] ALUOp, 
        output reg MemWrite, MemRead, Branch, InvBranchCond, Jump, Link,
        input [5:0] OP, 
        input [5:0] funct
    );

    // In each begin/end block, set the control signals
    // for each op code.
    always @(OP, funct) begin
        // Here we zero everything to prevent any undetermined control signals messing with the datapath
        RegDest = `REG_DEST_RT;
        RegWrite = 1'b0;
        ALUSrc = `ALU_SRC_RT;
        ALUOp = `ADD_;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        MemToReg = `MEM_TO_REG_FROM_ALU;
        Branch = 1'b0;
        InvBranchCond = 1'b0;
        Jump = 1'b0;
        Link = 1'b0;
        case (OP)
            `RTYPE_OP:	begin 
                RegDest = `REG_DEST_RD;
                RegWrite = 1'b1;
                ALUSrc = `ALU_SRC_RT; 
                MemToReg = `MEM_TO_REG_FROM_ALU;
                case (funct)
                    `ADD_FUNCT: begin
                        ALUOp = `ADD_;
                    end
                    `SUB_FUNCT: begin
                        ALUOp = `SUB_;
                    end
                    `SLT_FUNCT: begin
                        ALUOp = `SLT_;
                    end
                    `AND_FUNCT: begin
                        ALUOp = `AND_;
                    end
                    `OR_FUNCT: begin
                        ALUOp = `OR_;
                    end
                    `NOR_FUNCT: begin
                        ALUOp = `NOR_;
                    end
                    `XOR_FUNCT: begin
                        ALUOp = `XOR_;
                    end
                    `JR_FUNCT: begin
                        RegWrite = 1'b0;
                        Jump = 1'b1;
                        ALUSrc = `ALU_SRC_RT;
                        ALUOp = `ADD_;
                    end
                endcase
            end
            `ADDI_OP: begin
                RegDest = `REG_DEST_RT;
                RegWrite = 1'b1;
                ALUSrc = `ALU_SRC_IMM;
                ALUOp = `ADD_;
                MemToReg = `MEM_TO_REG_FROM_ALU;
            end
            `XORI_OP: begin
                RegDest = `REG_DEST_RT;
                RegWrite = 1'b1;
                ALUSrc = `ALU_SRC_IMM;
                ALUOp = `XOR_;
                MemToReg = `MEM_TO_REG_FROM_ALU;
            end
            `LW_OP: begin
                RegDest = `REG_DEST_RT;
                RegWrite = 1'b1;
                ALUSrc = `ALU_SRC_IMM;
                ALUOp = `ADD_;
                MemRead = 1'b1;
                MemToReg = `MEM_TO_REG_FROM_MEM;
            end
            `SW_OP: begin
                ALUSrc = `ALU_SRC_IMM;
                ALUOp = `ADD_;
                MemWrite = 1'b1;
            end
            `BEQ_OP: begin
                ALUSrc = `ALU_SRC_RT;
                ALUOp = `SUB_;
                Branch = 1'b1;
            end
            `BNE_OP: begin
                ALUSrc = `ALU_SRC_RT;
                ALUOp = `SUB_;
                Branch = 1'b1;
                InvBranchCond = 1'b1;
            end
            `J_OP: begin
                Jump = 1'b1;
                ALUSrc = `ALU_SRC_IMM;
            end
            `JAL_OP: begin
                Jump = 1'b1;
                Link = 1'b1;
                RegWrite = 1'b1;
                MemToReg = `MEM_TO_REG_FROM_PC;
                RegDest = `REG_DEST_LINK;
                ALUSrc = `ALU_SRC_IMM;
            end
        endcase
    end
endmodule
