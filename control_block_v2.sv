`timescale 1ns / 1ps

module control_block_v2(
btnC,btnU,btnL,btnR,
ALU_A,ALU_B,ALU_Y,
ALU_operation,M_re,
RF_ad1,RF_ad2,RF_wa,RF_we,
M_add,M_we,Mux_select,
PC_enable,IR,isexternal,
IM_record,RF_record,clk,rst,S4,S3,S2,S1);


input logic clk,rst;
input logic [11:0] IR;
input logic btnC,btnU,btnL,btnR;
input logic [3:0] ALU_A,ALU_B,ALU_Y;

output logic PC_enable,RF_we,M_we,M_re,Mux_select,IM_record,RF_record;
output logic [2:0] ALU_operation;
output logic [2:0] RF_ad1,RF_ad2,RF_wa;
output logic [3:0] M_add;
output logic [3:0] S4,S3,S2,S1;

output logic isexternal;

typedef enum {FETCH1,FETCH2,DECODE,
EX_LOAD,EX_STORE,EX_SUB1,EX_SUB2,EX_ADD1,EX_ADD2,
EX_ASC1,EX_ASC2,EX_ASC3,EX_ASC4,
EX_ASC5,EX_ASC6,EX_ASC7,EX_ASC8,EX_ASC9,
EX_DES1,EX_DES2,EX_DES3,EX_DES4,
EX_DES5,EX_DES6,EX_DES7,EX_DES8,EX_DES9,
EX_DISP1,EX_DISP2
} state_type;
state_type state;

// Instructions
localparam LOAD=3'b000;
localparam STORE=3'b001;
localparam SUB=3'b010;
localparam ADD=3'b011;
localparam ASC=3'b100;
localparam DES=3'b101;
localparam DISP=3'b110;

// ALU Operations
parameter OP_AND = 3'b000;
parameter OP_OR = 3'b001;
parameter OP_ADD = 3'b010;
parameter OP_ANDI = 3'b011;
parameter OP_MOV = 3'b100;
parameter OP_SUB = 3'b101;
parameter OP_LT = 3'b110;
parameter OP_GT = 3'b111;

// for ascending and descending operations
logic [2:0] source_start_address;
logic [2:0] source_end_address;
logic [2:0] source_current_address;
logic [2:0] target_start_address;
logic [2:0] target_end_address;
logic [2:0] target_current_address;
logic ov; // check overflow
logic [2:0] count_limit;

integer timer_limit = 100000000; // for 1 second timer
//integer timer_limit = 20; // for testbench
integer counter;


// btnL = execute next instruction in instruction memory
// btnR = execute external instruction
// btnC = load instruction to instruction memory
// btnU = load data value to register file address

always_ff@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state = FETCH1;
        counter = 0;
        PC_enable = 0;
        RF_we = 0;
        M_we = 0;
        M_re = 0;
        Mux_select = 0;
        ALU_operation = 0;
        RF_ad1 = 0;
        RF_ad2 = 0;
        RF_wa = 0;
        M_add = 0;
        source_start_address = 0;
        source_end_address = 0;
        source_current_address = 0;
        target_start_address = 0;
        target_end_address = 0;
        target_current_address = 0;
        count_limit = 0;
        isexternal = 0;
        IM_record = 0;
        RF_record = 0;
        S1 = 0;
        S2 = 0;
        S3 = 0;
        S4 = 0;
    end
    else
    begin
        case(state)
            FETCH1: begin // IDLE state
                counter = 0;
                PC_enable = 0;
                RF_we = 0;
                M_we = 0;
                M_re = 0;
                Mux_select = 0;
                ALU_operation = 0;
                RF_ad1 = 0;
                RF_ad2 = 0;
                RF_wa = 0;
                M_add = 0;
                ov = 0;
                RF_record = 0;
                IM_record = 0;
                isexternal = 0;
                if(btnC) // load external instruction
                    IM_record = 1;
                else if(btnU) // load external data to register
                    RF_record = 1;
                else if(btnR)
                begin
                    isexternal = 1;
                    state = FETCH2; // if the button is pressed, execute the external instruction
                end
                else if(btnL)
                    state = FETCH2; // if the button is pressed, load the instruction
                else
                    state = FETCH1; // no button pressed remain idle
            end
            FETCH2: begin // wait for the instruction
                if(counter == 0) // how many clock cycles
                begin
                    if(isexternal) 
                        PC_enable = 0; 
                    else
                        PC_enable = 1; // increse the PC
                    counter = 1;
                end
                else if (counter < 2)
                begin
                    PC_enable = 0;
                    counter = counter + 1;
                end
                else
                begin
                    state = DECODE;
                    counter = 0;
                end
            end
            DECODE: begin
                case(IR[11:9])
                    LOAD: begin
                        Mux_select = 1;
                        // read from data memory
                        M_re = 1;
                        M_we = 0;
                        M_add = IR[3:0];
                        state = EX_LOAD;
                    end
                    STORE: begin
                        // read from RF
                        RF_we = 0;
                        RF_ad1 = IR[6:4];
                        state = EX_STORE;                    
                    end
                    SUB: begin
                        // read from RF[X] and RF[Y]
                        RF_we = 0; // read from RF
                        RF_ad1 = IR[5:3];
                        RF_ad2 = IR[2:0];
                        ALU_operation = OP_SUB;
                        Mux_select = 0; // chose ALU
                        state = EX_SUB1;                    
                    end
                    ADD: begin
                        // read from RF[X] and RF[Y]
                        RF_we = 0;
                        RF_ad1 = IR[5:3];
                        RF_ad2 = IR[2:0];
                        ALU_operation = OP_ADD;
                        Mux_select = 0;
                        state = EX_ADD1;                    
                    end
                    ASC: begin
                        counter = 0;
                        // calculate addresses
                        count_limit = IR[2:0];
                        source_start_address = IR[5:3];
                        {ov,source_end_address} = IR[5:3] + IR[2:0] - 1;
                        if(ov == 1)
                            source_end_address = 3'b111;
                        source_current_address = IR[5:3];
                        target_start_address = IR[8:6];
                        target_current_address = IR[8:6];
                        {ov,target_end_address} = IR[8:6]+ IR[2:0] - 1;
                        if(ov == 1)
                            target_end_address = 3'b111;
                        // always use ALU output
                        Mux_select = 0;
                        state = EX_ASC1;
                    end
                    DES: begin
                        counter = 0;
                        // calculate addresses
                        count_limit = IR[2:0];
                        source_start_address = IR[5:3];
                        {ov,source_end_address} = IR[5:3] + IR[2:0] - 1;
                        if(ov == 1)
                            source_end_address = 3'b111;
                        source_current_address = IR[5:3];
                        target_start_address = IR[8:6];
                        target_current_address = IR[8:6];
                        if(ov == 1)
                            target_end_address = 3'b111;
                        // always use ALU output
                        Mux_select = 0;
                        state = EX_DES1;
                    end
                    DISP: begin
                        // calculate addresses
                        source_start_address = IR[5:3];
                        {ov,source_end_address} = IR[5:3] + IR[2:0] - 1;
                        if(ov == 1)
                            source_end_address = 3'b111;
                        source_current_address = IR[5:3];
                        // always use ALU output
                        Mux_select = 0;
                        // register is always read mode
                        RF_we = 0;
                        state = EX_DISP1;                    
                    end
                    default: // undefined instruction
                        state = FETCH1; 
                endcase
            end
            EX_LOAD: begin
                // write to RF
                RF_we = 1;
                RF_wa = IR[6:4];
                state = FETCH1;
            end
            EX_STORE: begin
                // write to data memory
                M_we = 1;
                M_re = 0;
                M_add = IR[3:0];
                state = FETCH1;
            end
            EX_SUB1: begin
                // wait alu data

                state = EX_SUB2;
            end
            EX_SUB2: begin
                // save data
                S4 = ALU_A;
                S3 = ALU_B;
                S2 = 4'b1111;
                S1 = ALU_Y;
                // write to RF
                RF_we = 1;
                RF_wa = IR[8:6];
                state = FETCH1;
            end
            EX_ADD1: begin
                // wait alu data
                state = EX_ADD2;
            end
            EX_ADD2: begin
                // save data
                S4 = ALU_A;
                S3 = ALU_B;
                S2 = 4'b1111;
                S1 = ALU_Y;
                // write to RF
                RF_we = 1;
                RF_wa = IR[8:6];
                state = FETCH1;
            end
            EX_ASC1: begin
                // compare first 2 addresses
                RF_we = 0;
                ALU_operation = OP_LT;
                RF_ad1 = source_current_address;
                RF_ad2 = source_current_address+1;
                state = EX_ASC2;
            end
            EX_ASC2: begin
                // write lower one to first address
                RF_we = 1;
                RF_wa = target_current_address;
                state = EX_ASC3;
            end
            EX_ASC3: begin
                // compare first 2 addresses again
                RF_we = 0;
                ALU_operation = OP_GT;
                RF_ad1 = source_current_address;
                RF_ad2 = source_current_address+1;
                state = EX_ASC4;
            end
            EX_ASC4: begin
                // write higher one to second address
                RF_we = 1;
                RF_wa = target_current_address+1;
                state = EX_ASC5;
            end 
            EX_ASC5: begin
                // read lower value
                RF_we = 0;
                ALU_operation = OP_MOV;
                RF_ad1 = target_current_address;
                RF_ad2 = target_current_address+1;
                state = EX_ASC6;
            end
            EX_ASC6: begin
                // write it to source address
                RF_we = 1;
                RF_wa = source_current_address;
                state = EX_ASC7;
            end
            EX_ASC7: begin
                // read higher value
                RF_we = 0;
                ALU_operation = OP_MOV;
                RF_ad1 = target_current_address+1;
                RF_ad2 = target_current_address;
                state = EX_ASC8;
            end
            EX_ASC8: begin
                // write it to source address
                RF_we = 1;
                RF_wa = source_current_address+1;
                state = EX_ASC9;
            end
            EX_ASC9: begin
                RF_we = 0; // close write flag to prevent register error
                if(source_current_address == source_end_address-1)
                begin
                    source_current_address = source_start_address;
                    target_current_address = target_start_address;
                    counter = counter + 1;
                end
                else begin
                    source_current_address = source_current_address + 1;
                    target_current_address = target_current_address + 1;   
                end
                if(counter < count_limit-1)
                    state = EX_ASC1;
                else // operation finished
                begin
                    //state = FETCH1;
                    source_current_address = source_start_address;
                    state = EX_DISP1;
                end
            end
            EX_DES1: begin
                // compare first 2 addresses
                RF_we = 0;
                ALU_operation = OP_GT;
                RF_ad1 = source_current_address;
                RF_ad2 = source_current_address+1;
                state = EX_DES2;
            end
            EX_DES2: begin
                // write higher one to first address
                RF_we = 1;
                RF_wa = target_current_address;
                state = EX_DES3;
            end
            EX_DES3: begin
                // compare first 2 addresses again
                RF_we = 0;
                ALU_operation = OP_LT;
                RF_ad1 = source_current_address;
                RF_ad2 = source_current_address+1;
                state = EX_DES4;
            end
            EX_DES4: begin
                // write lower one to second address
                RF_we = 1;
                RF_wa = target_current_address+1;
                state = EX_DES5;
            end 
            EX_DES5: begin
                // read higher value
                RF_we = 0;
                ALU_operation = OP_MOV;
                RF_ad1 = target_current_address;
                RF_ad2 = target_current_address+1;
                state = EX_DES6;
            end
            EX_DES6: begin
                // write it to source address
                RF_we = 1;
                RF_wa = source_current_address;
                state = EX_DES7;
            end
            EX_DES7: begin
                // read lower value
                RF_we = 0;
                ALU_operation = OP_MOV;
                RF_ad1 = target_current_address+1;
                RF_ad2 = target_current_address;
                state = EX_DES8;
            end
            EX_DES8: begin
                // write it to source address
                RF_we = 1;
                RF_wa = source_current_address+1;
                state = EX_DES9;
            end
            EX_DES9: begin
                RF_we = 0; // close write flag to prevent register error
                if(source_current_address == source_end_address-1)
                begin
                    source_current_address = source_start_address;
                    target_current_address = target_start_address;
                    counter = counter + 1;
                end
                else begin
                    source_current_address = source_current_address + 1;
                    target_current_address = target_current_address + 1;   
                end
                if(counter < count_limit-1)
                    state = EX_DES1;
                else // operation finished
                begin
                    //state = FETCH1;
                    source_current_address = source_start_address;
                    state = EX_DISP1;
                end
            end
            EX_DISP1: begin
                counter = 0;
                ALU_operation = OP_MOV;
                RF_ad1 = source_current_address;
                S4 = RF_ad1;
                S3 = 4'b1111;
                S2 = 4'b1111;
                state = EX_DISP2;
            end           
            EX_DISP2: begin // timer
                S1 = ALU_Y;
                if(counter < timer_limit) // 1 second counter
                begin
                    counter = counter + 1;
                end
                else 
                begin
                    if(source_current_address<source_end_address)
                    begin 
                        source_current_address = source_current_address + 1;
                        state = EX_DISP1;
                    end
                    else
                    begin
                        state = FETCH1;
                    end
                end
            end            
            default: state = FETCH1;
        
        endcase
    end
end

endmodule
