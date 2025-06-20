`timescale 1ns / 1ps

module id_ex_register (
    input clk,
    input clr,

    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input [2:0] ALUControlD,
    input ALUSrcD,

    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] PCD,
    input [4:0]  Rs1D,
    input [4:0]  Rs2D,
    input [4:0]  RdD,
    input [31:0] ImmExtD,
    input [31:0] PCPlus4D,

    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,

    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] PCE,
    output reg [4:0]  Rs1E,
    output reg [4:0]  Rs2E,
    output reg [4:0]  RdE,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCPlus4E
);

    always @(posedge clk) begin
        if (clr) begin
            RegWriteE   <= 0;
            ResultSrcE  <= 2'b00;
            MemWriteE   <= 0;
            JumpE       <= 0;
            BranchE     <= 0;
            ALUControlE <= 3'b000;
            ALUSrcE     <= 0;

            RD1E        <= 0;
            RD2E        <= 0;
            PCE         <= 0;
            Rs1E        <= 0;
            Rs2E        <= 0;
            RdE         <= 0;
            ImmExtE     <= 0;
            PCPlus4E    <= 0;
        end else begin
            RegWriteE   <= RegWriteD;
            ResultSrcE  <= ResultSrcD;
            MemWriteE   <= MemWriteD;
            JumpE       <= JumpD;
            BranchE     <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE     <= ALUSrcD;

            RD1E        <= RD1;
            RD2E        <= RD2;
            PCE         <= PCD;
            Rs1E        <= Rs1D;
            Rs2E        <= Rs2D;
            RdE         <= RdD;
            ImmExtE     <= ImmExtD;
            PCPlus4E    <= PCPlus4D;
        end
    end

endmodule