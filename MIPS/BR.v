module BR (
    input RegEn,
    input [4:0]AR1,
    input [4:0]AR2,
    input [4:0]AW,
    input [31:0]DW,
    output reg[31:0]DR1,
    output reg[31:0]DR2
);
    
    reg [31:0]mem[0:31];
    initial begin
        mem[0] = 32'd10;
        mem[1] = 32'd11;
        mem[2] = 32'd12;
        mem[3] = 32'd13;
        mem[4] = 32'd14;
        mem[5] = 32'd15;
        mem[6] = 32'd16;
        mem[7] = 32'd17;
        mem[8] = 32'd18;
        mem[9] = 32'd19;
        mem[10] = 32'd20;
    end
    always @* begin
        DR1 = mem[AR1];
        DR2 = mem[AR2];
        if (RegEn) begin
            mem[AW] = DW;
        end
    end

endmodule