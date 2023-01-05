`timescale 1ns / 1ps

module register_file_v2(RF_d1,RF_d2,RF_ad1,RF_ad2,RF_wa,RF_we,RF_wd,clk,rst,sw,record);
input logic RF_we,clk,rst,record;
input logic [2:0] RF_ad1,RF_ad2,RF_wa;
input logic [3:0] RF_wd;
input logic [6:0] sw;
output logic [3:0] RF_d1,RF_d2;

logic [3:0] registers [7:0];

always_ff@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        registers[0] <= 6;
        registers[1] <= 3;
        registers[2] <= 2;
        registers[3] <= 3;
        registers[4] <= 4;
        registers[5] <= 5;
        registers[6] <= 6;
        registers[7] <= 7;
        
        RF_d1 <= 0;
        RF_d2 <= 0;
    end
    else begin
        if(record==0)
        begin
            if(RF_we==1) // write RF_wd to RF_wa
            begin
                registers[RF_wa] <= RF_wd;
            end
            else // read from RF_ad1 and RF_ad2, to RF_d1 and RF_d2
            begin
                RF_d1 <= registers[RF_ad1];
                RF_d2 <= registers[RF_ad2];
            end
        end
        else
        begin
            registers[sw[2:0]] = sw[6:3];
        end
    end

end


endmodule
