module tb();
reg scl_out;
wire sda_out_t;

 
reg sda_en_t = 1;
reg sda_in_t;
reg [7:0]addr;
int i = 0;


always #5 scl_out = ~scl_out;

slave uut(
  	.scl_out(scl_out),
	.sda_out_s(sda_out_t)
	);

assign sda_out_t = sda_en_t ? sda_in_t : 1'bz;

	initial begin
      		scl_out = 1;
      		addr = 8'b1001_1000;
      		#15;
      
      for(i = 7; i >= 0; i--)
			begin
              @(posedge scl_out)
              		sda_in_t = addr[i];
              		#2;
            end	  
          
	end
  
  initial begin
    fork
    
      begin
   		 sda_in_t = 1;
   		 sda_en_t = 1;
   		 
   		 #5;
   		 @(posedge scl_out)
      		sda_in_t = 0;
      end
    
      begin
        #110;
        sda_en_t = 0;
        #10
        sda_en_t = 1;
      end
      
      begin
        #115;
        for(i = 7; i >= 0; i--)
			begin
              @(posedge scl_out)
              		sda_in_t = addr[i];
              		#2;
            end
      end
      
      begin
        #220;
        sda_in_t = 1;
        
      end
      
    join
  end

  
initial begin
  $monitor("scl_out  = %d sda_out_t_t = %0d", scl_out, sda_out_t);
		$dumpfile("dump.vcd");
		$dumpvars;
		#1000;
		$finish;
end

endmodule
