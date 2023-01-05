`timescale 1ns / 1ps

module program_counter_tb();


logic clk,rst,enable;
logic [2:0] address_out;

program_counter dut(address_out,clk,rst,enable);

always begin
    clk = 0; #5;
    clk = 1; #5;
end


initial begin
    rst = 1;
    enable = 1;
    #10;
    rst = 0;
    #30;
    enable = 0;
    #30;
    enable = 1;
    #30;
    $finish;
end

endmodule
