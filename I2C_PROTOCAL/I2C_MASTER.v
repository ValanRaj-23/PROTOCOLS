module master(
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

bit 	scl_en = 0;
bit 	sda_en = 1;
bit 	[7:0] data_mem;
bit		[8:0] addr_mem;
bit		[3:0] clk_counter	= 0;
bit		[3:0] send_counter	= 0;	
bit		sda_in_m;
bit		[3:0]present, next;

parameter [3:0] IDLE 	= 0,
				START	= 1,
				ADDR	= 2,
				R_ACK	= 3,
  				DATA	= 4,
  				STOP	= 5;
  						

  
assign	scl_out	= scl_en ? i2c_clk : 1;
assign 	sda_out	= sda_en ? sda_in_m  : 1'bz;

	
  
  always@(posedge sys_clk) // seperate clk for i2c
 begin 
   if(clk_counter == 4)
	begin
		i2c_clk <= ~i2c_clk;
		clk_counter <= 0;
	end
	else
		clk_counter <= clk_counter + 1;

end

  
  always@(posedge i2c_clk)
begin
	if(!rst)
		present <= IDLE;
	else
		present	<= next;
end

  
  always@(*)	// output line control
begin
  
	case(present)

		IDLE	:begin
				scl_en 	= 0;	
                sda_en	= 1;
          		sda_in_m = 1;
			end

		START	:begin
				scl_en	= 0;
				sda_en	= 1;
          		sda_in_m = 0;
			end
	
		ADDR	:begin
				scl_en	= 1;
				sda_en	= 1;
			end
		
		R_ACK	:begin
				scl_en	= 1;
				sda_en	= 0;
          		sda_in_m = 0;
			end	
      
      	DATA	:begin
          		scl_en	= 1;
          		sda_en 	= 1;
        		end
      
      	STOP	:begin
          		scl_en	= 0;
          		sda_en	= 1;
          		sda_in_m = 1;

        	end
	endcase
end

  always@(posedge i2c_clk) // data storage
    begin
  
	case(present)
      	
//       	IDLE	:sda_in_m			<= 1;
          		

		START	:begin
// 				sda_in_m			<= 0;
				data_mem 		<= data;
          		addr_mem 		<= {addr,wr_bit};
				send_counter	<= 8;
				end

		ADDR	:begin
          		if(send_counter > 9)
					send_counter 	<= 0;
				else
				begin
					sda_in_m		<= addr_mem[send_counter];
					send_counter 	<= send_counter - 1;
				end
				end

		R_ACK	:	send_counter <= 7;
				
        DATA	:begin
          		if(send_counter > 8)
                  send_counter		<= 0;
          		else
                  begin
                    sda_in_m		<= data_mem[send_counter];
                    send_counter	<= send_counter - 1;
                  end
        		end
      
//       	STOP	: sda_in_m		<= 0;
          
	endcase
end
  
always@(*)
	begin
	case(present)

	  IDLE 	: 	next 	= run ? START : IDLE;
	  START	: 	next	= ADDR;
      	ADDR	: 	next 	= (send_counter > 9)	? R_ACK : ADDR;    
      R_ACK	:	next	= (sda_out == 0)		? DATA	: IDLE;
      DATA	:	next	= (send_counter > 8)	? STOP	: DATA;
      STOP	: 	next 	= IDLE;
      
	endcase
	end
 
endmodule

