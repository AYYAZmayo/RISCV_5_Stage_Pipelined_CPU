module hazard_unit(rst, RegWriteM,RegWriteW,RD_M,RD_W, RS1_E,RS2_E, ResultSrcE0, RS1_D, RS2_D,
                    ForwardAE, ForwardBE,RD_E,FlushE, StallD, StallF);

input rst, RegWriteM, RegWriteW, ResultSrcE0;
input [4:0] RD_M, RD_W, RS1_E, RS2_E;

input [4:0] RS1_D, RS2_D, RD_E;

output [1:0] ForwardAE, ForwardBE;

output FlushE, StallD, StallF;

wire lwStall;
assign ForwardAE =  (rst ==1'b0)?2'b00 : 
                    ((RegWriteM == 1'b1) & (RD_M != 5'd0) & (RD_M ==RS1_E)) ? 2'b10 :
                    ((RegWriteW == 1'b1) & (RD_W != 5'd0) & (RD_W ==RS1_E)) ? 2'b01 : 2'b00;

assign ForwardBE =  (rst ==1'b0)?2'b00 :
                    ((RegWriteM == 1'b1) & (RD_M != 5'd0) & (RD_M ==RS2_E)) ? 2'b10 :
                    ((RegWriteW == 1'b1) & (RD_W != 5'd0) & (RD_W ==RS2_E)) ? 2'b01 : 2'b00;

assign lwStall   = (rst ==1'b0)?2'b00 : 
                   (ResultSrcE0 & ((RS1_D == RD_E) | (RS2_D == RD_E))) ? 1'b1 : 1'b0;

assign StallF = lwStall;
assign StallD = lwStall; 
assign FlushE = lwStall;


endmodule