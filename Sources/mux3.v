`timescale 1ns / 1ps

module mux3 (
    input  [31:0] d0,    // Input 0
    input  [31:0] d1,    // Input 1
    input  [31:0] d2,    // Input 2
    input  [1:0]  sel,   
    output reg [31:0] y 
);

    always @(*) begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            default: y = d0; 
        endcase
    end

endmodule
