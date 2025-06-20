`timescale 1ns / 1ps

module pc_next_mux (
    input  [31:0] PCPlus4F,     // Normal next PC (PC + 4 from Fetch stage)
    input  [31:0] PCTargetE,    // Target PC for branch/jump from Execute stage
    input         PCSrc,        // Control signal: 1 = take branch/jump
    output wire [31:0] PCNextF  // Output: next PC to be used
);

    assign PCNextF = (PCSrc) ? PCTargetE : PCPlus4F;

endmodule
