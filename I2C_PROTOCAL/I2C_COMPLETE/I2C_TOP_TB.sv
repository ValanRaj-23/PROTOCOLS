module i2c_top_tb;

reg sys_clk;
reg rst;
reg [7:0] data;
reg [7:0] addr;
reg wr_bit;
reg run;

wire scl_out;
wire sda_out;
wire i2c_out;

always #5 sys_clk = ~sys_clk;
i2c_top uut(
	.sys_clk  	(sys_clk),
	.rst     	(rst),
	.data    	(data),
	.addr     	(addr),
  	.wr_bit   	(wr_bit),
	.run     	(run),      	           
	.scl_out	(scl_out),
  	.sda_out	(sda_out),
  	.i2c_clk	(i2c_clk)
);

initial begin
  $monitor("scl_out  = %d sda_out = %0d", scl_out, sda_out);
		$dumpfile("dump.vcd");
		$dumpvars;
		#10000;
		$finish;
end

initial begin
	sys_clk = 0;
	#20 rst 	= 0;  
  	#100
  		rst		= 1;
		wr_bit	= 1; 
		run 	= 1;
		data 	= 8'h12;
		addr	= 8'hFF;
end

endmodule
