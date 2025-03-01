`timescale 1ns / 1ps

module uart_tx(
				input 	wire 			p_sel		,
				input 	wire 	[7:0]	data_in		,
				input 	wire 			send		,				
				input 	wire 			clk			,
				input 	wire 			reset		,
				input 	wire 			baud_clk_tx	,
				output	reg 			tx	
			   );

parameter [2:0]		IDLE 		= 	1	,		
					RECEIVE		= 	2	,
					PARITY		=	3	,
					FRAME		= 	4	,
					TRANSMIT	=	5	;

reg [2:0] 	present		;
reg [2:0] 	next		;
reg [7:0] 	temp		;
reg 	  	pbit		;
reg [10:0]	tx_frame	;
reg	[3:0]	tx_count	;
	
always @(posedge clk)	
					begin 
						present <= (!reset) ? IDLE : next;
					end
	
always @(*)
			begin 
				case(present)
							IDLE:	begin 
										next = (!reset) ? IDLE : RECEIVE;
									end
							
							RECEIVE:	
									begin
										next = PARITY;
									end
							
							PARITY:
									begin 
										next = FRAME;
									end
							
							FRAME:
									begin 
										next = 	(send) ? TRANSMIT : FRAME;
									end
								
							TRANSMIT:
									begin
										if (baud_clk_tx) begin
											if (tx_count >= 0 && tx_count < 11 )  
												next = TRANSMIT;
											else
												next = IDLE;  // Move to IDLE after transmission is done
										end
										else
											next = TRANSMIT;  // Wait for baud clock
									end
                            default : next = IDLE;
				endcase
			end	
	
	always @(posedge clk) 
						begin
						if(!reset) begin
								next = 	IDLE;
end
						else begin 	
							case (present)
							IDLE : begin 
									end
									
							RECEIVE: begin 
										temp <= data_in;
									end
									
							PARITY: begin 
										pbit <= (p_sel) ? ~^(temp) : ^(temp);
									end
									
							FRAME:	begin 
										tx_frame <= {1'b0, temp, pbit, 1'b1};
										tx_count <= 10;
									end
											
							endcase
							end
							end
	
	always @(posedge baud_clk_tx)
	begin 
							if(!reset) begin
							next = 	IDLE;
							tx <= 1'b1;
							end
							else
								begin	
									
									if(present == TRANSMIT) begin			
												if(tx_count >=0 && tx_count <= 10)begin
														tx <= tx_frame[tx_count];
														tx_count <= tx_count - 1;
								end
	end
	end
end	
	endmodule
