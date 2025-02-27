module baud_generator(
	input clk,  
	input reset, //reset
	input [1:0]baud_sel, //selecting the baud
	output intx,inrx);

reg bclk_rx,bclk_tx;

	integer baud_div_tx = 0;
    integer baud_div_rx = 0;
    integer count_tx = 0;
	integer count_rx = 0;
	
	parameter [2:0]	b2400 = 0,
				b4800 = 1,
				b9600 = 2,
				b19200 = 3;

always@(*)
begin
	case(baud_sel)
		2'b00 : baud_div_tx = 15'd28033;
		2'b01 : baud_div_tx = 14'd10416;
		2'b10 : baud_div_tx = 13'd5208;
		2'b11 : baud_div_tx = 12'd2604;
	endcase
end
always@(*)
begin
	case(baud_sel)
		2'b00 : baud_div_rx = 15'd28033;
		2'b01 : baud_div_rx = 15'd10416;
		2'b10 : baud_div_rx = 15'd5208 ;
		2'b11 : baud_div_rx = 15'd2604 ;
	endcase
end

	always@(posedge clk, negedge reset)
	begin
		if(!reset)
		begin
			bclk_tx <= 0;
			count_tx <= 0;
		end 
		else if (count_tx == baud_div_tx)
			 	begin
			 		count_tx <=0;
			 		bclk_tx<= ~bclk_tx;
			 	end 
		else
			 		count_tx <=count_tx+1'b1;
			  
	end 

	always@(posedge clk, negedge reset)
	begin
		if(!reset)
		begin
			bclk_rx <= 0;
			count_rx <= 0;
		end 
		else if (count_rx  == baud_div_rx)
			 	begin
			 		count_rx <=0;
			 		bclk_rx<= ~ bclk_rx;
			 	end 
		else
			 		count_rx <=count_rx +1'b1;
			  
	end 

  
 assign intx = bclk_tx;
 assign inrx = bclk_rx;
	
endmodule
