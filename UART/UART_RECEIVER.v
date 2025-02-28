module uart_rx(
    input clk,
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
            ns = IDLE;
        end 

        RECEIVE: begin
            if (count == 0) 
                ns = PARITY;
            else
                ns = RECEIVE;
        end

        PARITY: begin
            p_bit = ^temp[9:2];
            if (p_bit == 0) begin
                rx = temp[9:2];
                ns = IDLE;
            end else begin
                error = 1'b1;
                ns = IDLE;
            end
        end 
    endcase
end

always @(posedge bclk_rx or negedge reset) begin
    if (!reset) begin
        count <= 10;
        ps <= IDLE;
    end 
    else begin
        case (ps)
            IDLE: begin
                if (!d_in) begin
                    count <= 9;
                    ps <= RECEIVE;
                end
            end

            RECEIVE: begin
                temp[count] <= d_in;
                if (count == 0)
                    ps <= PARITY;
                else
                    count <= count - 1;
            end

            PARITY: begin
                ps <= IDLE;
            end
        endcase
    end
end

endmodule
