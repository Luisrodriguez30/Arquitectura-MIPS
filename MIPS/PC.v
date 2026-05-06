module PC (
    input CLK,
    input RESET,
    input [31:0]CONT,
    output reg[31:0]Inst
);
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            Inst = 32'b0;
        end
        else begin
        Inst = CONT;
        end
    end // Decir donde esta el error.
endmodule