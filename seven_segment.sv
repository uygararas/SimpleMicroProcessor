`timescale 1ns / 1ps

module seven_segment(number,segment_out);
input logic [3:0] number;
output logic [6:0] segment_out;

reg[6:0] LED_out;
always_comb
begin
 case(number)
 4'b0000: segment_out = 7'b1000000; // "0"  
 4'b0001: segment_out = 7'b1111001; // "1" 
 4'b0010: segment_out = 7'b0100100; // "2" 
 4'b0011: segment_out = 7'b0110000; // "3" 
 4'b0100: segment_out = 7'b0011001; // "4" 
 4'b0101: segment_out = 7'b0010010; // "5" 
 4'b0110: segment_out = 7'b0000010; // "6" 
 4'b0111: segment_out = 7'b1111000; // "7" 
 4'b1000: segment_out = 7'b0000000; // "8"  
 4'b1001: segment_out = 7'b0010000; // "9"
 4'b1010: segment_out = 7'b0001000; // "A"
 4'b1011: segment_out = 7'b0000011; // "b"
 4'b1100: segment_out = 7'b1000110; // "C"
 4'b1101: segment_out = 7'b0100001; // "d"
 4'b1110: segment_out = 7'b0000110; // "e"
 4'b1111: segment_out = 7'b1111111; // "" 
 default: segment_out = 7'b1000000; // "0"
 endcase
end

endmodule
