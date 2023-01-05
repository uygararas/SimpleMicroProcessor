`timescale 1ns / 1ps

module ALU(Y,A,B,F);
input logic [3:0] A,B;
input logic [2:0] F;
output logic [3:0] Y;

parameter OP_AND = 3'b000;
parameter OP_OR = 3'b001;
parameter OP_ADD = 3'b010;
parameter OP_ANDI = 3'b011;
parameter OP_MOV = 3'b100;
parameter OP_SUB = 3'b101;
parameter OP_LT = 3'b110;
parameter OP_GT = 3'b111;

always_comb
begin
    case(F)
        OP_AND : Y = A & B;
        OP_OR  : Y = A | B;
        OP_ADD : Y = A + B;
        OP_ANDI: Y = A & ~B;
        OP_MOV : Y = A;
        OP_SUB : Y = A - B;
        OP_LT : begin
            if(A < B)
                Y = A;
            else
                Y = B;
        end
        OP_GT : begin
            if(A >= B)
                Y = A;
            else
                Y = B;
        end
        default: Y = 0;
    endcase
end



endmodule
