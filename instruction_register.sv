`timescale 1ns / 1ps

module instruction_register(data_out,data_in,clk,rst);
input logic clk,rst;
input logic [11:0] data_in;
output logic [11:0] data_out;

always_ff@(posedge clk or posedge rst)
begin
    if(rst)
        data_out <= 0;
    else
        data_out <= data_in;
end

endmodule
