//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------
`include "modules/regfile/regfilemodules/muxdecoder.v"
`include "modules/regfile/regfilemodules/register.v"


module regfile (
  output[31:0]	ReadData1,	// Contents of first register read
  output[31:0]	ReadData2,	// Contents of second register read
  input[31:0]	WriteData,	// Contents to write to register
  input[4:0]	ReadRegister1,	// Address of first register to read
  input[4:0]	ReadRegister2,	// Address of second register to read
  input[4:0]	WriteRegister,	// Address of register to write
  input		RegWrite,	// Enable writing of register when High
  input		Clk		// Clock (Positive Edge Triggered)
);

  wire[31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;
  wire[31:0] reg_select;

  decoder1to32 decoder( reg_select, RegWrite, WriteRegister);

  register32zero reg_select0(reg0, WriteData, reg_select[0], Clk);
  register32 reg_select1(reg1, WriteData, reg_select[1], Clk);
  register32 reg_select2(reg2, WriteData, reg_select[2], Clk);
  register32 reg_select3(reg3, WriteData, reg_select[3], Clk);
  register32 reg_select4(reg4, WriteData, reg_select[4], Clk);
  register32 reg_select5(reg5, WriteData, reg_select[5], Clk);
  register32 reg_select6(reg6, WriteData, reg_select[6], Clk);
  register32 reg_select7(reg7, WriteData, reg_select[7], Clk);
  register32 reg_select8(reg8, WriteData, reg_select[8], Clk);
  register32 reg_select9(reg9, WriteData, reg_select[9], Clk);
  register32 reg_select10(reg10, WriteData, reg_select[10], Clk);
  register32 reg_select11(reg11, WriteData, reg_select[11], Clk);
  register32 reg_select12(reg12, WriteData, reg_select[12], Clk);
  register32 reg_select13(reg13, WriteData, reg_select[13], Clk);
  register32 reg_select14(reg14, WriteData, reg_select[14], Clk);
  register32 reg_select15(reg15, WriteData, reg_select[15], Clk);
  register32 reg_select16(reg16, WriteData, reg_select[16], Clk);
  register32 reg_select17(reg17, WriteData, reg_select[17], Clk);
  register32 reg_select18(reg18, WriteData, reg_select[18], Clk);
  register32 reg_select19(reg19, WriteData, reg_select[19], Clk);
  register32 reg_select20(reg20, WriteData, reg_select[20], Clk);
  register32 reg_select21(reg21, WriteData, reg_select[21], Clk);
  register32 reg_select22(reg22, WriteData, reg_select[22], Clk);
  register32 reg_select23(reg23, WriteData, reg_select[23], Clk);
  register32 reg_select24(reg24, WriteData, reg_select[24], Clk);
  register32 reg_select25(reg25, WriteData, reg_select[25], Clk);
  register32 reg_select26(reg26, WriteData, reg_select[26], Clk);
  register32 reg_select27(reg27, WriteData, reg_select[27], Clk);
  register32 reg_select28(reg28, WriteData, reg_select[28], Clk);
  register32 reg_select29(reg29, WriteData, reg_select[29], Clk);
  register32 reg_select30(reg30, WriteData, reg_select[30], Clk);
  register32 reg_select31(reg31, WriteData, reg_select[31], Clk);

  // // Read out specified register to the ReadData1 output
  mux32to1by32 write1( ReadData1, ReadRegister1,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31);
  
  // // Read out specified register to the ReadData1 output
  mux32to1by32 write2( ReadData2, ReadRegister2,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31);

endmodule