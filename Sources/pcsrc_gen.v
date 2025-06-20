`timescale 1ns / 1ps

module pcsrc_gen (
    input BranchE,
    input JumpE,
    input ZeroE,
    output PCSrcE
);
    assign PCSrcE = (BranchE & ZeroE) | JumpE;
endmodule
