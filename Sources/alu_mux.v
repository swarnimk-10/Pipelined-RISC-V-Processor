`timescale 1ns / 1ps

module alu_mux (
    input  [31:0] SrcB_forwarded, 
    input  [31:0] ImmExtE,         
    input         ALUSrcE,         
    output [31:0] SrcBE   
);

    assign SrcBE = ALUSrcE ? ImmExtE : SrcB_forwarded;

endmodule
