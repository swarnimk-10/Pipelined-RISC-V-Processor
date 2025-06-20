`timescale 1ns / 1ps

module alu (
    input  [31:0] SrcAE,         
    input  [31:0] SrcBE,         
    input  [2:0]  ALUControlE,   
    output reg [31:0] ALUResultE,
    output       ZeroE          
);

    assign ZeroE = (ALUResultE == 32'b0);

    always @(*) begin
        case (ALUControlE)
            3'b000: ALUResultE = SrcAE + SrcBE;                       
            3'b001: ALUResultE = SrcAE - SrcBE;                       
            3'b010: ALUResultE = SrcAE & SrcBE;                       
            3'b011: ALUResultE = SrcAE | SrcBE;                      
            3'b101: ALUResultE = (SrcAE < SrcBE) ? 32'b1 : 32'b0;      
            default: ALUResultE = 32'b0;
        endcase
    end

endmodule
