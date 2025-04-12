module slave(
	input 	scl_out,
	inout	sda_out_s
	);

	bit [3:0]data_counter;
	bit	[3:0]addr_counter ;
	bit	[7:0]data_mem;
    bit	[7:0]addr_mem;
	bit	[3:0]present, next;
	bit	sda_en_s = 0;
	bit	sda_in_s = 0;

	parameter [3:0] IDLE	= 0,
					R_ADDR	= 1,
					S_ACK1	= 2,
					READ	= 3,
					WRITE	= 4,
					S_ACK2  = 5;

	assign	sda_out_s = (sda_en_s == 1) ? sda_in_s : 1'bz;

	always@(posedge scl_out)
	begin
		present <= next;
	end

  always@(posedge scl_out)
	begin
		case(present)

		IDLE	: begin
          			addr_counter <= 7;
          			data_counter <= 7;
        		end

		R_ADDR	: begin
          		if(addr_counter > 8)
					addr_counter <= 0;
				else
				begin
					addr_mem[addr_counter] <= sda_out_s;
					addr_counter <= addr_counter - 1;
				end
			end

		S_ACK1	: begin
        		end
		
		READ	: begin
          		if(data_counter > 8)
					data_counter <= 0;
				else
				begin
					data_mem[data_counter] <= sda_out_s;
					data_counter <= data_counter - 1;
				end
			end

		WRITE	: begin
          		if(data_counter > 8)
					data_counter <= 0;
				else
				begin
					sda_in_s	<= data_mem[data_counter];
					data_counter <= data_counter - 1;
				end
			end
		endcase
	end
					
				
	always@(*)
	begin
		case(present)
		
	
		IDLE	:begin
		       		if(sda_out_s)
					next = IDLE;
				else
					next = R_ADDR;
			end
				
		R_ADDR	: begin
				if(addr_counter > 8)
					next = S_ACK1;
				else
					next = R_ADDR;
			end

		S_ACK1	: begin
				if(addr_mem[0] == 0)
					next = READ;
				else
					next = WRITE;
			end
          
		READ	:begin
         		if(data_counter > 8)
					next = S_ACK2;
				else
					next = READ;
        		end
          
		WRITE	: begin
          		if(data_counter > 8)
					next = S_ACK2;
				else
					next = WRITE;
				end


		S_ACK2	: begin	
				next = IDLE;
				end

		endcase	
	end
  
  always@(*)
   begin
    if((present == S_ACK1) || (present == S_ACK2))
	begin
      sda_in_s = 0;	
      sda_en_s = 1;
    end
    else
    begin
      sda_in_s = 1;
      sda_en_s = 0;
    end
   end

endmodule
