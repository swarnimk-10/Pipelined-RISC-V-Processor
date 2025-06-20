`timescale 1ns / 1ps

module sign_extend (
    input  [24:0] instr_31_7,  
    input  [2:0]  ImmSrc,      
    output reg [31:0] ImmExt  
);

    wire [31:0] I_imm = {{20{instr_31_7[24]}}, instr_31_7[24:13]}; 
    wire [31:0] S_imm = {{20{instr_31_7[24]}}, instr_31_7[24:18], instr_31_7[4:0]}; 
    wire [31:0] B_imm = {{19{instr_31_7[24]}}, instr_31_7[0], instr_31_7[23:18], instr_31_7[4:1], 1'b0};
    wire [31:0] J_imm = {{11{instr_31_7[24]}}, instr_31_7[12:5], instr_31_7[13], instr_31_7[23:14], 1'b0}; 
    wire [31:0] U_imm = {instr_31_7[24:5], 12'b0}; 

    always @(*) begin
        case (ImmSrc)
            3'b000: ImmExt = I_imm;
            3'b001: ImmExt = S_imm;
            3'b010: ImmExt = B_imm;
            3'b011: ImmExt = J_imm;
            3'b100: ImmExt = U_imm;
            default: ImmExt = 32'b0;
        endcase
    end

endmodule
