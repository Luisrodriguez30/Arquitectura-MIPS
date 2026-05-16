module ALUMIPS (
	input [31:0] A,
	input [31:0] B,
	input [3:0] Sel,
	output reg[31:0] R
);

always @(*) begin
	case (Sel)
		4'b0000: R = A & B;
		4'b0001: R = A | B;
		4'b0010: R = A + B;
		4'b0110: R = A - B;
		4'b0111: R = (A < B) ? 1:0;
		4'b1100: R = ~(A | B);
	endcase
end

endmodule