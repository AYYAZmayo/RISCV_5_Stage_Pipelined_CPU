`include "alu.sv"
`include "muxsel.sv"
//`include "mux2x1.sv"
//`include "PC_Adder.sv"

module Execute_Cycle(clk,rst,RegWriteE, ALUSrcE, MemWriteE, ResultSrcE,
                    BranchE,JumpE ,ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E,PCTargetE,
                    PCSrcE,RegWriteM,MemWriteM,ResultSrcM,ALU_ResultM,WriteDataM,RD_M,PCPlus4M, ResultW,
                    ForwardA_E,ForwardB_E);
input clk,rst;
input RegWriteE,ALUSrcE,MemWriteE,BranchE, JumpE;
input [1:0] ResultSrcE;
input [2:0] ALUControlE;
input [31:0] RD1_E, RD2_E ,Imm_Ext_E;
input [4:0] RD_E;
input [31:0] PCE,PCPlus4E;
input [31:0] ResultW; // for pipelining
input [1:0] ForwardA_E, ForwardB_E;

output [31:0] PCTargetE;
output PCSrcE,RegWriteM,MemWriteM;
output [1:0] ResultSrcM;
output [31:0] ALU_ResultM,WriteDataM,PCPlus4M;
output [4:0] RD_M;
//wires
wire [31:0] SrcBE, ResultE, SrcAE, SrcB;
wire ZeroE;
//

reg RegWriteE_r, MemWriteE_r;
reg [1:0] ResultSrcE_r;
reg [4:0] RD_E_r;
reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;


MuxSEL3by1 SrcAMux(     .a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .y(SrcAE)
                    );
MuxSEL3by1 SrcBMux( .a(RD2_E),
                    .b(ResultW),
                    .c(ALU_ResultM),
                    .s(ForwardB_E),
                    .y(SrcB)
                );

Mux2x1 ALU_Src_MUX(.a(SrcB),.b(Imm_Ext_E),.s(ALUSrcE),.y(SrcBE));

alu ALU(.A(SrcAE), .B(SrcBE), .ALUControl(ALUControlE), .Result(ResultE) ,.Negative(), .Zero(ZeroE), .Carry(), .OverFlow());

PC_Adder Branch_adder(.a(PCE),.b(Imm_Ext_E),.c(PCTargetE));

always @(posedge clk or negedge rst)begin
    if (rst==1'b0)begin
        RegWriteE_r  <= 1'b0;
        MemWriteE_r  <= 1'b0;
        ResultSrcE_r <= 2'b0;
        RD_E_r       <= 5'd0;
        PCPlus4E_r   <= 32'd0;
        RD2_E_r      <= 32'd0;
        ResultE_r    <= 32'd0;
    end
    else begin
        RegWriteE_r  <= RegWriteE;
        MemWriteE_r  <= MemWriteE;
        ResultSrcE_r <= ResultSrcE;
        RD_E_r       <= RD_E;
        PCPlus4E_r   <= PCPlus4E;
        RD2_E_r      <= SrcB;
        ResultE_r    <= ResultE;
    end
end

assign PCSrcE = (ZeroE & BranchE) | JumpE ;
assign RegWriteM   = RegWriteE_r;
assign MemWriteM   = MemWriteE_r;
assign ResultSrcM  = ResultSrcE_r;

assign ALU_ResultM = ResultE_r;
assign WriteDataM  = RD2_E_r;
assign RD_M        = RD_E_r;
assign PCPlus4M    = PCPlus4E_r;



endmodule