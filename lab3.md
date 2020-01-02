# Lab3: MIPS CPU
### Jonathan Kelley

## Overview

For Lab 3, we were challenged to implement the MIPS processor design in behavorial and structural verilog. The final CPU would need to implement a subset of MIPS:

	LW, SW, J, JR, JAL, BEQ, BNE, XORI, ADDI, ADD, SUB, SLT

## Testing Process

Many different modules were required to get the CPU running. As shown above in the datapath, the device includes:

- Finite State Machine (control)
- Arithmetic Logic Unit
- Instruction Decoder
- Memory
- Regfile
- Program Counter
- Sign extender

My first tests were designed around ensuring the basic functionality of the modules. I wrote simple unit tests for sign extend and pulled in tests for the ALU and Regfile. Once happy with the modules and their correctness, I started to assemble the modules piece by piece to satisfy the simple instruction sets. The "I" set was easy to start with, and then I began to wire the R types, adding muxes where code was different. It was incredibly helpful to have a simplified datapath for each instruction as the muxes simply fell into place. I ended up having to add additional control signals to my FSM, but everything was fairly clean.

From there, I ran a few simple lines in MARS and watched how the registers changed. There were a few timing issues to work out as not all the registers would change within the expected clock count. I had to add an @(*) in some places which is pretty bad practice, but it made the timings work. A major issue I ran into was actually an issue with the regfile. I hadn't noticed early on that the muxes needed to 

Running `make` from the top directory will compile the verilog for the target CPU (choose in `settings.mk`), setup gtkwave/vcddump, and run the CPU with selected mem file in the asm folder. I had to use the python script in asm to convert some of the MARS assembled code into a complete memory definition for the CPU tests to run.

To load new programs into the CPU, modify the python script by adding a new "program" entry with a list of hex values for the assembled instructions. 

## Outside Help

Having dealt with family issues during the busiest part of the course, I fell behind and didn't have a group to work with for this project. Solomon and Navi both helped with issues I had in the regfile and the jump and link portions of the CPU.
