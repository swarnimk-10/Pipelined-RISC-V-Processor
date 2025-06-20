`timescale 1ns / 1ps

module data_memory (
    input        clk,
    input        rst,
    input [31:0] ALUResultM,    
    input [31:0] WriteDataM,    
    input        MemWriteM,    
    output reg [31:0] ReadDataM 
);

    reg [31:0] memory [0:4095];
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i + 1)
            memory[i] = 32'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4096; i = i + 1)
                memory[i] <= 32'b0;
        end else if (MemWriteM) begin
            memory[ALUResultM[13:2]] <= WriteDataM;
        end
    end

    // Asynchronous read
    always @(*) begin
        ReadDataM = memory[ALUResultM[13:2]];
    end

endmodule
