include ../../settings.mk

ICARUS_OPTS := -Wall
IVERILOG    := iverilog $(ICARUS_OPTS)
LINT        := verilator --lint-only
SIM         := vvp

# Pattern rule for compiling vvp (Icarus assembly) from a testbench
fake_cpu/fake_cpu.vvp: fake_cpu/%.vvp : fake_cpu/%.t.v 
	$(IVERILOG) -o $@ $<
