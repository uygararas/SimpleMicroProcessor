`timescale 1ns / 1ps
module seven_segment_four(segment_out,segment_enable,d4,d3,d2,d1,clk,rst);
input logic clk,rst;
input logic [3:0] d4,d3,d2,d1;

output logic [6:0] segment_out;
output logic [3:0] segment_enable;

logic [3:0] segment_number;

integer counter;
localparam counter_limit = 200000; // 2ms

typedef enum {D1,D2,D3,D4} state_type;
state_type state;

seven_segment seven_segment_inst(segment_number,segment_out);


always_ff@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        counter <= 0;
        state <= D1;
    end
    else begin
        if(counter<counter_limit)
        begin
            counter <= counter + 1;
        end
        else begin // reset counter 
            counter <= 0;
            case(state)
            D1: begin
                state <= D2;
            end
            D2: begin
                state <= D3;
            end
            D3: begin
                state <= D4;
            end
            D4: begin
                state <= D1;
            end
            default: begin
                state <= D1;
            end                  
            endcase
        end
    end
end

always_comb
begin
    case(state)
        D1: begin
            segment_number = d1;
            segment_enable = 4'b1110;                    
        end
        D2: begin
            segment_number = d2;
            segment_enable = 4'b1101;                    
        end
        D3: begin
            segment_number = d3;
            segment_enable = 4'b1011;                    
        end
        D4: begin
            segment_number = d4;
            segment_enable = 4'b0111;                    
        end
        default: begin
            segment_number = 0;
            segment_enable = 0;         
        end
    endcase
end

endmodule
