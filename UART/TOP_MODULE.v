	module top_module (
	input reset,clk,sent,p_sel,
	input [1:0]baud_sel,
	input [7:0]d_in,
	output error,
	output [7:0]rx,
	output test
	);
	wire intx, inrx;
	wire out;
		baud_generator baud_gen(	.clk(clk),
						.reset(reset),
						.baud_sel(baud_sel),
						.intx(intx), 
						.inrx(inrx)
							    );
	
		uart_tx uartt(			.reset(reset),
		         			.clk(clk),
		         			.sent(sent),
		         			.d_in(d_in),
		         			.bclk_tx(intx),
		         			.p_sel(p_sel),
		         			.tx(out)
		                         );

		uart_rx uartr(			.clk(clk),
				  		.reset(reset),
				  		.rx(rx),
				  		.d_in(out),
				  		.bclk_rx(inrx),
				  		.error(error)
				                );


		assign test = intx;
	endmodule
