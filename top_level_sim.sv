`timescale 1ns / 1ps

module top_level_sim();

logic clk,rst;

// Fetch Signals
logic isexternal;
logic [11:0] IR;
logic [11:0] switches;
logic PC_enable;
logic [2:0] PC_address_out;
logic [11:0] IM_data_out;

// Execute signals
logic M_we,M_re;
logic [3:0] M_add;
logic [3:0] M_wd;
logic [3:0] M_rd;

logic Mux_select;
logic [3:0] Mux_out;

//logic [3:0] A,B;
logic [2:0] ALU_operation;
logic [3:0] ALU_out;

logic RF_we;
logic [2:0] RF_ad1,RF_ad2,RF_wa;
logic [3:0] RF_d1,RF_d2;

// Fetch Parts
program_counter program_counter_inst(PC_address_out,clk,rst,PC_enable);
instruction_memory instruction_memory_inst(IM_data_out,clk,rst,PC_address_out,isexternal,switches);
instruction_register instruction_register_inst(IR,IM_data_out,clk,rst);

// Execute Parts
data_memory data_memory_inst(M_rd,M_add,M_we,M_re,RF_d1,clk,rst);
mux_2_to_1 mux_2_to_1_inst(Mux_out,ALU_out,M_rd,Mux_select);
ALU ALU_inst(ALU_out,RF_d1,RF_d2,ALU_operation);
register_file register_file_inst(RF_d1,RF_d2,RF_ad1,RF_ad2,RF_wa,RF_we,Mux_out,clk,rst);


control_block control_block_inst(ALU_operation,M_re,RF_ad1,RF_ad2,RF_wa,RF_we,M_add,M_we,Mux_select,PC_enable,IR,isexternal,clk,rst);


always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    rst = 1;
    isexternal = 0;
    #10;
    rst = 0;
    #5000;
    $finish;
end


endmodule
