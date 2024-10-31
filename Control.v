module Control (
    input [6:0] opcode,
    output  branch,
    output  memRead,
    output  memtoReg,
    output  [1:0] ALUOp,
    output  memWrite,
    output  ALUSrc,
    output  regWrite
    );

    reg [7:0] controls;

    always@(*) begin
        casez (opcode)
               // RegWrite_ALUSrc_memWrite_ALUOp_memtoREg_memRead_Branch
        7'b0000011: controls = 8'b1_1_0_00_1_1_0; // lw
        7'b0100011: controls = 8'b0_1_1_00_0_0_0; // sw
        7'b0110011: controls = 8'b1_0_0_10_0_0_0; // R–type
        7'b1100011: controls = 8'b0_0_0_01_0_0_1; // beq
		7'b0010011: controls = 8'b1_1_0_10_0_0_0; // I–type ALU
        
        default:    controls = 8'bxxxxxxx0; 

    endcase
    end

    assign {regWrite,ALUSrc,memWrite,ALUOp,memtoReg,memRead,branch} = controls;

    // TODO: implement your Control here
    // Hint: follow the Architecture to set output signal

endmodule




