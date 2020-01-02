# Comparch Final: MIPS GPU
Jonathan Kelley


A simple Verilog implementation of a graphics processing unit (GPU) that can execute MIPS programs on array buffers of data. This final project is the last step in the progression of the MIPS CPU architecture. Several simultaneous programs written in a normal MIPS architecture can be queued for execution and then proocessed among a bank of "MIPS Cores" (analogous to an NVIDIA CUDA Core).

## Overview

The goals for the MIPS GPU include:
- Parallel execution of a single MIPS program among many ALUs/cores
    - This is the basis of graphics computing
    - This entails things like computation of complex functions and image processing

- Ability to handle multiple simultaneous programs 
    - Modern GPUs schedule programs and allow of allocation of several CUDA Cores

- Parametric Verilog design
    - It should be easy to change the size of the GPU including core count and ALU's per core.

In summary, the final GPU implementation should be able to perform the basic functions of what most people expect from a desktop GPU. However, this implementation will not be "general purpose" and cannot do particularly advanced calculations.

## Limitations

There are many limitations to designing a GPU architecture in Verilog. Real GPUs use a scheduler running on the host CPU to manage which programs can run at any given moment in time. However, this scheduling is relatively complicated to implement in Verilog. A basic hardware scheduler is implemented here which runs from a batch of memory. 

Another limitation of the Verilog design is the inability for the CPU to branch based on local values. Because the ALUs are synced with eachother on the execution of the same program, an individual ALU cannot branch in a way that is different from the other ALUs in the Core. All ALUs will branch exactly the same based on the values from the first ALU. This limitation is what prevents the ALU from being "General Purpose" - ifs and whiles just don't work properly. This limitation has also been present in real-world GPU implementations for a long time and has recently (~10 yrs) been fixed in consumer GPUs.

## Background and terminology

A primary personal goal for this final was for me to become more familiar with how modern GPU architectures are implemented. This required studying and understanding the terminology used by AMD and NVIDIA and becoming familiar with the basics of GPU organization. 

GPUs are devices capable of processing a wide buffer of data in few clock cycles by way of massive parallelization. While CPUs are serial in nature and would calculate the output buffer from an input buffer element-by-element, a GPU would use thousands of ALUs to perform the same calculation in a fraction of the time.

Common uses for GPU computing include image processing and numerical simulation as they tend to involve tasks that are easily parallelizable. A GPU will include a collection of "Cores" which are sets of ALUs that share a batch of local memory. Typically a kernel - GPU code - is written to be executed by a small number of GPU Cores. Each core dispatches the program on a set of ALUs with a hardware-defined identifier which can be referenced by the program. In our implementation, this ID is not accessible to the program, but rather is automatically granted to RT/RD/RS. While an address fetched by RD in the CPU implementation might be 0x100, the GPU implementation would fetch 0x100 + offset, so the programs don't notice the parallelization. Therefore, we can continue to use the same programs that run on the MIPS CPU and instantly see the benefits of parallelization. 

## Design

### Component Layout

The final leverages the SIMD ALU core designed in Lab 4 as the starting point for the additional complexity. This GPU implementation leverages a set of SIMD cores, each with their own cache, a VRAM (video memory) for mass storage of data, a GPU instruction memory, and a hardware-based queuing system. This mimics an actual setup on a host CPU.

![assets/gpu_design.png](assets/gpu_design.png)

### SIMD Cores

Each SIMD core is defined similarly to a CUDA Core with 16 ALUs per block. Each SIMD core is defined with a VRAM offset as to know its place in the group of cores. For now, we're doing 16 SIMD cores so we can processes 256 simultaneous computations.


### VRAM

In addition to the SIMD Cores, the GPU has a VRAM to store the input and output buffers of the ALUs. These provide globally accessible memory registers in rows of 32 bits that the ALUs can retrieve data from and push data into when performing computations.

For ease, the VRAM buffers are generated via a Python script so 

### Hardware queue

A simple software queue was written in Rust (under the rust folder), but isn't currently very flexible to handle calling the Verilog code with Rust arrays. With more time, this solution would be pretty nifty, allowing for compiled Verilog in a commandline format to be run with any kernel on any set of data. For now however, the programs are precompiled from MIPs and given additional attributes to be dispatched onto the ALU cores.

The hardware queue supports a "moving reference frame" by dispatching any available ALUs onto the maximum amount of data the GPU can process at once. This would be similar to requesting a desktop GPU to draw 12mb of frame data and the GPU can only actively draw 8mb. This would require two draw steps over multiple clock cycles. This is quite common in desktop GPUs as the sum of the cache in the cores might be lower than how much data the GPU is requested to draw to the screen.

Because of the moving reference frame design, the hardware queue can multithread multiple programs together across separate cores. Each core receives its program instructions and memory offsets that maximizes its own individual bandiwdth. However, this does mean that programs will stall eachother until completed. On each clock cycle, the 

### Instruction Memory

The instruction memory of the GPU is just a binary file of 32 bit width instructions in MIPS format with headers and footers for each program. Each program is compiled and then appended to one another. The headers of each program detail how long the program is, how much space the buffers take up, and the buffer start locations. This gives the queue enough information to distribute the tasks among the GPU cores.

## Performance

As with all data processing techniques, this design has several pros and cons to its performance. This particular GPU design excels at large data sets and can gracefully handle situations where the input buffers are larger than the GPU can handle at any given moment. 

While the the moving reference frame approach is good at breaking down large datasets, it is particularly bad at handling several different simultaneous programs. Small programs quickly take up the SIMD cores and use entire blocks of 16 ALUs at once, even when they don't need them all.

![]()

## Lessons Learned

It was not particularly easy implementing the more advanced aspects of the GPU architecture. Despite the difficulties, the design challenge was extremely intersting and encouraged research into modern architecture. Different brands and configurations of GPUs come with different controllers and even require their own programming languages to function. 

Previous work in sequential circuit design was especially helpful in figuring out the hardware queue system. Going forward, I'd like to add the ability to pipeline instructions in the SIMD cores as well as implement a better parametric layout.