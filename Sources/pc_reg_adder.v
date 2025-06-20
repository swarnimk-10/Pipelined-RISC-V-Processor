`timescale 1ns / 1ps

module pc_reg_adder (
    input clk,
    input reset,
    input EN,                    // Active-low enable (0 = stall PC)
    input [31:0] PCNextF,        // Chosen next PC from mux
    output reg [31:0] PCF,       // Current PC going into instruction memory
    output [31:0] PCPlus4F       // PC + 4 for next instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            PCF <= 32'h00000000;     // Start execution at address 0
        else if (EN)
            PCF <= PCNextF;          // Update PC if not stalled
        // else hold current PCF (stall condition)
    end

    // PCPlus4 logic
    assign PCPlus4F = PCF + 32'd4;

endmodule

// PCF is a register, so if no assignment happens in a clocked always block
//it retains its old value automatically.