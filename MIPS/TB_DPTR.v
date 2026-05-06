`timescale 1ns/1ns
module TB_DPTR;
reg CLK;
reg RESET
DPTR mydptr(.CLK(CLK), .RESET(RESET));
initial begin
    #100 RESET <= 1'b0;
    #100 RESET <= 1'b1;
    #100 RESET <= 1'b0;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100 CLK <= 1'b1;
    #100 CLK <= 1'b0;
    #100
    $finish;
end
endmodule