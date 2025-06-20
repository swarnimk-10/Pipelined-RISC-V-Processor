`timescale 1ns / 1ps

module instruction_memory (
    input [31:0] addr,       
    output reg [31:0] instruction 
);

    reg [31:0] rom [0:255];
    integer i;

    initial begin
        // === Initialize test program ===

        // 0x00: addi x1, x0, 5      --> x1 = 5
        rom[0] = 32'h00500093;  // addi x1, x0, 5

        // 0x04: addi x2, x0, 10     --> x2 = 10
        rom[1] = 32'h00a00113;  // addi x2, x0, 10

        // 0x08: add x3, x1, x2      --> x3 = x1 + x2 (RAW hazard on x1, x2)
        rom[2] = 32'h002081b3;  // add x3, x1, x2

        // 0x0C: sub x4, x3, x1      --> x4 = x3 - x1 (depends on x3)
        rom[3] = 32'h4011a233;  // sub x4, x3, x1

        // 0x10: sw x4, 0(x2)        --> MEM[x2] = x4
        rom[4] = 32'h00412023;  // sw x4, 0(x2)

        // 0x14: lw x5, 0(x2)        --> x5 = MEM[x2]
        rom[5] = 32'h00012283;  // lw x5, 0(x2)

        // 0x18: or x6, x5, x4       --> x6 = x5 | x4 (load-use hazard on x5)
        rom[6] = 32'h0042b2b3;  // or x6, x5, x4

        // 0x1C: beq x6, x6, +8      --> branch always taken to 0x28 (Label)
        rom[7] = 32'h0062c263;  // beq x6, x6, +8

        // 0x20: addi x7, x0, 99     --> skipped due to branch
        rom[8] = 32'h06300393;  // addi x7, x0, 99

        // 0x24: addi x7, x0, 42     --> target of branch
        rom[9] = 32'h02a00393;  // addi x7, x0, 42

        // 0x28: jal x8, +8          --> jump to 0x30, store return address in x8
        rom[10] = 32'h008004ef; // jal x8, +8

        // 0x2C: addi x9, x0, 123    --> skipped due to jal
        rom[11] = 32'h07b00493; // addi x9, x0, 123

        // 0x30: addi x9, x0, 1      --> jump destination
        rom[12] = 32'h00100493; // addi x9, x0, 1

        // Clear rest of memory
        for (i = 13; i < 256; i = i + 1)
            rom[i] = 32'b0;
    end

    always @(*) begin
        instruction = rom[addr[9:2]];
    end

endmodule
