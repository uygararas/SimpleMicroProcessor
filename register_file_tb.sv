`timescale 1ns / 1ps

module register_file_tb();

logic RF_we,clk,rst;
logic [2:0] RF_ad1,RF_ad2,RF_wa;
logic [3:0] RF_wd;
logic [3:0] RF_d1,RF_d2;

register_file dut(RF_d1,RF_d2,RF_ad1,RF_ad2,RF_wa,RF_we,RF_wd,clk,rst);

always begin 
    clk = 0; #5;
    clk = 1; #5;
end

integer i;

initial begin
    rst = 1;
    RF_ad1 = 0;
    RF_ad2 = 0;
    RF_wa = 0;
    RF_wd = 0;
    RF_we = 0;
    #10;
    rst = 0;
    RF_we = 1;
    for(i=0;i<8;i=i+1) // fill the register file with 0,1,..7
    begin
        RF_wd = i;
        RF_wa = i;
        #10;
    end
    RF_we = 0;
    for(i=0;i<7;i=i+1) // read the registers
    begin
        RF_ad1 = i;
        RF_ad2 = i + 1;
        #10;
    end
    RF_we = 1;
    for(i=0;i<8;i=i+1) // fill the register file with 0,-1,..-7
    begin
        RF_wd = -i;
        RF_wa = i;
        #10;
    end
    RF_we = 0;
    for(i=0;i<7;i=i+1) // read the registers
    begin
        RF_ad1 = i;
        RF_ad2 = i + 1;
        #10;
    end
    $finish;
end

endmodule
