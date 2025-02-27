module uart_tx(	input reset,
				input 	clk,
			 	input 	sent,
				input [7:0] d_in,
				input bclk_tx,
				input p_sel,
				output reg tx
				);

reg [10:0] t_data;
reg [10:0] temp;
reg p_bit;
reg [3:0] t_count;
reg [2:0] ps, ns;

	parameter [2:0] IDLE = 0,
					RECEIVE = 1,
		       		PARITY = 2,
					GEN = 3,
	 				TRANSFER = 4;
	

always@(posedge clk, negedge reset)
begin
	if(!reset)
	begin
		ps <= IDLE;
		tx <= 1;
		t_count <= 10;

	end
	else
		ps <= ns;
end

always@(*)
begin
	case(ps)
			IDLE : begin
					ns = !reset ? IDLE : RECEIVE;
					t_count = 10;
					end
		RECEIVE :begin
				       	temp = d_in;
					ns = PARITY;
					end
		PARITY : begin
					case(p_sel)
						1'b0 : p_bit = !(^temp);
						1'b1 : p_bit = ^temp;
					endcase
					ns = GEN;
					end
		GEN : 	begin
					t_data = {1'b0, d_in, p_bit, 1'b1};
					ns = sent ? TRANSFER : GEN;

					end
		TRANSFER : begin
					
				if(t_count >= 0 && t_count <= 10)
					if(bclk_tx)
					begin
						tx = t_data[t_count];
						t_count = t_count - 1;
		
					end
					else
						ns = TRANSFER;

				else
					begin
						ns = IDLE;
						
					end
		end
		default: ns = IDLE;
	endcase
end				
endmodule
