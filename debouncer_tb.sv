`timescale 1ns / 1ps
module debouncer_tb();

logic button,clk,rst;
logic button_out;

debouncer dut(button,button_out,clk,rst);

always 
begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    rst = 1;
    button = 0;
    #10;
    rst = 0;
    #50;
    button = 1; #20;
    button = 0; #10;
    button = 1; #10;
    button = 0; #10;
    
    button = 1; #10000;
    
    button = 0; #10;
    button = 1; #10;
    button = 0; #10;
    button = 1; #10;
    button = 0; #500;
    button = 1; #500;
    button = 0; #500;
    $finish;
end

endmodule
