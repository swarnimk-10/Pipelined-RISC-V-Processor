`timescale 1ns / 1ps

module mem_wb_register (
    input clk,
    input [1:0] ResultSrcM,
    input RegWriteM,
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [4:0] RdM,
    input [31:0] PCPlus4M,
    output reg [1:0] ResultSrcW,
    output reg RegWriteW,
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0] RdW,
    output reg [31:0] PCPlus4W
);
    always @(posedge clk) begin
        ResultSrcW <= ResultSrcM;
        RegWriteW <= RegWriteM;
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
    end
endmodule