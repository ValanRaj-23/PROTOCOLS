module spi_slave_tb;
  reg rst;
  reg ss_s;
  reg sclk_s;
  reg miso_s;
  wire mosi_s;
  int i;
  reg [15:0] temp_mem ;
  
  
  always #5 sclk_s = !sclk_s;
  
  spi_slave uut(.rst(rst), 
    			.ss_s(ss_s),
                .sclk_s(sclk_s),
                .miso_s(miso_s),
                .mosi_s(mosi_s));
  
  initial begin
    temp_mem = 16'h77_77;
    sclk_s	= 0;
    rst = 0;
    #20;
    rst = 1;
    ss_s 	= 1;
    #34;   
   
    
    for(i = 15; i >= 0; i--)
      begin
        @(posedge sclk_s)
        miso_s = temp_mem[i];
        #2;
      end
  end
  
  initial begin
    #46
    	ss_s = 0;
    
    #100
    	ss_s = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000;
    $finish;
  end
        
  
endmodule
