`timescale 1ns / 1ps

module data_memory_tb();

logic M_we,M_re,clk,rst;
logic [3:0] M_add;
logic [3:0] M_wd;
logic [3:0] M_rd;

data_memory dut(M_rd,M_add,M_we,M_re,M_wd,clk,rst);

always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    rst = 1;
    M_re = 0;
    M_we = 0;
    M_add = 0;
    M_wd = 0;
    #10; // write 10 to address 0
    rst = 0;
    M_wd = 10;
    M_add = 0;
    M_re = 0;
    M_we = 1;
    #10; // write -5 to address 3
    M_wd = -5;
    M_add = 3;
    M_re = 0;
    M_we = 1;
    #10; // read address 3
    M_add = 3;
    M_re = 1;
    M_we = 0;    
    #10; // write -7 to address 15 and read same time
    M_wd = -7;
    M_add = 15;
    M_re = 1;
    M_we = 1;
    #10; // write 7 to address 7
    M_wd = 7;
    M_add = 7;
    M_re = 0;
    M_we = 1;
    #10; // read address 0
    M_add = 0;
    M_re = 1;
    M_we = 0;      
    #10;
    $finish;
end


endmodule
