`timescale 1ns/1ns
module TB_DPTR;
    reg CLK;
    reg RESET;
    DPTR mydptr(.CLK(CLK), .RESET(RESET));
    initial CLK = 1'b0;
    always #10 CLK = ~CLK;
    initial begin
        RESET = 1'b1;
        #25;
        RESET = 1'b0;
    end
    initial begin
        $display("=== Testbench DPTR Fase 2 ===");
        $display("Tiempo | PC       | Instruccion | Reg destino | Resultado ALU");
        $monitor("%0t    | %h | %h  | R%-2d=%0d",
                 $time,
                 mydptr.DIR,
                 mydptr.InstTR,
                 mydptr.AW,
                 mydptr.ALUResult);
    end
    initial begin
        #500;
        $display("=== Fin de simulacion ===");
        $finish;
    end
    initial begin
        $dumpfile("tb_dptr.vcd");
        $dumpvars(0, TB_DPTR);
    end
endmodule