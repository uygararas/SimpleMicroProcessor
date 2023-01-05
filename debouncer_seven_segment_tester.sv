`timescale 1ns / 1ps

module debouncer_seven_segment_tester(an,seg,CLK100MHZ,btnC,btnL,btnR,sw);
input CLK100MHZ,btnC,btnL,btnR;
input [15:0] sw;
output logic [3:0] an;
output logic [6:0] seg;

logic [3:0] counter;

logic btnC_debounced,btnL_debounced,btnR_debounced;

seven_segment_four seven_segment_four_inst(seg,an,counter+3,counter+2,counter+1,counter,CLK100MHZ,sw[0]);

debouncer deb1(btnC,btnC_debounced,CLK100MHZ,sw[0]);
debouncer deb2(btnR,btnR_debounced,CLK100MHZ,sw[0]);
debouncer deb3(btnL,btnL_debounced,CLK100MHZ,sw[0]);

always@(posedge CLK100MHZ)
begin
    if(btnC_debounced)
        counter <= 0;
    else if(btnR_debounced)
        counter <= counter + 1;
    else if(btnL_debounced)
        counter <= counter - 1;
end


endmodule
