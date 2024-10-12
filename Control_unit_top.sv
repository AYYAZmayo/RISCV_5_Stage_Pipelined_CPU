module Control_Unit_Top(Op,Zero,Branch,Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite,funct3,funct7,ALUControl);
input [6:0]Op,funct7;
input [2:0]funct3;
input Zero;
output RegWrite,ALUSrc,MemWrite,Branch,Jump;
output [1:0]ImmSrc,ResultSrc;
output [2:0]ALUControl;

wire [1:0]ALUOp;
wire branch,jump;
assign Branch = branch;
assign  Jump  = jump;
///assign PCSrc = (branch & Zero) | jump;
Main_Decoder main_dec(
					.Op(Op),
					.Branch(branch), 
					.ResultSrc(ResultSrc), 
					.MemWrite(MemWrite), 
					.ALUSrc(ALUSrc), 
					.ImmSrc(ImmSrc), 
					.RegWrite(RegWrite), 
					.ALUOp(ALUOp),
					.Jump(jump)
					);

ALU_Decoder alu_dec(
					.Op(Op), 
					.ALUOp(ALUOp), 
					.funct3(funct3), 
					.funct7(funct7),
					.ALUControl(ALUControl)
					);
					
					
					

endmodule