module DPTR (
    input CLK,
    input RESET
);
    wire [31:0] InstTR;
    wire [31:0] DIR;
    wire [31:0] PC4;
    wire [31:0] PCNext;
    wire [31:0] DR1;
    wire [31:0] DR2;
    wire [31:0] WBData;
    wire [4:0]  AW;
    wire [31:0] ImmOut;
    wire [31:0] ALU_B;
    wire [31:0] ALUResult;
    wire        Zero;
    wire [31:0] MemData;
    wire [31:0] ImmShl2;
    wire [31:0] BranchTarget;
    wire [31:0] JumpTarget;
    wire        BranchTaken;
    wire        CRD;
    wire        CAS;
    wire        CMTR;
    wire        CRW;
    wire        CMR;
    wire        CMW;
    wire        CBranch;
    wire        CJump;
    wire        CImmSel;
    wire [2:0]  CA;
    wire [3:0]  C4;
    assign BranchTaken = CBranch & Zero;
    assign JumpTarget = {PC4[31:28], InstTR[25:0], 2'b00};
    ShiftLeft2 shl2_branch(.A(ImmOut), .R(ImmShl2));
    ADDER adder_branch(.A(PC4), .B(ImmShl2), .R(BranchTarget));
    wire [1:0] PCsel;
    assign PCsel = CJump       ? 2'b10 :
                   BranchTaken ? 2'b01 :
                                 2'b00;
    Mux4a1 mux_pc(
        .in0(PC4),
        .in1(BranchTarget),
        .in2(JumpTarget),
        .Sel(PCsel),
        .R(PCNext)
    );
    PC pc1(.CLK(CLK), .RESET(RESET), .CONT(PCNext), .Inst(DIR));
    ADDER adder1(.A(DIR), .B(32'd4), .R(PC4));
    MEMI mymemi(.dir(DIR), .DSalida(InstTR));
    UNITCTRL uc(
        .Op(InstTR[31:26]),
        .RegDst(CRD),
        .AluSrc(CAS),
        .MemToReg(CMTR),
        .Regwrite(CRW),
        .MemRead(CMR),
        .MemWrite(CMW),
        .Branch(CBranch),
        .Jump(CJump),
        .ImmSel(CImmSel),
        .AluOp(CA)
    );
    Mux2a1_5b muxBR(
        .mem(InstTR[15:11]),
        .alu(InstTR[20:16]),
        .UCctl(CRD),
        .R(AW)
    );
    BR br(
        .RegEn(CRW),
        .AR1(InstTR[25:21]),
        .AR2(InstTR[20:16]),
        .AW(AW),
        .DW(WBData),
        .DR1(DR1),
        .DR2(DR2)
    );
    ImmExtend immext(
        .Imm(InstTR[15:0]),
        .ImmSel(CImmSel),
        .DataOut(ImmOut)
    );
    Mux2a1 muxalu(
        .mem(ImmOut),
        .alu(DR2),
        .UCctl(CAS),
        .R(ALU_B)
    );
    ALUCTRL aluctrl(.AluOp(CA), .func(InstTR[5:0]), .SelAlu(C4));
    ALUMIPS alu(.A(DR1), .B(ALU_B), .Sel(C4), .R(ALUResult), .Zero(Zero));
    MEMA mem(
        .DIR(ALUResult),
        .WE(CMW),
        .RE(CMR),
        .DATA_IN(DR2),
        .DATA_OUT(MemData)
    );
    Mux2a1 mux_wb(
        .mem(MemData),
        .alu(ALUResult),
        .UCctl(CMTR),
        .R(WBData)
    );
endmodule
