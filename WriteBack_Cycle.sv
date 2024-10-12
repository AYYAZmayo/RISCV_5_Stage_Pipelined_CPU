`include "mux4x1.sv"
module WriteBack_Cycle(clk, rst, ResultSrcW, PCPlus4W, ALU_ResultW, ReadDataW, ResultW);

input clk, rst;
input [1:0] ResultSrcW;
input [31:0] PCPlus4W, ReadDataW,ALU_ResultW;

output [31:0] ResultW;

Mux4x1 WriteBack_Mux(.a(ALU_ResultW),.b(ReadDataW),.c(PCPlus4W),.s(ResultSrcW),.y(ResultW));


endmodule 