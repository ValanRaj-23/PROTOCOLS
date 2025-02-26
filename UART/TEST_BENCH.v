module test_uart;
reg reset, clk;
reg d_in;
reg [1:0] baud_sel;
wire [7:0]rx;
wire error;
wire baud_clk;
//reg [8:0]temp;
//integer count;
uart_rx uut ( clk,reset, d_in, baudclk_r,error, rx);
baud_generator uut1 ( clk, reset, baud_sel, baud_clk);
assign baudclk_r = baud_clk;

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end

initial begin
	reset = 0;
	#10;
	reset = 1;
	baud_sel=2'b10;
end 


always @(posedge baud_clk) 
begin
	d_in= $random;
end 

initial begin
	$dumpfile("test.vcd");
	$dumpvars;
	#1000000;
	$finish;
end
endmodule
