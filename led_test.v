`timescale 1ns / 1ps

module led_test(sw,LED);
input [15:0] sw;
output [15:0] LED;

assign LED = sw;

endmodule
