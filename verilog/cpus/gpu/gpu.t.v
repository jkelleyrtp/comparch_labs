`include "cpus/single_cycle/single_cycle.v"

// Uncomment the `define below to enable dumping waveform traces for debugging
//`define DUMP_WAVEFORM

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);


module cpu_test ();
	reg clk;
	cpu DUT(.clk(clk));

	// Generate (infinite) clock
	initial clk=0;
	always #10 clk = !clk;

	initial begin
		// Optionally dump waveform traces for debugging
		`ifdef DUMP_WAVEFORM
		  $dumpfile("cpu.vcd");
		  $dumpvars();
		`endif

		// Run three instructions
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
		@(posedge clk); #1
        
        $display("Reg $0: %d", DUT.REG.reg0);
        $display("Reg $1: %d", DUT.REG.reg1);
        $display("Reg $2: %d", DUT.REG.reg2);
        $display("Reg $3: %d", DUT.REG.reg3);
        $display("Reg $4: %d", DUT.REG.reg4);
        $display("Reg $5: %d", DUT.REG.reg5);
        $display("Reg $6: %d", DUT.REG.reg6);
        $display("Reg $7: %d", DUT.REG.reg7);
        $display("Reg $8: %d", DUT.REG.reg8);
        $display("Reg $9: %d", DUT.REG.reg9);
        $display("Reg $10: %d", DUT.REG.reg10);
        $display("Reg $11: %d", DUT.REG.reg11);
        $display("Reg $12: %d", DUT.REG.reg12);
        $display("Reg $13: %d", DUT.REG.reg13);
        $display("Reg $14: %d", DUT.REG.reg14);
        $display("Reg $15: %d", DUT.REG.reg15);
        $display("Reg $16: %d", DUT.REG.reg16);
        $display("Reg $17: %d", DUT.REG.reg17);
        $display("Reg $18: %d", DUT.REG.reg18);
        $display("Reg $19: %d", DUT.REG.reg19);
        $display("Reg $20: %d", DUT.REG.reg20);
        $display("Reg $21: %d", DUT.REG.reg21);
        $display("Reg $22: %d", DUT.REG.reg22);
        $display("Reg $23: %d", DUT.REG.reg23);
        $display("Reg $24: %d", DUT.REG.reg24);
        $display("Reg $25: %d", DUT.REG.reg25);
        $display("Reg $26: %d", DUT.REG.reg26);
        $display("Reg $27: %d", DUT.REG.reg27);
        $display("Reg $28: %d", DUT.REG.reg28);
        $display("Reg $29: %d", DUT.REG.reg29);
        $display("Reg $30: %d", DUT.REG.reg30);
        $display("Reg $31: %d", DUT.REG.reg31);


		#1 $finish();
	end
endmodule
