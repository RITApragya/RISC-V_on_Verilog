module SingleCycleCPU (
    input clk,
    input start
    
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,

wire [31:0] inst,pc_i,imm,shifted_imm, pc,A,B_reg,B,writeData,readData,PCTarget,ALUOut;
wire [1:0]ALUOp;
wire [3:0]ALUCtl;
wire [31:0]pc_o;
wire [4:0]readReg1,readReg2,writeReg;

assign readReg1 = inst[19:15];
assign readReg2 = inst[24:20];
assign writeReg = inst[11:7];


wire branch,memRead,memtoReg,memWrite,ALUSrc,regWrite,zero;
wire sel;
assign sel = branch?zero:0;

//program counter logic


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_i),
    .pc_o(pc_o)
);

Adder m_Adder_1(
    .a(pc_o),
    .b(32'h4),
    .sum(pc)
);

Adder m_Adder_2(
    .a(pc_o),
    .b(imm),
    .sum(PCTarget)
);

InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);


Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .readData1(A),
    .readData2(B_reg)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(inst),
    .imm(imm)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(shifted_imm)
);


Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(sel),
    .s0(pc),
    .s1(PCTarget),
    .out(pc_i)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(B_reg),
    .s1(imm),
    .out(B)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .op5(inst[5]),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUCtl(ALUCtl),
    .A(A),
    .B(B),
    .ALUOut(ALUOut),
    .zero(zero)
);

DataMemory m_DataMemory(
    .clk(clk),
    .rst(start),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(B_reg),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .out(writeData)
);

endmodule
