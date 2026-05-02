module Mux2a1_5b (
	input [4:0] mem, alu,
    input UCctl,
	output reg[4:0] R
);

//2. declaracion de wires: NA, regs: SI

//3. cuerpo del modulo, instancias: NA, assigns: NA, Bloque secuencial: SI

always @(*) // Cualquier asignacion dentro de un bloque secuencial
	begin
		case(UCctl)
			1'd0: R = alu;
			1'd1: R = mem;
		endcase
	end

endmodule
