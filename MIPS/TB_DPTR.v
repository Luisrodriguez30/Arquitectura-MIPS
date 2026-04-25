`timescale 1ns/1ns
module TB_DPTR;
wire [31:0]InstTR;
reg [31:0]DIR;
DPTR mydptr(.InstTR(InstTR));
MEMI mymemi(.dir(DIR), .DSalida(InstTR));
initial begin
    #10
    #10 DIR <= 32'd0;
    #10 //DIR <= 32'd4;
    #10 //DIR <= 32'd8;
    #100
    $finish;
end
endmodule