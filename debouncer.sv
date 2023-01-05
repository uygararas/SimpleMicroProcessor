`timescale 1ns / 1ps

module debouncer(button,button_out,clk,rst);
input logic button,clk,rst;
output logic button_out;

typedef enum {FIRST,SECOND} state_type;
state_type state;

logic ff1_out, ff2_out, xor_out, counter_out,result;
integer counter;

localparam counter_limit = 200000; // 2ms
//localparam counter_limit = 20; // for testbench

assign xor_out = ff1_out^ff2_out;

always_ff@(posedge clk or posedge rst) // debouncer circuit
begin
    if(rst)
    begin
        ff1_out <= 0;
        ff2_out <= 0;
        counter <= 0;
        counter_out <= 0;
        result <= 0;
    end
    else begin
        // registers
        ff1_out <= button;
        ff2_out <= ff1_out;
        if(counter_out == 1)
            result <= ff2_out;
            
        // counter
        if(xor_out) // clear
        begin
            counter <= 0;
            counter_out <= 0;
        end
        else
        begin
            if(counter_out==0) // enable
                if(counter < counter_limit)
                        counter <= counter + 1;
                else
                        counter_out <= 1;
        end
    end
end

always_ff@(posedge clk or posedge rst) // state machine
begin
    if(rst)
    begin
        state <= FIRST;
        button_out <= 0;
    end
    else
    begin
        case(state)
        FIRST: begin
            if(result==1)
            begin
                state <= SECOND;
                button_out <= 1;
            end
            else
            begin
                state <= FIRST;
                button_out <= 0;
            end
        end
        SECOND: begin
            button_out <= 0;
            if(result==0)
                state <= FIRST;
            else
                state <= SECOND;
            end
        endcase
    end

end




endmodule
