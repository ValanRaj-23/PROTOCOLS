module master(
	input 		clk,
	input 		rst,
	input		run,
	input		[7:0]addr,
	input 		[7:0]data,
	input		wr_en,
	input		ack,
	output		scl_m,
	output		sda_m
	);

	reg [2:0]	present, next;
	reg [3:0]	c_clk; 						//clk count
  	reg [3:0]	counter; 					//clk count
	reg 		scl_en;
	reg 		sda_en;
  	reg [7:0]	data_m;
  	reg [7:0]	addr_m;
	reg			clk_m;

		

	parameter [2:0] IDLE 	= 0,
					START 	= 1,
	       			ADDR	= 2,
					R_ACK	= 3,
					WRITE	= 4,
					READ	= 5,
					STOP	= 6;

	
	assign scl_m	= scl_en ? clk_m : 1;
	assign sda_m	= sda_en ? din_m : 1;



	always@(posedge clk)
	begin
		if(c_clk == 4)
		begin
			clk_m	<=	~clk_m;
			c_clk	<=	0;
		end
		else
			c_clk	<= 	c_clk + 1;
	end



	always@(posedge clk)
	begin
		if(!rst)
		begin
			clk_m	<= 0;
          	c_clk	<= 0;
			present <= IDLE;
		end
		else
			present <= next;
	end
        

  	always@(posedge clk_m)
	begin
		case(present)
				
          	IDLE	:if(run == 1)
                  			begin
                              
								scl_en 	<=	0;
								sda_en	<=	0;
                  				next	<= IDLE;
                              
                            end
          				else
                          	next	<= START;

			START	:
							begin
                            
								scl_en	<=	0;
								sda_en	<=	1;
                            	  
                      			d_in 	<= 0;
                  				data_m	<= data;
                  				addr_m	<= addr;
                              	counter	<= 7;

                              	next	<=	ADDR;

							end
 

         	ADDR	:	if(counter < 8)
                  			begin
                         
								scl_en 	<= 	1;
                              	sda_en	<=	addr_m[counter];
                              	next	<=	ADDR;
                              	
                              	counter	<=	counter - 1;
                              
							end
          					else
                            begin
                               	next	<= 	R_ACK;
                           		counter <=	0;  	
                            end
          
                              	
                              	
                              	
          
          	R_ACK	:	if(ack == 0)
          						next	<=	WRITE;
          					else
                              begin
            	                next	<=	IDLE;
          						counter	<= 	7;
                              end
          
          	WRITE	:	if(counter < 8)
            			  begin
                              	
                              sda_en 	<=  data_m[counter]
                              counter	<=	counter - 1;
                              next		<=	WRITE;
                            end
          				else
                          begin
                           		counter	<= 0;
                            	next	<=	W_ACK;
                          end
          
         	W_ACK	:	begin
                              next		<= 	IDLE;
                        end
           			
          		
		endcase
	end


endmodule

