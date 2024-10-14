
`include "ALU_Decoder.sv"
`include "Main_Decoder.sv"
`include "Fetch_cycle.sv"
`include "Decode_cycle.sv"
`include "Execute_Cycle.sv"
`include "Memory_Cycle.sv"
`include "WriteBack_Cycle.sv"
`include "hazard_unit.sv"
module Pipeline_Top(clk,rst);
input clk,rst;
wire PCSrcE,RegWriteW,RegWriteE,ALUSrcE,MemWriteE,BranchE,JumpE;
wire RegWriteM,MemWriteM;
wire [4:0] RDW,RD_E,RD_M,RS1_E,RS2_E;
wire [1:0] ResultSrcE,ResultSrcM,ResultSrcW;
wire [2:0] ALUControlE;
wire [31:0] PCTargetE,InstrD,PCD,PCPlus4D,ResultW;
wire [31:0] RD1_E, RD2_E ,Imm_Ext_E;
wire [31:0] PCE,PCPlus4E,PCPlus4M,PCPlus4W,ALU_ResultM,WriteDataM;
wire [31:0] ReadDataW,ALU_ResultW;
wire [1:0] ForwardAE,ForwardBE;
wire FlushE, StallD, StallF, FlushD;

fetch_cycle Fetch_Stage(.clk(clk),
                        .rst(rst),
                        .StallF(StallF),
                        .StallD(StallD),
                        .FlushD(FlushD),
                        .PCSrcE(PCSrcE), 
                        .PCTargetE(PCTargetE),
                        .InstrD(InstrD),
                        .PCD(PCD),
                        .PCPlus4D(PCPlus4D)
                        );

Decode_Cycle Decode_Stage(.clk(clk),
                          .rst(rst),
                          .FlushE(FlushE),
                          .InstrD(InstrD),
                          .PCD(PCD),
                          .PCPlus4D(PCPlus4D),
                          .RegWriteW(RegWriteW),
                          .RDW(RDW),
                          .ResultW(ResultW), 
                          .RegWriteE(RegWriteE),
                          .ALUSrcE(ALUSrcE),
                          .MemWriteE(MemWriteE),
                          .ResultSrcE(ResultSrcE),
                          .BranchE(BranchE), 
                          .JumpE(JumpE),
                          .ALUControlE(ALUControlE),
                          .RD1_E(RD1_E),
                          .RD2_E(RD2_E) ,
                          .Imm_Ext_E(Imm_Ext_E),
                          .RD_E(RD_E),
                          .PCE(PCE),
                          .PCPlus4E(PCPlus4E),
                          .RS1_E(RS1_E),
                          .RS2_E(RS2_E)
                           );

Execute_Cycle Execute_Stage (.clk(clk),
                             .rst(rst),
                             .RegWriteE(RegWriteE),
                             .ALUSrcE(ALUSrcE), 
                             .MemWriteE(MemWriteE), 
                             .ResultSrcE(ResultSrcE),
                             .BranchE(BranchE),
                             .JumpE(JumpE) ,
                             .ALUControlE(ALUControlE),
                             .RD1_E(RD1_E),
                             .RD2_E(RD2_E), 
                             .Imm_Ext_E(Imm_Ext_E),
                             .RD_E(RD_E), 
                             .PCE(PCE), 
                             .PCPlus4E(PCPlus4E),
                             .PCTargetE(PCTargetE),
                             .PCSrcE(PCSrcE),
                             .RegWriteM(RegWriteM),
                             .MemWriteM(MemWriteM),
                             .ResultSrcM(ResultSrcM),
                             .ALU_ResultM(ALU_ResultM),
                             .WriteDataM(WriteDataM),
                             .RD_M(RD_M),
                             .PCPlus4M(PCPlus4M),
                             .ResultW(ResultW),
                             .ForwardA_E(ForwardAE),
                             .ForwardB_E(ForwardBE)
                             );

Memory_Cycle Memory_Stage(.clk(clk),
                          .rst(rst), 
                          .RegWriteM(RegWriteM), 
                          .MemWriteM(MemWriteM), 
                          .ResultSrcM(ResultSrcM),
                          .ALU_ResultM(ALU_ResultM), 
                          .WriteDataM(WriteDataM),
                          .RD_M(RD_M), 
                          .PCPlus4M(PCPlus4M),
                          .RegWriteW(RegWriteW),
                          .ResultSrcW(ResultSrcW),
                          .RD_W(RDW),
                          .PCPlus4W(PCPlus4W),
                          .ReadDataW(ReadDataW),
                          .ALU_ResultW(ALU_ResultW)
                          );
hazard_unit Forwarding_Block(
                            .rst(rst), 
                            .RegWriteM(RegWriteM),
                            .RegWriteW(RegWriteW),
                            .RD_M(RD_M),
                            .RD_W(RDW), 
                            .RS1_E(RS1_E),
                            .RS2_E(RS2_E),
                            .ForwardAE(ForwardAE),
                            .ForwardBE(ForwardBE),
                            .ResultSrcE0(ResultSrcE[0]),
                            .RS1_D(InstrD[19:15]), 
                            .RS2_D(InstrD[24:20]), 
                            .RD_E(RD_E),
                            .PCSrcE(PCSrcE),
                            .FlushD(FlushD),
                            .FlushE(FlushE),
                            .StallD(StallD),
                            .StallF(StallF)
                            );
WriteBack_Cycle WriteBack_Stage(.clk(clk),
                                .rst(rst), 
                                .ResultSrcW(ResultSrcW),
                                .PCPlus4W(PCPlus4W), 
                                .ALU_ResultW(ALU_ResultW), 
                                .ReadDataW(ReadDataW),
                                .ResultW(ResultW)
                                );


endmodule 