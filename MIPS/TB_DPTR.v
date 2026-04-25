`timescale 1ns/1ns
module TB_DPTR;
wire [31:0]InstTR;
reg [31:0]DIR;
DPTR mydptr(.InstTR(InstTR));
MEMI mymemi(.dir(DIR), .DSalida(InstTR));
initial begin
    #100
    #100 DIR <= 32'd0;
    #100 DIR <= 32'd4;
    #100 DIR <= 32'd8;
    #100 DIR <= 32'd12;
    #100 DIR <= 32'd16;
    #100 DIR <= 32'd20;
    #100
    $finish;
end
endmodule