`timescale 1ns / 1ps

module instruction_memory_v2(data_out,clk,rst,address,isexternal,switches,record);
input logic clk,rst,isexternal,record;
input logic [2:0] address;
input logic [11:0] switches;
output logic [11:0] data_out;

logic [11:0] memory [7:0]; // instruction memory

always_ff @(posedge clk or posedge rst)
begin
    if(rst==1) // 
    begin // initial values of memory
        memory[0] <= 12'b010_010_000_001; // RF[2] = RF[0] - RF[1]
        memory[1] <= 12'b011_011_000_001; // RF[3] = RF[0] + RF[1]
        memory[2] <= 12'b110_000_000_111; // Display
        memory[3] <= 12'b100_100_000_100; // Ascending sort
        memory[4] <= 12'b110_000_000_111; // Display
        memory[5] <= 12'b101_100_000_100; // Descending sort
        memory[6] <= 12'b110_000_000_111; // Display
        memory[7] <= 12'b111_111_111_111; // dummy
    /*
        memory[0] <= 12'b000_00_001_0010; // LOAD D[2] to RF[1]
        memory[1] <= 12'b001_00_001_0100; // STORE RF[1] to D[4]
        memory[2] <= 12'b010_011_000_001; // RF[3] = RF[0] - RF[1].
        memory[3] <= 12'b011_010_000_001; // RF[2] = RF[0] + RF[1].
        memory[4] <= 12'b100_100_000_100; // Ascending sort
        memory[5] <= 12'b101_100_000_100; // Descending sort
        memory[6] <= 12'b110_000_000_111; // Display
        memory[7] <= 12'b111_111_111_111; // dummy
     */
        data_out <= 0; // to prevent X
    end
    else
    begin
        if(record==0)
        begin
            if(isexternal==1)
                data_out <= switches;
            else
                data_out <= memory[address];
        end
        else
            memory[address] = switches;
    end
end

endmodule
