module uart_rx(
    input clk, // system clock
    input reset,
    input d_in,
    input bclk_rx,
    output reg error,
    output reg [7:0] rx
);

parameter [1:0] IDLE = 0, 
                RECEIVE = 1,
                PARITY = 2;

reg [1:0] ps, ns;
reg [9:0] temp;
reg p_bit;
integer count;

always @(posedge clk or negedge reset) begin
    if (!reset)
        ps <= IDLE;
    else
        ps <= ns;
end

always @(*) begin
    case (ps)
        IDLE: begin
            error = 1'b0;
            if (!d_in) begin  // Detect start bit
                count = 9;
                ns = RECEIVE;
            end else
                ns = IDLE;
        end 

        RECEIVE: begin
            if (count < 0) 
                ns = PARITY;
            else
                ns = RECEIVE;
        end

        PARITY: begin
            p_bit = ^temp[9:1];  // Compute parity
            if (p_bit == temp[1]) begin
                rx = temp[9:2];  // Extract data bits
                ns = IDLE;
            end else begin
                error = 1'b1;
                ns = IDLE;
            end
        end 
    endcase
end

// Capture data bits on bclk_rx
always @(posedge bclk_rx or negedge reset) begin
    if (!reset)
        count <= 9;
    else if (ps == RECEIVE) begin
        temp[count] <= d_in;
        count <= count - 1;
    end
end

endmodule
