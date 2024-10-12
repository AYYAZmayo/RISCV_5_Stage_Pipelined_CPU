
`include "data_mem.sv"
module Memory_Cycle(clk,rst, RegWriteM, MemWriteM, ResultSrcM, ALU_ResultM, WriteDataM, RD_M, PCPlus4M,
                    RegWriteW,ResultSrcW,RD_W,PCPlus4W, ReadDataW,ALU_ResultW);

input clk,rst;
input RegWriteM,MemWriteM;
input [1:0] ResultSrcM;
input [31:0] ALU_ResultM,WriteDataM;
input [31:0] PCPlus4M;
input [4:0] RD_M;

output RegWriteW;
output [1:0] ResultSrcW;
output [4:0] RD_W;
output [31:0] PCPlus4W, ReadDataW,ALU_ResultW;

wire [31:0] ReadMem;

reg RegWriteM_r;
reg [1:0] ResultSrcM_r;
reg [31:0] ALU_ResultM_r;
reg [4:0] RD_M_r;
reg [31:0] PCPlus4M_r;
reg [31:0] ReadMem_r;

data_mem Data_Memory(.A(ALU_ResultM),.WD(WriteDataM),.clk(clk),.WE(MemWriteM),.rst(rst),.RD(ReadMem));

always @(posedge clk, negedge rst)begin
    if(rst==1'b0)begin
        RegWriteM_r  <= 1'b0;
        ResultSrcM_r <= 2'b0;
        RD_M_r       <= 5'd0;
        ALU_ResultM_r<= 32'd0;
        ReadMem_r    <= 32'd0;
        PCPlus4M_r   <= 32'd0;
    end
    else begin
        RegWriteM_r  <= RegWriteM;
        ResultSrcM_r <= ResultSrcM;
        ALU_ResultM_r<= ALU_ResultM;
        ReadMem_r    <= ReadMem;
        RD_M_r       <= RD_M;
        PCPlus4M_r   <= PCPlus4M;
    end
end

assign RegWriteW        = RegWriteM_r;
assign ResultSrcW       = ResultSrcM_r;
assign RD_W             = RD_M_r;
assign PCPlus4W        = PCPlus4M_r;
assign ReadDataW        = ReadMem_r;
assign ALU_ResultW      = ALU_ResultM_r;


endmodule