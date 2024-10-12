module Pipeline_tb();
reg clk=0,rst;

Pipeline_Top CPU(.clk(clk),.rst(rst));

always #50 clk=~clk;

initial begin
    rst=0;
    #200;
    rst=1;
    #1000;
    $finish;
end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
end
endmodule 