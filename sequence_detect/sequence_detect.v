module top( 
    input rst,
    input clk,
    input signal,  // signal channel

    output [1:0] outlet,
    output led
);

localparam entrance = 8'h00;
localparam t1 = 8'h01;
localparam t10 = 8'h02;
localparam t11 = 8'h03;
localparam t101 = 8'h04;
localparam t110 = 8'h05;
localparam t1more = 8'h06;
localparam t1011 = 8'h07;

localparam s1 = 8'hfc;  // 101
localparam s2 = 8'hfd;  // 1011
localparam s3 = 8'hfe;  // 111 or more
localparam s4 = 8'hff;  // other

reg [7:0] temp_state;
reg [7:0] cur_state;
reg [1:0] dr;

assign outlet = dr;
assign led_indicate = signal;
assign led = signal;

always @ (posedge clk or negedge rst) begin
    if (!rst) temp_state <= entrance;
    else
        case (temp_state)
            entrance: 
                if (signal == 1) temp_state <= t1;  // 1
                else temp_state <= temp_state;  // 0
            t1:
                if (signal == 1) temp_state <= t11;  // 11
                else temp_state <= t10;  // 10
            t10:
                if (signal == 1) temp_state <= t101;  // 101
                else temp_state <= entrance;  // 100
            t11:
                if (signal == 1) temp_state <= t1more;  // 111 or more
                else temp_state <= entrance;
            t101:
                if (signal == 1) temp_state <= t1011;  // 1011
                else temp_state <= t10;
            t1more:
                if (signal == 1) temp_state <= temp_state;  // 1111...
                else temp_state <= t10;  // 1111110
            t1011:
                if (signal == 1) temp_state <= t1more;  // 10111
                else temp_state <= t10;  // 10110
            default: temp_state <= entrance;
        endcase
end

always @ * begin
    case (temp_state)
        t101:  cur_state <= s1;
        t1011: cur_state <= s2;
        t1more: cur_state <= s3;
        default: cur_state <= s4;
    endcase
end

always @ * begin
    case (cur_state)
        s1: dr <= 2'b00;
        s2: dr <= 2'b01;
        s3: dr <= 2'b10;
        s4: dr <= 2'b11;
        default: dr <= 2'b00;
    endcase
end

endmodule
