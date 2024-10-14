`include "PC_Adder.sv"
`include "instr_mem.sv"
`include "pc.sv"
`include "mux2x1.sv"
module fetch_cycle(clk, rst, StallF, StallD,PCSrcE, PCTargetE, InstrD,PCD,PCPlus4D);
input clk,rst,StallF,StallD;
input PCSrcE;
input [31:0] PCTargetE;
output [31:0] InstrD, PCD, PCPlus4D;


wire [31:0] PC_F, PCF, PCPlus4F, InstrF;

reg [31:0] InstrF_reg , PCF_reg, PCPlus4F_reg;


//PC MUX
Mux2x1 PC_MUX(.a(PCPlus4F),.b(PCTargetE),.s(PCSrcE),.y(PC_F));

// PC Counter
P_C programm_counter(.PC_NEXT(PC_F), .PC(PCF), .rst(rst),.En(StallF) ,.clk(clk));

// Instruction Memory
Instr_mem IMEM(.A(PCF),.rst(rst),.RD(InstrF));

//PC adder
PC_Adder PCAdder(.a(PCF),.b(32'd4),.c(PCPlus4F));

// Fetch Cycle Register Logic
always @(posedge clk or negedge rst)begin
    if(~rst)begin
        InstrF_reg<= 32'd0;
        PCF_reg <= 32'd0;
        PCPlus4F_reg <= 32'd0;
    end
    else begin
        if(~StallD) begin
            InstrF_reg<= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end
end

assign InstrD   = (~rst)? 32'd0 : InstrF_reg;
assign PCD      = (~rst)? 32'd0 : PCF_reg;
assign PCPlus4D = (~rst)? 32'd0 : PCPlus4F_reg;


endmodule 
