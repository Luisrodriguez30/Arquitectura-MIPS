module UNITCTRL (
    input [5:0]Op,
    output reg Regwrite,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg [2:0]AluOp
);
    always @(Op) begin
        case (Op)
            6'b000000 : begin
                Regwrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                AluOp = 3'b010;
            end
        endcase
    end
endmodule