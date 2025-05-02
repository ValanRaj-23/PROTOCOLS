module spi_slave
  (	input 	rst,
    input 	ss_s,
  	input 	sclk_s,
   	input 	miso_s,
   	output 	mosi_s,
   
   	input sw,
   	output [3:0] led
  );
  
  reg [7:0] byte_mem	= 0;

  reg [1:0] present, next;
  
  parameter [1:0] 	IDLE	= 1,
  					RECEIVE	= 2;
  
  	always@(posedge sclk_s)
    begin
      if(!rst)
        	present <= IDLE;
       else
      		present <= next;
    end
  
  always@(posedge sclk_s)
    begin
      case(present)
        
        RECEIVE : begin
          		if(!ss_s)
                  begin
                    byte_mem <= {byte_mem[6:0], miso_s};
                  end
        end
      endcase
    end
	
  
  always@(*)
    begin
      case(present)
        
        IDLE 	: next = (!ss_s) ? RECEIVE : IDLE;
        RECEIVE	: next = (!ss_s) ? RECEIVE : IDLE;
         
	endcase
    end  
  
  assign led = (sw == 1) ? byte_mem[7:4] : byte_mem[3:0];

endmodule
