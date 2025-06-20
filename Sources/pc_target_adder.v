`timescale 1ns / 1ps

module pc_target_adder (
    input [31:0] PCE,          
    input [31:0] ImmExtE,       
    output wire [31:0] PCTargetE  
);

assign PCTargetE = PCE + ImmExtE;

endmodule
