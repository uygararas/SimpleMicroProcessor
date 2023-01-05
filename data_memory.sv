`timescale 1ns / 1ps

module data_memory(M_rd,M_add,M_we,M_re,M_wd,clk,rst);
input logic M_we,M_re,clk,rst;
input logic [3:0] M_add;
input logic [3:0] M_wd;
output logic [3:0] M_rd;

logic [3:0] memory [15:0];


always_ff@(posedge clk or posedge rst)
begin
    if(rst)
    begin // reset the memory
        memory[0] <= 0;
        memory[1] <= 1;
        memory[2] <= 5;
        memory[3] <= 0;
        memory[4] <= 0;
        memory[5] <= 0;
        memory[6] <= 0;
        memory[7] <= 0;
        memory[8] <= 0;
        memory[9] <= 0;
        memory[10] <= 0;
        memory[11] <= 0;
        memory[12] <= 0;
        memory[13] <= 0;
        memory[14] <= 0;
        memory[15] <= 0;
        
        M_rd <= 0;
    end
    else 
    begin
        if(M_we && M_re) // both write and read signals together
        begin
            memory[M_add] <= M_wd;
            M_rd <= M_wd;
        end
        else if(M_we)
            memory[M_add] <= M_wd;
        else if(M_re)
            M_rd <= memory[M_add];
    end
end


endmodule
