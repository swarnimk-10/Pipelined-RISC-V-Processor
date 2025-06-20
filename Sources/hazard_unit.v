`timescale 1ns / 1ps

module hazard_unit (
    input [4:0] Rs1D, Rs2D,
    input [4:0] Rs1E, Rs2E,
    input [4:0] RdE,
    input ResultSrcE0,
    input [4:0] RdM,
    input RegWriteM,
    input [4:0] RdW,
    input RegWriteW,
    input PCSrcE,
    output reg StallF, StallD,
    output reg FlushD, FlushE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);
    always @(*) begin
        StallF = 1'b0;
        StallD = 1'b0;
        FlushD = 1'b0;
        FlushE = 1'b0;
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;

        // Load-use hazard detection
        if (ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE))) begin
            StallF = 1'b1;
            StallD = 1'b1;
            FlushE = 1'b1; // ❗️ This flushes the instruction after the load. That's good.
        end

        // Branch/jump flushing
        FlushE = (PCSrcE | (ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE))));
        FlushD = PCSrcE;


        // Forwarding logic
        if ((Rs1E != 0) & (Rs1E == RdM) & RegWriteM)
            ForwardAE = 2'b10;
        else if ((Rs1E != 0) & (Rs1E == RdW) & RegWriteW)
            ForwardAE = 2'b01;

        if ((Rs2E != 0) & (Rs2E == RdM) & RegWriteM)
            ForwardBE = 2'b10;
        else if ((Rs2E != 0) & (Rs2E == RdW) & RegWriteW)
            ForwardBE = 2'b01;
    end
endmodule
