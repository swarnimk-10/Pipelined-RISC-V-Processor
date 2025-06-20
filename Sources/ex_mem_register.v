`timescale 1ns / 1ps

module ex_mem_register (
    input clk,
    input        RegWriteE,
    input [1:0]  ResultSrcE,
    input        MemWriteE,
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,  
    input [4:0]  RdE,
    input [31:0] PCPlus4E,
    output reg       RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg       MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0]  RdM,
    output reg [31:0] PCPlus4M
);

    always @(posedge clk) begin
        RegWriteM   <= RegWriteE;
        ResultSrcM  <= ResultSrcE;
        MemWriteM   <= MemWriteE;
        ALUResultM  <= ALUResultE;
        WriteDataM  <= WriteDataE;
        RdM         <= RdE;
        PCPlus4M    <= PCPlus4E;
    end

endmodule
