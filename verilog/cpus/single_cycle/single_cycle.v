`include "modules/fsm/fsm.v"
`include "modules/memory/memory.v"
`include "modules/regfile/regfile.v"
`include "modules/signextend/signextend.v"
`include "modules/pc/pc.v"
`include "modules/alu/alu.v"
`include "modules/decoder/decoder.v"

module cpu (
    input clk
);

    // Initialize the FSM
    // Intiailize the Regfile
    // Intialize the ALU
    // Initialize the memory
    // Intialzie the Program Counter
    // Intialize the sign extension
    // Intialize the Muxes

    // FSM Definitions
    wire [5:0] OP;
    wire RegWrite;
    wire [1:0] RegDest, MemToReg;
    wire [2:0] ALUOp;
    wire ALUSrc; // Mux select

    reg [31:0] mem_data_addr;
    reg [31:0] mem_data_in;
    reg MemWriteReg;
    wire MemWriteFSM;
    wire MemWrite;

    // Initialize the ALU
    wire [31:0] alu_result;
    wire iszero;
    wire overflow;
    wire [31:0] operandA;
    reg [31:0] operandB;

    // Memory Definitions
    reg [31:0] PC;
    wire [31:0] instruction;

    wire [31:0] data_out;
    reg [31:0] data_in;
    reg [31:0] data_addr;

    // Instruction Fetch definitions
    wire [4:0] rs;
    wire [4:0] rt;                    
    wire [4:0] rd;                     
    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] imm;
    wire [25:0] jaddr;
    wire [31:0] code;


    // Initialize the Register 
    wire [31:0] Operand_a;                    
    wire [31:0] Operand_b;                    
    reg  [31:0] Write_target;                    
    reg  [4:0] Target_register;                     

    regfile REG
    (
        .ReadData1(Operand_a),            
        .ReadData2(Operand_b),            
        .WriteData(Write_target),            
        .ReadRegister1(rs),            
        .ReadRegister2(rt),            
        .WriteRegister(Target_register),         
        .RegWrite(RegWrite),
        .Clk(clk)                    
    );

    // Program Counter
    reg [31:0] pc_input;
    wire [31:0] pc_output;
    // Link address for JAL
    reg [31:0] pc_link;

    programcounter PROGCNT(
        .addr_out(pc_output),
        .addr_in(pc_input),
        .clk    (clk)
    );

    // Data and Program Counter Memory
    memory MEM( .PC         (pc_output),
                .instruction(instruction), 
                .data_out   (data_out),
                .data_in    (mem_data_in),              
                .data_addr  (mem_data_addr),            
                .clk        (clk),                      
                .wr_en      (MemWriteReg));

    // ALU
    alu ALU(.result(alu_result),                        
            .iszero(iszero), 
            .overflow(overflow), 
            .operandA(Operand_a),                             
            .operandB(operandB),                        
            .command(ALUOp));                           

    decoder dec(OP, rs, rt, rd, shamt, funct, imm, jaddr, instruction); 

    // Initialize the sign extension
    wire [31:0] se_out;
    signextend SE(.se (se_out), .imm(imm));

    // FSM
    fsm FSM(.RegDest(RegDest),
            .RegWrite     (RegWrite),
            .ALUSrc       (ALUSrc),
            .ALUOp        (ALUOp), 
            .MemWrite     (MemWriteFSM),
            .MemRead      (MemRead),
            .MemToReg     (MemToReg),
            .Branch       (Branch),
            .InvBranchCond(InvBranchCond),
            .Jump         (Jump),
            .Link         (Link),
            .OP           (OP),
            .funct        (funct));

    // Handle all of the muxes in the circuit
    // Things that need to be continuously updated
    always @* begin
        // Interface with the memory
        MemWriteReg <= MemWriteFSM;
        mem_data_addr <= alu_result;
        mem_data_in <= Operand_b;

        // Set the ALUSrc mux
        case (ALUSrc)
            `ALU_SRC_IMM: begin 
                        operandB <= se_out;
                    end
            `ALU_SRC_RT: begin
                        operandB <= Operand_b;
                    end
        endcase

        // Interface with the reg destination based on the instruction type
        case (RegDest)
            `REG_DEST_RD: begin 
                    Target_register <= rd;
                end
            `REG_DEST_RT: begin
                    Target_register <= rt;
                end
            `REG_DEST_LINK: begin
                    Target_register <= 5'd31;
                end
        endcase
    
        // Inteface with the mux that moves data from the memory into the regfile
        case (MemToReg)
            `MEM_TO_REG_FROM_ALU: begin 
                        Write_target <= alu_result;
                    end
            `MEM_TO_REG_FROM_MEM: begin
                        Write_target <= data_out;
                    end
            `MEM_TO_REG_FROM_PC: begin
                        Write_target <= pc_output + 32'd8;
                    end
        endcase

    
        // Handle the jump and linking
        // Thanks to Solomon for the tutorial on how to do this properly
        if (Jump) begin
            if (ALUSrc == `ALU_SRC_RT) begin // JR instruction - next addr is going to be ALU output
                pc_input = alu_result;
            end else begin // J or JAL instruction
                if (Link) begin
                    pc_link = pc_output + 32'd8;
                end
                pc_input = {pc_output[31:28], jaddr<<2};
            end
        end else if (Branch) begin
            if (iszero != InvBranchCond) begin
                pc_input = pc_output + 4 + (se_out<<2);
            end else begin // J or JAL instruction
                pc_input = pc_output + 32'd4;
            end
        end else begin
            pc_input = pc_output + 32'd4;
        end        
    end


endmodule
