`timescale 1ns / 1ps
module simple_microprocessor(btnC,btnU,btnL,btnR,btnD,CLK100MHZ,sw,seg,an);
// inputs
input logic btnC,btnU,btnL,btnR,btnD;
input logic CLK100MHZ;
input logic [15:0] sw;
// outputs
output logic [6:0] seg;
output logic [3:0] an;

// debouncing buttons
logic btnC_dbd,btnL_dbd,btnR_dbd,btnU_dbd,btnD_dbd;
debouncer dbd1(btnC,btnC_dbd,CLK100MHZ,0);
debouncer dbd2(btnR,btnR_dbd,CLK100MHZ,0);
debouncer dbd3(btnL,btnL_dbd,CLK100MHZ,0);
debouncer dbd4(btnU,btnU_dbd,CLK100MHZ,0);
debouncer dbd5(btnD,btnD_dbd,CLK100MHZ,0);

// control block signals
logic [2:0] ALU_operation;
logic PC_enable,RF_we,M_we,M_re,Mux_select,IM_record,RF_record;
logic [2:0] RF_ad1,RF_ad2,RF_wa;
logic [3:0] M_add;
logic isexternal;
logic rst;
assign rst = btnD_dbd;

// seven segment with controller
logic [3:0] S4,S3,S2,S1;
seven_segment_four seven_segment_four_inst(seg,an,S4,S3,S2,S1,CLK100MHZ,rst);

// program counter signals
logic [2:0] PC_address_out;

// instruction memory signals
logic [11:0] IM_data_out;

// instruction register signals
logic [11:0] IR_data_out;

// data memory signals
logic [3:0] M_rd;

// mux2to1 signals
logic [3:0] Mux_out;

// ALU Signals
logic [3:0] ALU_out;

// Register File Signals
logic [3:0] RF_d1,RF_d2;

// control block
control_block_v2 control_block_inst(
.btnC(btnC_dbd),
.btnU(btnU_dbd),
.btnL(btnL_dbd),
.btnR(btnR_dbd),
.ALU_operation(ALU_operation),
.M_re(M_re),
.RF_ad1(RF_ad1),
.RF_ad2(RF_ad2),
.RF_wa(RF_wa),
.RF_we(RF_we),
.M_add(M_add),
.M_we(M_we),
.Mux_select(Mux_select),
.PC_enable(PC_enable),
.IR(IR_data_out),
.isexternal(isexternal),
.IM_record(IM_record),
.RF_record(RF_record),
.clk(CLK100MHZ),
.rst(rst),
.ALU_A(RF_d1),
.ALU_B(RF_d2),
.ALU_Y(ALU_out),
.S4(S4),
.S3(S3),
.S2(S2),
.S1(S1)
);

program_counter program_counter_inst(
.address_out(PC_address_out),
.clk(CLK100MHZ),
.rst(rst),
.enable(PC_enable));

// Instruction Memory
instruction_memory_v2 instruction_memory_inst(
.data_out(IM_data_out),
.clk(CLK100MHZ),
.rst(rst),
.address(PC_address_out),
.isexternal(isexternal),
.switches(sw[11:0]),
.record(IM_record));

// Instruction Register
instruction_register instruction_register_inst(
.data_out(IR_data_out),
.data_in(IM_data_out),
.clk(CLK100MHZ),
.rst(rst));

// data memory
data_memory data_memory_inst(
.M_rd(M_rd),
.M_add(M_add),
.M_we(M_we),
.M_re(M_re),
.M_wd(RF_d1),
.clk(CLK100MHZ),
.rst(rst));

// mux2to1
mux_2_to_1 mux_2_to_1(
.y(Mux_out),
.d0(ALU_out),
.d1(M_rd),
.s(Mux_select));


ALU ALU_inst(
.Y(ALU_out),
.A(RF_d1),
.B(RF_d2),
.F(ALU_operation));


register_file_v2 register_file_inst(
.RF_d1(RF_d1),
.RF_d2(RF_d2),
.RF_ad1(RF_ad1),
.RF_ad2(RF_ad2),
.RF_wa(RF_wa),
.RF_we(RF_we),
.RF_wd(Mux_out),
.clk(CLK100MHZ),
.rst(rst),
.sw(sw[15:9]),
.record(RF_record));

//uygar aras

endmodule
//////////////////////////
//22103277 Uygar Aras sec2 project cs223
////////////////////////////

module Half_Adder (input a, b, output sum, carry); 
 
   assign sum = a ^ b;
   assign carry = a & b;
 
endmodule

//////////////////////////
//22103277 Uygar Aras sec2 project cs223
////////////////////////////


module two_to_four_mux (
	input [1:0] select,
	input [3:0] in,
	output out
	);
	
	assign out = select[0] ? in[1] : (select[1] ? in[2] : (select[2] ? in[3] : in[0]));
	
endmodule

//////////////////////////
//22103277 Uygar Aras sec2 project cs223
////////////////////////////