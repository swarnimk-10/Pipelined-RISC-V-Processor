module register_file (
    input clk,
    input rst,
    input RegWrite,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] registers [0:31];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (RegWrite && A3 != 5'd0) begin
            registers[A3] <= WD3;
        end
    end
    assign RD1 = (A1 != 5'd0) ? registers[A1] : 32'b0;
    assign RD2 = (A2 != 5'd0) ? registers[A2] : 32'b0;
endmodule