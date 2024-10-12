
module fetch_cycle_tb();
reg clk=0,rst,PCSrcE;
reg [31:0] PCTargetE;
wire [31:0] InstrD, PCD, PCPlus4D;

fetch_cycle  fetch_cycle_inst (
    .clk(clk),
    .rst(rst),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .InstrD(InstrD),
    .PCD( PCD),
    .PCPlus4D( PCPlus4D)
  );
always #50 clk=~clk;

initial begin
    rst=1'b0;
    #200;
    rst=1'b1;
    PCSrcE= 1'b0;
    PCTargetE=32'd0;
    #500 $finish;
end



initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
end

endmodule
