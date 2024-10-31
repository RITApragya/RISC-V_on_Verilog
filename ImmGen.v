module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) 
    begin
        case(opcode[6:5])

            2'b00:   imm = {{20{inst[31]}}, inst[31:20]}; // I−type
            2'b01:   imm = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // S−type 
            2'b11:   imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};  // B−type 
            
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map table to set imm value

	endcase
    end
            
endmodule

