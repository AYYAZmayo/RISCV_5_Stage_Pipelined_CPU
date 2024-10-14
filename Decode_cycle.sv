 `include "Control_unit_top.sv"
 `include "Reg_file.sv"
 `include "sign_extend.sv"


module Decode_Cycle(clk,rst,FlushE,InstrD, PCD, PCPlus4D, RegWriteW, RDW, ResultW, RegWriteE,
ALUSrcE,MemWriteE,ResultSrcE,BranchE, JumpE,ALUControlE,RD1_E,RD2_E ,Imm_Ext_E,RD_E,PCE,PCPlus4E,
RS1_E, RS2_E);
input clk,rst,RegWriteW,FlushE;
input [4:0] RDW;
input [31:0] InstrD, PCD, PCPlus4D,ResultW;

output RegWriteE,ALUSrcE,MemWriteE,BranchE, JumpE;
output [1:0] ResultSrcE;
output [2:0] ALUControlE;
output [31:0] RD1_E, RD2_E ,Imm_Ext_E;
output [4:0] RD_E;
output [4:0] RS1_E, RS2_E;
output [31:0] PCE,PCPlus4E;
//
wire RegWriteD,ALUSrcD,MemWriteD,BranchD,Zero,JumpD;
wire [1:0]ImmSrcD,ResultSrcD;
wire [2:0] ALUControlD;
wire [31:0] RD1D,RD2D,Imm_ExtD;
// Register Declarations
reg RegWriteD_r,ALUSrcD_r,MemWriteD_r,BranchD_r,JumpD_r;

reg [1:0]ImmSrcD_r,ResultSrcD_r;
reg [2:0] ALUControlD_r;
reg [31:0] RD1D_r,RD2D_r,Imm_ExtD_r;
reg [4:0] RD_D_r,RS1_D_r,RS2_D_r;
reg [31:0]PCD_r, PCPlus4D_r;


Control_Unit_Top Control_Unit(
    .Op(InstrD[6:0]),
    .Zero(Zero) ,
    .Jump(JumpD),
    .ResultSrc(ResultSrcD), 
    .Branch(BranchD),
    .MemWrite(MemWriteD), 
    .ALUSrc(ALUSrcD), 
    .ImmSrc(ImmSrcD), 
    .RegWrite(RegWriteD),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[31:25]),
    .ALUControl(ALUControlD)
    );

reg_file Regiser_File(
    .clk(clk),
    .rst(rst),
    .WE3(RegWriteW), // write enable
    .WD3(ResultW), // data-in (write data)
    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]), // Address read
    .A3(RDW), // Address write;
    .RD1(RD1D),
    .RD2(RD2D)
    );

sign_extend SignExtend(
    .In(InstrD[31:0]),
    .Imm_Ext(Imm_ExtD),
    .ImmSrc(ImmSrcD)
    );


always @(posedge clk or negedge rst)begin
    if(rst==1'b0 | FlushE == 1'b1)begin
        RegWriteD_r <= 1'b0;
        ALUControlD_r <=3'b000;
        ALUSrcD_r<= 1'b0;
        MemWriteD_r<= 1'b0;
        ResultSrcD_r <=2'b00;
        BranchD_r <= 1'b0;
        JumpD_r <= 1'b0;
        RD1D_r<=32'd0;
        RD2D_r<=32'b0;
        Imm_ExtD_r<=32'd0;
        RD_D_r<=5'd0;
        PCD_r<=32'd0;
        PCPlus4D_r<= 32'd0;
        RS1_D_r <=5'd0;
        RS2_D_r <=5'd0;
    end
    else begin
        RegWriteD_r <= RegWriteD;
        ALUControlD_r <= ALUControlD;
        ALUSrcD_r<= ALUSrcD;
        MemWriteD_r<= MemWriteD;
        ResultSrcD_r <=ResultSrcD;
        BranchD_r <= BranchD;
        JumpD_r <= JumpD;
        RD1D_r<= RD1D;
        RD2D_r<= RD2D;
        Imm_ExtD_r<= Imm_ExtD;
        RD_D_r<= InstrD[11:7];
        PCD_r<= PCD;
        PCPlus4D_r<= PCPlus4D;
        RS1_D_r <=InstrD[19:15];
        RS2_D_r <=InstrD[24:20];
    end
end

assign RegWriteE   = RegWriteD_r;
assign ALUSrcE     = ALUSrcD_r;
assign MemWriteE   = MemWriteD_r;
assign ResultSrcE  = ResultSrcD_r;
assign BranchE     = BranchD_r;
assign JumpE       = JumpD_r ;
assign ALUControlE = ALUControlD_r;
assign RD1_E       = RD1D_r;
assign RD2_E       = RD2D_r;
assign Imm_Ext_E   = Imm_ExtD_r;
assign RD_E        = RD_D_r;
assign PCE         = PCD_r;
assign PCPlus4E    = PCPlus4D_r;
assign RS1_E       = RS1_D_r;
assign RS2_E       = RS2_D_r;


endmodule