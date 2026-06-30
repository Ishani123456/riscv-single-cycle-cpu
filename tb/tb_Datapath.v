`timescale 1ns/1ps
module tb_Datapath;
    reg clk;
    reg reset;

    Datapath dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Datapath);
    end

    initial begin
        clk   = 0;
        reset = 1;
        #20 reset = 0;
        #200;
        $display("Simulation finished.");
        $finish;
    end

endmodule
