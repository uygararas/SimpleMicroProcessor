`timescale 1ns / 1ps

module seven_segment_tester(an,seg,CLK100MHZ,sw);
input CLK100MHZ;
input [15:0] sw;
output logic [3:0] an;
output logic [6:0] seg;

seven_segment_four seven_segment_four_inst(seg,an,sw[7:4],sw[3:0],4'd5,4'd3,CLK100MHZ,sw[15]);

endmodule
