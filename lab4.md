# Lab 4: Multi-ALU 

Improvement on the CPU that adds vectorization support. Multiple ALUs are executed simultaneously for more number-crunching per clock cycle

## Overview and Motivation

The Multi-ALU MIPS CPU is designed to allow vector operations in hardware. For the final project, I plan to implement a Graphics Processing Unit which uses several "GPU Cores" to perform parallel computation on dynamic sets of data. Before implementing things like a scheduler and queue system, I first need to design a way of performing Single Instruction Multiple Data (SIMD) operations in hardware.

This lab builds upon the learnings in Lab 3 to implement parametric SIMD design. The final product of this lab will be a single parametric GPU core that has local memory and can perform SIMD operations.

## Design

The design of the the SIMD core is fairly straightforward. Each instruction fetch by the Core logic controller is given an offset in hardware. Each memory address loaded by the SR/ST/SD from the memory read is loaded into the SIMD Core memory - a local cache of CPU memory that is directly connected to the corresponding ALUs. This allows us to reuse existing MIPS programs without having to reprogram anything. 

![assets/simdcore.png](assets/simdcore.png)

As shown above, each ALU core is synced to the same clock and the same control unit. The regfile has been expanded to include a buffer large enough for all of the ALUs to have an A, B, and Res slot. While the CPU regfile might be maybe about 108 bits large, the GPU cache might have about 200 bytes of space for 16 ALUs.

Overall, the SIMD core is essentially just a MIPS CPU with extra ALUs and an extended regfile.