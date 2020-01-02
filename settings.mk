# Project-specific settings

## Assembly settings

# Assembly program (minus .asm extension)
# PROGRAM := BEQ_BNE
PROGRAM := powerOf2
# Possible Program Options

# Memory image(s) to create from the assembly program
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex


## Verilog settings

# Top-level module/filename (minus .v/.t.v extension)
CPU := single_cycle
TOPLEVEL := cpus/$(CPU)/$(CPU)



# All circuits included by the toplevel $(TOPLEVEL).t.v
CIRCUITS := verilog/cpus/$(CPU)/$(CPU).t.v \
			verilog/modules/counter/counter.v \
			verilog/modules/memory/memory.v