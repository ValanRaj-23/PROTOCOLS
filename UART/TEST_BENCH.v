
module test_uart;

reg reset,clk,sent,p_sel;
reg [7:0] d_in;
reg [1:0]baud_sel;
wire error;
wire [7:0]rx;
wire test;

top_module uut1(reset,clk,sent,p_sel,baud_sel,d_in,error,rx,test);


initial begin
	clk = 0;
	forever #10 clk = ~ clk;
end 

initial
begin 
	reset = 0;
	#30;
	reset =1;
	baud_sel = 2'b00;
	d_in = 8'hAA;
	p_sel = 0;
	sent = 1;
end

//always @(posedge test) begin
//	d_in = $random;
//end


initial begin
$dumpfile("test.vcd");
$dumpvars;
#50000000;
$finish;
end
endmodule
