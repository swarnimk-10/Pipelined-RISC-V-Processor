`timescale 1ns / 1ps

module risc_pipeline_top(
    input clk,
    input rst
);

    // Program Counter Wires
    wire [31:0] PCF, PCNextF, PCPlus4F;

    // IF/ID
    wire [31:0] InstrF, InstrD, PCPlus4D, PCD;
    wire StallF, StallD, FlushD;


    // Control Signals from Decode
    wire RegWriteD, MemWriteD, ALUSrcD, JumpD, BranchD;
    wire [1:0] ResultSrcD;
    wire [2:0] ImmSrcD, ALUControlD;

    wire [31:0] ImmExtD, RD1D, RD2D;

    // ID/EX
    wire [31:0] RD1E, RD2E, ImmExtE, PCE, PCPlus4E;
    wire [4:0] Rs1E, Rs2E, RdE;
    wire RegWriteE, MemWriteE, ALUSrcE, JumpE, BranchE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;

    // Execute stage
    wire [31:0] PCTargetE, SrcAE, SrcBE, ALUResultE, WriteDataE;
    wire ZeroE, PCSrcE;

    // EX/MEM
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;
    wire [31:0] ALUResultM, WriteDataM, PCPlus4M;
    wire [4:0] RdM;

    // MEM stage
    wire [31:0] ReadDataM;

    // MEM/WB
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire [4:0] RdW;

    wire [31:0] ResultW;

    // Hazard Unit
    wire [1:0] ForwardAE, ForwardBE;
    wire FlushE;

    // Instruction Fetch
    pc_next_mux pc_mux (PCPlus4F, PCTargetE, PCSrcE, PCNextF);
    pc_reg_adder pc_reg (clk, rst, ~StallF, PCNextF, PCF, PCPlus4F);
    instruction_memory im (PCF, InstrF);

    // IF/ID Register
    if_id_register ifid (clk, rst, ~StallD, FlushD, InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
    
    // Control Unit
    control_unit ctrl (InstrD[6:0], InstrD[14:12], InstrD[30], ResultSrcD, MemWriteD, ALUControlD, 
                        ALUSrcD, ImmSrcD, RegWriteD, BranchD, JumpD);

    // Register File
    register_file rf (clk, rst, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, RD1D, RD2D);

    // Sign Extend
    sign_extend se (InstrD[31:7], ImmSrcD, ImmExtD);

    wire [4:0] Rs1D = InstrD[19:15];
    wire [4:0] Rs2D = InstrD[24:20];
    wire [4:0] RdD  = InstrD[11:7];
    
    // ID/EX Register
    id_ex_register idex (clk, FlushE, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, 
        ALUSrcD, RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, 
        ImmExtD, PCPlus4D, RegWriteE, ResultSrcE, MemWriteE,
        JumpE, BranchE, ALUControlE, ALUSrcE, RD1E, RD2E, PCE,
        Rs1E, Rs2E, RdE, ImmExtE,PCPlus4E);

    // Forwarding muxes
    mux3 fwdA (RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
    mux3 fwdB (RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);

    // ALU Operand mux
    alu_mux amux (WriteDataE,ImmExtE, ALUSrcE, SrcBE);

    // ALU
    alu alu_core (SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);

    // PC Target Adder
    pc_target_adder pctarget (PCE, ImmExtE, PCTargetE);

    // PCSrc Logic
    pcsrc_gen pgen (BranchE, JumpE, ZeroE, PCSrcE);

    // EX/MEM Register
    ex_mem_register exmem (clk, RegWriteE, ResultSrcE, MemWriteE,
        ALUResultE, WriteDataE, RdE, PCPlus4E, RegWriteM, ResultSrcM, MemWriteM,
        ALUResultM, WriteDataM, RdM, PCPlus4M);

    // Data Memory
    data_memory dmem (clk, rst, ALUResultM, WriteDataM,
        MemWriteM, ReadDataM);

    // MEM/WB Register
    mem_wb_register memwb (clk, ResultSrcM, RegWriteM, ALUResultM,
        ReadDataM, RdM, PCPlus4M,ResultSrcW,
        RegWriteW, ALUResultW,
        ReadDataW, RdW, PCPlus4W);

    // WB Result Mux
    mux3 result_mux (ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);

    // Hazard Unit
    hazard_unit hazard (Rs1D, Rs2D, Rs1E, Rs2E, RdE, ResultSrcE[0],
        RdM, RegWriteM, RdW, RegWriteW, PCSrcE,
        StallF, StallD, FlushD, FlushE,
        ForwardAE, ForwardBE);

endmodule
