`timescale 1ns / 1ps

module tb_riscv_pipeline();
    reg clk;
    reg rst;
    
    risc_pipeline_top dut(.clk(clk), .rst(rst));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;  
        
        #1000;
        
        $display("\nFinal Register State:");
        $display("x1 = %d (expected 5)", dut.rf.registers[1]);
        $display("x2 = %d (expected 10)", dut.rf.registers[2]);
        $display("x3 = %d (expected 15)", dut.rf.registers[3]);
        $display("x5 = %d", dut.rf.registers[5]);
        $display("x6 = %d", dut.rf.registers[6]);
        $display("x7 = %d (expected 42)", dut.rf.registers[7]);
        $display("x8 = %d", dut.rf.registers[8]);
        $display("x9 = %d (expected 1)", dut.rf.registers[9]);
        
        $finish;
    end
    
    initial begin
        $dumpfile("riscv_pipeline.vcd");
        $dumpvars(0, dut);
    end
    
    always @(posedge clk) begin
        if (!rst) begin
            $monitor("PCSrcE=%b BranchE=%b JumpE=%b ZeroE=%b", dut.PCSrcE, dut.BranchE, dut.JumpE, dut.ZeroE);
            $display("\n--- CYCLE %0d ---", $time/10);
            $display("IF: PC=%h Instr=%h", dut.PCF, dut.InstrF);
            $display("ID: Instr=%h rs1=%d rs2=%d rd=%d", 
                    dut.InstrD, dut.Rs1D, dut.Rs2D, dut.RdD);
            $display("EX: ALUResult=%h", dut.ALUResultE);
            $display("MEM: Addr=%h Data=%h", dut.ALUResultM, dut.WriteDataM);
            $display("WB: RegWrite=%b rd=%d Result=%h", 
                    dut.RegWriteW, dut.RdW, dut.ResultW);
        end
    end
    initial begin
        $dumpfile("riscv_pipeline.vcd");
        $dumpvars(0, tb_riscv_pipeline); 
    end

    always @(posedge clk) begin
        if (dut.InstrF == 32'b0) begin
            $display("HALT: Reached NOP");
            $finish;
        end
    end
endmodule
