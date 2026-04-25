module ALUCTRL (
    input [2:0]AluOp,
    input [5:0]func,
    output reg[3:0]SelAlu
);
    always @(*) begin
        case (AluOp)
            3'b010 : begin
                case (func)
                    6'b100000 : SelAlu = 4'b0010;
                    6'b100010 : SelAlu = 4'b0110;
                    6'b100100 : SelAlu = 4'b0000;
                    6'b100101 : SelAlu = 4'b0001;
                    6'b101010 : SelAlu = 4'b0111;
                    6'b100111 : SelAlu = 4'b1100;
                endcase
            end
        endcase
    end
endmodule