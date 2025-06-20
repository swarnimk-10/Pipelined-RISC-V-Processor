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

| Address | Machine Code      | Assembly           | Description                        |
|---------|-------------------|--------------------|------------------------------------|
| 0x00    | `00500093`        | `addi x1, x0, 5`   | x1 ← 5                             |
| 0x04    | `00a00113`        | `addi x2, x0, 10`  | x2 ← 10                            |
| 0x08    | `002081b3`        | `add x3, x1, x2`   | x3 ← x1 + x2 = 15                  |
| 0x0C    | `4011a233`        | `sub x4, x3, x1`   | x4 ← x3 - x1 = 10                  |
| 0x10    | `00412023`        | `sw x4, 0(x2)`     | MEM[x2] ← x4 (MEM[10] = 10)        |
| 0x14    | `00012283`        | `lw x5, 0(x2)`     | x5 ← MEM[x2] = 10                  |
| 0x18    | `0042b2b3`        | `or x6, x5, x4`    | x6 ← x5 \| x4 = 10 \| 10 = 10      |
| 0x1C    | `0062c263`        | `beq x6, x6, +8`   | Branch always taken → jump to 0x28|
| 0x20    | `06300393`        | `addi x7, x0, 99`  | _Skipped due to branch_           |
| 0x24    | `02a00393`        | `addi x7, x0, 42`  | x7 ← 42                            |
| 0x28    | `008004ef`        | `jal x8, 8`        | x8 ← 0x2C; jump to 0x30            |
| 0x2C    | `07b00493`        | `addi x9, x0, 123` | _Skipped due to jal_              |
| 0x30    | `00100493`        | `addi x9, x0, 1`   | x9 ← 1                             |
