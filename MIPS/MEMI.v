module MEMI (
    input [31:0]dir,
    output reg[31:0]DSalida
);
    reg[7:0] MEM[0:255];
    initial begin
        $readmemb("inst.txt", MEM);
    end

    always @(dir) begin //BIG ENDIANESS
        DSalida <= {MEM[dir],MEM[dir+1],MEM[dir+2],MEM[dir+3]};
    end
endmodule