`timescale 1ns / 1ps

module instruction_register_tb();

logic clk,rst;
logic [11:0] data_in;
logic [11:0] data_out;

instruction_register dut(data_out,data_in,clk,rst);

always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
rst = 1;
data_in = 12'd10;
#10;
rst = 0;
#10;
data_in = 12'd4;
#10;
data_in = 12'd56;
#10;
$finish;
end


endmodule
