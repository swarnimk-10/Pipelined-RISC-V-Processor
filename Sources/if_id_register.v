module if_id_register (
    input clk,
    input rst,
    input en,
    input clr,
    input [31:0] instr_in,
    input [31:0] PCF_in,
    input [31:0] PCPlus4F_in,
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;
        end
        else if (clr) begin
            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;
        end
        else if (en) begin
            InstrD <= instr_in;
            PCD <= PCF_in;
            PCPlus4D <= PCPlus4F_in;
        end

    end
endmodule