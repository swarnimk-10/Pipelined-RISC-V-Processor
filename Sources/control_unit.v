`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] op,         // instruction[6:0]
    input  wire [2:0] funct3,     // instruction[14:12]
    input  wire       funct7,     // instruction[30]

    output reg  [1:0] ResultSrc,  // 00: ALUResult, 01: ReadData, 10: PC+4, 11: ImmExt (for LUI)
    output reg        MemWrite,
    output reg  [2:0] ALUControl,
    output reg        ALUSrc,
    output reg  [2:0] ImmSrc,   
    output reg        RegWrite,
    output reg        BranchD,
    output reg        JumpD
);

    reg [1:0] ALUOp;


    always @(*) begin
        RegWrite   = 1'b0;
        ImmSrc     = 3'b000;
        ALUSrc     = 1'b0;
        MemWrite   = 1'b0;
        ResultSrc  = 2'b00;
        ALUOp      = 2'b00;
        BranchD     = 1'b0;
        JumpD      = 1'b0;

        case (op)
            7'b0000011: begin // lw
                RegWrite   = 1'b1;
                ImmSrc     = 3'b000;   // I-type
                ALUSrc     = 1'b1;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b01;    
                ALUOp      = 2'b00;
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end

            7'b0100011: begin // sw
                RegWrite   = 1'b0;
                ImmSrc     = 3'b001;   // S-type
                ALUSrc     = 1'b1;
                MemWrite   = 1'b1;
                ResultSrc  = 2'b00;    
                ALUOp      = 2'b00;
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end

            7'b0110011: begin // R-type
                RegWrite   = 1'b1;
                ImmSrc     = 3'b000;  
                ALUSrc     = 1'b0;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;  
                ALUOp      = 2'b10;   
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end

            7'b1100011: begin // beq
                RegWrite   = 1'b0;
                ImmSrc     = 3'b010;   // B-type
                ALUSrc     = 1'b0;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;    
                ALUOp      = 2'b01;    
                BranchD     = 1'b1;
                JumpD       = 1'b0;
            end

            7'b0010011: begin // addi
                RegWrite   = 1'b1;
                ImmSrc     = 3'b000;   // I-type
                ALUSrc     = 1'b1;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;   
                ALUOp      = 2'b10;    
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end

            7'b1101111: begin // jal
                RegWrite   = 1'b1;
                ImmSrc     = 3'b011;   // J-type
                ALUSrc     = 1'b1;    
                MemWrite   = 1'b0;
                ResultSrc  = 2'b10;   
                ALUOp      = 2'b00;    
                BranchD     = 1'b0;
                JumpD       = 1'b1;
            end

            7'b0110111: begin // LUI
                RegWrite   = 1'b1;
                ImmSrc     = 3'b100;   // U-type
                ALUSrc     = 1'b0;    
                MemWrite   = 1'b0;
                ResultSrc  = 2'b11;   
                ALUOp      = 2'b00; 
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end

            default: begin 
                RegWrite   = 1'b0;
                ImmSrc     = 3'b000;
                ALUSrc     = 1'b0;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;
                ALUOp      = 2'b00;
                BranchD     = 1'b0;
                JumpD       = 1'b0;
            end
        endcase
    end

    // -------- ALU Decoder ----------
    always @(*) begin
        case (ALUOp)
            2'b00:  ALUControl = 3'b000; // add (used for lw, sw, etc.)
            2'b01:  ALUControl = 3'b001; // sub (used for beq)
            2'b10: begin // use funct3 + funct7
                case (funct3)
                    3'b000: ALUControl = (funct7 == 1'b1) ? 3'b001 : 3'b000; // sub or add
                    3'b111: ALUControl = 3'b010; // and
                    3'b110: ALUControl = 3'b011; // or
                    3'b010: ALUControl = 3'b101; // slt
                    default: ALUControl = 3'b000; // default to add
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule
