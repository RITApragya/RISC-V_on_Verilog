module ALU (
    input [3:0] ALUCtl,
    input [31:0] A,B,
    output reg [31:0] ALUOut,
    output zero
);

    always @(*) begin

        case (ALUCtl)
            4'b0000: ALUOut = A + B;
            4'b0001: ALUOut = A + ~B + 1;
            4'b0010: ALUOut = A | B;
            4'b0011: ALUOut = A & B;
            4'b0100: ALUOut = A ^ B;
            4'b0101: ALUOut = (A[31] != B[31]) ? A[31] : (A < B);
            4'b0110: ALUOut = (A < B) ? 1 : 0;
            4'b0111: ALUOut = A << B;
            4'b1000: ALUOut = A >> B;
            4'b1001: ALUOut = A >>> B;

            default: ALUOut = 32'hxxxxxxxx;
        endcase

    end

    assign zero = (ALUOut == 0) ? 1 : 0;
    
endmodule

