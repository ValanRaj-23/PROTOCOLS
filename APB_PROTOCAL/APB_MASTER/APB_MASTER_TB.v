module apb_master_tb();

	//Protocol signals                       		
        reg            	pclk        	;           	
        reg            	preset_n    	;           	
        wire           	pselx       	;           	
        wire           	penable     	;           	
        wire  [3:0]    	paddr       	;           	
        wire           	pwrite      	;           	
        wire  [15:0]   	pwdata      	;           	
                                                
	//External signal from slave		      	
	      reg            	pready     	  ;		
        reg   [15:0]   	prdata      	;            	
                                                            
        //External signals from test                    	
                                                            
        reg     	read_write     	;            	
        reg     	transfer      	;        	
	      reg   [3:0] 	apb_read_addr   ;		
	      reg   [3:0] 	apb_write_addr	;	 	
	      reg   [15:0]	apb_write_data	;		
  	    wire  [15:0]	apb_read_data	;		
             	

apb_master uut(

		.pclk        	(pclk        	),	
                .preset_n    	(preset_n    	),	
                .pselx       	(pselx       	),	
                .penable     	(penable     	),	
                .paddr       	(paddr       	),	
                .pwrite      	(pwrite      	),	
                .pwdata      	(pwdata      	),	                                      
                .pready     	(pready      	),   
                .prdata      	(prdata      	),

                .read_write	(read_write  	),   
                .transfer      	(transfer    	),  	
                .apb_read_addr  (apb_read_addr  ),
                .apb_write_addr	(apb_write_addr	),
                .apb_write_data	(apb_write_data	),
                .apb_read_data	(apb_read_data	)

		);



  initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
      pclk = 0;
      forever #5 pclk = ~pclk;
  end


  initial begin
	  preset_n = 0;
	  #20;

	preset_n  = 1 ;
	read_write	= 1;
	apb_write_addr 	= 4'hA;
	apb_write_data 	= 16'hABAB;
	transfer	= 0;
	pready		= 0;
	
	#20;

	transfer 	= 1;

	#200;
	pready 		= 1;
	apb_read_addr	= 16'h4;
	prdata		= 16'h66;
	
	#10;
	pready		= 0;
	
	#10;
	read_write	= 0;
	

	#60;
	pready 		= 1;
	
end


  initial begin
    #1000;
    $finish;
  end


endmodule

