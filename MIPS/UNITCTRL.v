module UNITCTRL (
    input  [5:0] Op,
    output reg   RegDst,
    output reg   AluSrc,
    output reg   MemToReg,
    output reg   Regwrite,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   Branch,
    output reg   Jump,
    output reg   ImmSel,
    output reg [2:0] AluOp
);
    always @(Op) begin
        RegDst   = 1'b0;
        AluSrc   = 1'b0;
        MemToReg = 1'b0;
        Regwrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ImmSel   = 1'b0;
        AluOp    = 3'b000;
        case (Op)
            6'b000000: begin
                RegDst   = 1'b1;
                AluSrc   = 1'b0;
                MemToReg = 1'b0;
                Regwrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b010;
            end
            6'b100011: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b1;
                Regwrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b000;
            end
            6'b101011: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b0;
                Regwrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b000;
            end
            6'b000100: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b0;
                MemToReg = 1'b0;
                Regwrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b001;
            end
            6'b001000: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b0;
                Regwrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b011;
            end
            6'b001010: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b0;
                Regwrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b0;
                AluOp    = 3'b100;
            end
            6'b001101: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b0;
                Regwrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b1;
                AluOp    = 3'b101;
            end
            6'b001100: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b1;
                MemToReg = 1'b0;
                Regwrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ImmSel   = 1'b1;
                AluOp    = 3'b110;
            end
            6'b000010: begin
                RegDst   = 1'b0;
                AluSrc   = 1'b0;
                MemToReg = 1'b0;
                Regwrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b1;
                ImmSel   = 1'b0;
                AluOp    = 3'b000;
            end
        endcase
    end
endmodule