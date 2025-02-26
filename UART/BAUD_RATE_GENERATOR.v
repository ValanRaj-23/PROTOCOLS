module baud_rate(input clk,
		 input reset,
		 input [1:0]baud_sel,
		output reg baud_clk);
	integer baud_div, count; 

parameter 	baud2400 = 0,
		baud4800 = 1,
		baud9600 = 2,
		baud19200 =3;

always@(*)
begin
	case(baud_sel)
		2'b00 : baud_div = 15'd28033;
		2'b01 : baud_div = 14'd10416;
		2'b10 : baud_div = 13'd5208;
		2'b11 : baud_div = 12'd2604;
	endcase
end



always@(posedge clk, negedge reset)
begin
	if(!reset)
	begin
		baud_clk <= 0;
		count <= 0;
	end
	else if(baud_clk == count)
	begin
		baud_clk <= ~baud_clk;
		count <= 0;
	end
	else 
	begin
		count <= count + 1'b1;
	end
end
endmodule
