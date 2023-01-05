`timescale 1ns / 1ps

module program_counter(address_out,clk,rst,enable);
input logic clk,rst,enable;
output logic [2:0] address_out;


// enable will be connected to (~isexternal)

always_ff@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        address_out <= -1;
    end
    else begin
        if(enable==1)
            address_out <= address_out + 1;
    end
end

endmodule
