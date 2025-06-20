# Pipelined-RISC-V-Processor
This project implements a 32 bit 5 stage pipelined RISC-V Processor in Verilog using Xilinx Vivado. It supports all intrsuction formats along with a hazard handling and forwarding unit.

## Features:

- Implements 5-stage pipeline: IF, ID, EX, MEM, WB
- Instruction support:
  - addi, add, sub, lw, sw, or, beq, jal
- Hazard handling:
  - **Stalling**: for load-use cases
  - **Flushing**: for branch and jump mispredictions
  - **Forwarding**: for data dependencies
    
## Architecture

![Screenshot 2025-06-20 180428](https://github.com/user-attachments/assets/da2f5e29-54b3-4b48-a93c-5862cc5cdeb9)

## Simulation Results

![Screenshot 2025-06-20 173926](https://github.com/user-attachments/assets/ca6c9a3b-4e3e-4e72-81ce-70cff0263542)

## Schematic

![Screenshot 2025-06-20 175853](https://github.com/user-attachments/assets/ee3828bc-9728-471b-bf1c-c5fa61ba2179)

## Pre-Loaded Instructions in Instruction Memory

addi x1, x0, 5       # x1 = 5

addi x2, x0, 10      # x2 = 10

add  x3, x1, x2      # x3 = 15

sub  x4, x3, x1      # x4 = 10

sw   x4, 0(x2)       # MEM[10] = 10

lw   x5, 0(x2)       # x5 = MEM[10]

or   x6, x5, x4      # x6 = x5 | x4

beq  x6, x6, +8      # branch to 0x28

addi x7, x0, 99      # skipped

addi x7, x0, 42      # x7 = 42

jal  x8, 8           # jump to 0x30

addi x9, x0, 123     # skipped

addi x9, x0, 1       # x9 = 1
