module tb();
reg 	sys_clk;
reg 	rst;
reg 	[7:0] data;
reg 	[7:0] addr;
reg 	wr_bit;
reg 	run;
reg		sda_oe 		= 0;
reg		sda_in_s 	= 1;
wire 	scl_out;
wire	sda_out;
wire	i2c_clk;
  
  assign sda_out = (sda_oe == 1) ? sda_in_s : 1'bz;

master uut(
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
  
always #5 sys_clk = ~sys_clk;


initial begin
	sys_clk = 0;
	rst = 0;
	
	#10;
	data = 4'b0101;
	addr = 4'b1010;
	run = 0;
	rst = 1;

	#10;

	run = 1;
	
	#10;
end


  initial begin

   	sda_in_s = 	1;
    sda_oe   =	0;
    
    #1043;
    @(posedge i2c_clk)
    sda_in_s = 	0;
    sda_oe 	 = 	1;
    
    #2;
    @(posedge i2c_clk)
    sda_in_s =  1;
    sda_oe	 = 	0;
 
  end
  
initial begin
  $monitor("scl_out  = %d sda_out = %0d", scl_out, sda_out);
		$dumpfile("dump.vcd");
		$dumpvars;
		#10000;
		$finish;
end

endmodule


