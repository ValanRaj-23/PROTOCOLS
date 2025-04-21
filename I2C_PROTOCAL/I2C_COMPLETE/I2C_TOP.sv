`include "I2C_MASTER.sv"
`include "I2C_SLAVE.sv"

module i2c_top(
		input 	sys_clk,
		input 	rst,
  		input 	[7:0] data,
  		input 	[7:0] addr,
		input 	wr_bit,
		input 	run,
		output	scl_out,
		inout	sda_out,
  		output bit	i2c_clk
		
		);



master uut1(
	.sys_clk  	(sys_clk),
	.rst     	(rst),
	.data    	(data),
	.addr     	(addr),
  	.wr_bit   	(wr_bit),
	.run     	(run),      	           
	.scl_out_m	(scl_out),
  	.sda_out_m	(sda_out),
  	.i2c_clk	(i2c_clk)
);

slave uut2(
  	.scl_out_s(scl_out),
	.sda_out_s(sda_out)
	);

	endmodule
