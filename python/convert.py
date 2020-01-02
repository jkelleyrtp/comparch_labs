import os

# LCM
program = [
    0x20080006,
    0x20090004,
    0x00085020,
    0x00095820,
    0x114b0007,
    0x014b602a,
    0x20010001,
    0x102c0002,
    0x01695820,
    0x0800000b,
    0x01485020,
    0x08000004,
    0x01401020,
]

# Multiplier
program = [
    0x20080005,
    0x20090005,
    0x200a0000,
    0x200b0000,
    0x11690003,
    0x01485020,
    0x216b0001,
    0x08000004,
    0x000a1020,
]

# Power of 2
program = [
    0x20040005,
    0x20080001,
    0x20010000,
    0x10240004,
    0x01084020,
    0x20010001,
    0x00812022,
    0x08000002,
    0x00081020,
]


with open("progmem.mem", "w") as output:
# with open("converted.mem", "w") as output:
    for line in program:
        bin_val = str(bin(line))

        # blank_val[32-bin_val.len:-1] = bin_val
        print("len of {} is {}".format(bin_val, len(bin_val)))

        line_out = "0" * (34-len(bin_val)) + bin_val[2:]

        output.write(line_out + "\n")
    output.write((("0"*32) + "\n") * (4096-len(program)))