module Instr_mem(A,rst,RD);
	input [31:0] A;
	input rst;
	output [31:0] RD;


reg [31:0] mem [0:1023];

assign RD = (rst==0)? 32'h0000_0000: mem[A];
initial begin

	//mem[0] =32'h00500293;
	//mem[4] =32'h00300313;
	//mem[8] =32'h006283B3;
	//mem[12]=32'h00002403;
	//mem[16]=32'h00100493;
	//mem[20]=32'h00940533; 

	mem[0] =32'h00100A93; //addi,x21,x0,0        => x21=0
	mem[4] =32'h028AAB83; //lw x23, 40(x21)      => x23=10
	mem[8] =32'h01CBFC33; //and x24 , x23 , x28  =>  1010 and 1111= 1010
	mem[12]=32'h017B63B3; //or x7, x22, x23      => x7= 1010 or 0000
	mem[12]=32'h016BE3B3; //or x7, x23, x22
	mem[16]=32'h412B89B3; //sub x19, x23, x18    => x19 = 10 - 1

	//$readmemh("memfile.hex",mem);
end
endmodule 