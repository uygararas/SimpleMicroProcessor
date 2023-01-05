`timescale 1ns / 1ps

module instruction_memory_tb();

logic clk,rst,isexternal;
logic [2:0] address;
logic [11:0] switches;
logic [11:0] data_out;

instruction_memory dut(data_out,clk,rst,address,isexternal,switches);

always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
rst = 1;
address = 0;
isexternal = 0;
switches = 5;
#10;
rst = 0;
address = 0; #10;
address = 1; #10;
address = 2; #10;
address = 3; #10;
address = 4; #10;
address = 5; #10;
address = 6; #10;
address = 7; #10;
isexternal = 1; #10;
$finish;
end

endmodule
