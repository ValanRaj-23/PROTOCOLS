module tb();
		
reg 	clk;
reg 	rst;
reg 	run;
reg 	[7:0]addr;
reg 	[7:0]data;
reg		wr_en;
reg 	ack;

wire	scl_m;
wire	sda_m;

master uut(	.clk	(clk),
			.rst	(rst),
			.run	(run),
			.addr	(addr),
			.data	(data),
			.wr_en	(wr_en),
			.ack	(ack),
			.scl_m	(scl_m),
			.sda_m	(sda_m)
	);

	always #5 clk = ~clk;

	initial begin
		clk	=	0;
		rst	=	0;

		#10;

		rst	=	1;
		#10;

		run 	= 	0;
		ack	=	0;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars();
		#10000;
		$finish;
	end

endmodule
