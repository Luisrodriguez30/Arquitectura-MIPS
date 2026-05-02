module SignExtend (
    input [15:0]Inst,
    output reg[31:0]DataOut
);
    always @(*) begin
        DataOut = {{16{Inst[15]}}, Inst};
    end
endmodule