module apb_master(  
    input               pclk,
    input               preset_n,
    output              pselx,
    output              penable,
    output      [3:0]   paddr,
    output              pwrite,
    output      [15:0]  pwdata,

    input               pready,
    input       [15:0]  prdata,

    input               read_write,
    input               transfer,
    input       [3:0]   apb_read_addr,
    input       [3:0]   apb_write_addr,
    input       [15:0]  apb_write_data,
    output	[15:0]  apb_read_data
);

    parameter 	IDLE 	= 2'b00,
	   	SETUP 	= 2'b01,
		ACCESS 	= 2'b10;
    reg [1:0] present, next;



    reg [15:0] 	reg_data;
    reg [3:0]  	reg_addr;
    reg       	reg_wr;



    always @(posedge pclk or negedge preset_n) begin
        if (!preset_n)
            present <= IDLE;
        else
            present <= next;
    end




    always @(*) begin
        case(present)
            IDLE:
                if (transfer)
                    next = SETUP;
                else
                    next = IDLE;

            SETUP:
                next = ACCESS;

            ACCESS:
                if (pready && transfer)
                    	next = SETUP;
                else if (pready && !transfer)
			next = IDLE;
                else if (!pready)
                    	next = ACCESS;
	    	else
			next = IDLE;

            default:
                next = IDLE;
        endcase
    end




    always @(*) begin
        if ((present == SETUP) || (present == ACCESS)) begin
            if (read_write)
	    begin
                reg_data = apb_write_data;
                reg_addr = apb_write_addr;
                reg_wr   = 1'b1;
            end
	    else
	    begin
                reg_data = prdata;
                reg_addr = apb_read_addr;
                reg_wr   = 1'b0;
            end
        end
       	else
       	begin
            reg_data = 16'd0;
            reg_addr = 4'd0;
            reg_wr   = 1'b0;
        end
    end






    	assign pselx   =   (present != IDLE);
    	assign penable =   (present == ACCESS);
    	assign pwrite  =  ((present == SETUP) || (present == ACCESS)) 	? reg_wr  	: 1'b0;
    	assign paddr   =  ((present == SETUP) || (present == ACCESS))	? reg_addr  	: 4'd0;
	
    	assign pwdata           = (((present == SETUP) || (present == ACCESS)) && read_write)	? reg_data 	: 16'd0;
	assign apb_read_data    = (((present == SETUP) || (present == ACCESS)) && !read_write)	? reg_data 	: 16'd0;


endmodule
