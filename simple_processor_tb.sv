`timescale 1ns / 1ps

module simple_processor_tb();

// inputs
logic btnC,btnU,btnL,btnR,btnD;
logic CLK100MHZ;
logic [15:0] sw;
// outputs
logic [6:0] seg;
logic [3:0] an;


simple_microprocessor dut(btnC,btnU,btnL,btnR,btnD,CLK100MHZ,sw,seg,an);

always begin
    CLK100MHZ = 0; #5;
    CLK100MHZ = 1; #5;
end

initial begin
    btnC = 0;
    btnD = 0;
    btnU = 0;
    btnL = 0;
    btnR = 0;
    sw = 0;
    #1000;
    btnD = 1; #1000; btnD = 0; #1000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    btnL = 1; #1000; btnL = 0; #10000;
    sw[15:9] = 7'b0110_000; // RF[0] = 6
    btnU = 1; #1000; btnU = 0; #10000;
    sw[15:9] = 7'b0011_001; // RF[1] = 3
    btnU = 1; #1000; btnU = 0; #10000;
    sw[11:0] = 12'b010_010_000_001; // RF[2] = RF[0] - RF[1]
    btnR = 1; #1000; btnR = 0; #10000;
    sw[11:0] = 12'b011_010_000_001; // RF[2] = RF[0] + RF[1]
    btnR = 1; #1000; btnR = 0; #10000;
    $finish;
end

endmodule
