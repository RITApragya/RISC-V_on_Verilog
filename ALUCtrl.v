module ALUCtrl (
    input [1:0] ALUOp,
    input op5,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    always @(*) begin
    case (ALUOp)
        2'b00: ALUCtl = 4'b0000;             // addition for lw and sw
        2'b01: ALUCtl = 4'b0001;             // subtraction for branch
        2'b10:
            case (funct3) // R-type or I-type ALU
                3'b000:  ALUCtl = (funct7 && op5) ? 4'b0001: 4'b0000; //add, addi and sub
                3'b110:  ALUCtl = 4'b0010; // or, ori
                3'b111:  ALUCtl = 4'b0011; // and, andi
                3'b100:	 ALUCtl = 4'b0100; //xor, xori
                3'b010:  ALUCtl = 4'b0101; // slt, slti
				3'b011:  ALUCtl = 4'b0110; //sltu sltui
				3'b001:  ALUCtl = 4'b0111; //sll
				3'b101:  ALUCtl = (funct7) ? 4'b1001 : 4'b1000; //sra ,srai,srl,srli
                    
                default: ALUCtl = 4'bxxxx; 
            endcase
        
        default:ALUCtl = 4'bxxxx;
    endcase
end


endmodule

