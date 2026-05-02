module MEMA (
    input [31:0]DIR,
    input WE,
    input RE,
    input [31:0]DATA_IN,
    output reg [31:0]DATA_OUT
);
    reg [31:0]mem[0:31];
    always @* begin
        if (WE) begin
            mem[DIR] = DATA_IN;
        end
        else if (RE) begin
            DATA_OUT = mem[DIR];
        end
    end
endmodule