module P_C(PC_NEXT, PC, rst, En ,clk);
input [31:0]PC_NEXT;
input rst,clk,En;
output reg [31:0]PC;

always @(posedge clk)begin
	if(~rst)
		PC <= 'b0;
	else begin 
		if(~En)
			PC <= PC_NEXT;
		else
			PC <= PC;
	end
end

endmodule