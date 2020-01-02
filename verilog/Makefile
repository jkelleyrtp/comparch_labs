include ../settings.mk

ICARUS_OPTS := -Wall
IVERILOG    := iverilog $(ICARUS_OPTS)
LINT        := verilator --lint-only
SIM         := vvp

# Pattern rule for compiling vvp (Icarus assembly) from a testbench
cpus/$(CPU)/$(CPU).vvp: cpus/$(CPU)/%.vvp: cpus/$(CPU)/%.t.v
	$(IVERILOG) -o $@ $<

run:
	$(SIM) cpus/$(CPU)/$(CPU).vvp
	
	# $(SIM) cpus/$(CPU)/$(CPU).vvp +mem_text_fn=../asm/$(TEXTMEMDUMP) \
	# 						+mem_data_fn=../asm/$(DATAMEMDUMP) \
	# 						+dump_fn=$@

# Shortcut (phony) targets for convenience
compile:
	cpus/$(CPU)/$(CPU).vvp

clean:
	-rm -f cpus/$(CPU)/$(CPU).vvp

.PHONY: clean compile run
