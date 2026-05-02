module DPTR (
    input [31:0]InstTR
);
//wire
    wire [31:0]C1; // DR2
    wire [31:0]C2; // DR1
    wire [31:0]C3; // Result Alu
    wire [3:0]C4; // SelAlu
    wire [31:0]C5; // Salida Mem
    wire [31:0]C6; // Salida Mux
    wire [4:0]C7; //AW
    wire [31:0]C8; //ALU B
    wire [31:0]C9; //SignExtend
    wire CRD, CRW, CMW, CMR, CMTR, CAS;
    wire [2:0]CA;
//reg
//instancias
//RS = InstTR[25:21];
//RT = InstTR[20:16];
//RD = InstTR[15:11];
    BR br(.RegEn(CRW), .AR1(InstTR[25:21]), .AR2(InstTR[20:16]), .AW(C7), .DW(C6), .DR1(C2), .DR2(C1));
    ALUMIPS alu(.A(C2), .B(C8), .Sel(C4), .R(C3));
    MEMA mem(.DIR(C3), .WE(CMW), .RE(CMR), .DATA_IN(C1), .DATA_OUT(C5));
    Mux2a1 mux(.mem(C5), .alu(C3), .UCctl(CMTR), .R(C6));
    UNITCTRL uc(.Op(InstTR[31:26]), .RegDst(CRD), .AluSrc(CAS), .MemToReg(CMTR), .Regwrite(CRW), .MemRead(CMR), .MemWrite(CMW), .AluOp(CA));
    ALUCTRL aluctrl(.AluOp(CA), .func(InstTR[5:0]), .SelAlu(C4));
    Mux2a1_5b muxBR(.mem(InstTR[15:11]), .alu(InstTR[20:16]), .UCctl(CRD), .R(C7));
    Mux2a1 muxalu(.mem(C9), .alu(C1), .UCctl(CAS), .R(C8));
    SignExtend SignExt(.Inst(InstTR[15:0]), .DataOut(C9));

endmodule