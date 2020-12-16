`timescale 1ns/1ns

module sq_tb;

reg clk;
reg rst;
reg signal;

wire led;
wire [1:0] ab;

top U
(
    .rst(rst),
    .clk(clk),
    .signal(signal),  // signal channel

    .outlet(ab),
    .led(led)
);

initial begin
    clk = 0;
    rst = 1;
    #2 rst = 0;
    #2 rst = 1;
    signal = 1;
    #25 signal = 0;
    #25 signal = 1;
    #25 signal = 0;
    #25 signal = 1;
    #25 signal = 0;
    #25 signal = 1;
    #25 signal = 0;
    #25 signal = 1;
    #5 signal = 1;
    #3 signal = 0;
    #3000 $stop;
end

always #10 clk <= ~clk;

endmodule
