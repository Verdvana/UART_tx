`timescale 1ns/1ps

module uart_tb;

    reg       clk;
    reg       rst_n;
    reg [7:0] datain;
    reg [1:0] bps_set;
    reg       rdy;

    wire      tx;
	 wire      busy;

uart_tx uart_tx(

    .clk(clk),
    .rst_n(rst_n),
    .bps_set(bps_set),
    .datain(datain),
    .rdy(rdy),
    .tx(tx),
	 .busy(busy)

);

initial

    begin
        clk=0;rst_n=0;rdy=0;bps_set=2'b00;datain=8'b00000000;   //起始条件
		  
		  /***************************
		  测试条件1：波特率：38400
					  数据： 1001 0011；
		  ****************************/
		  
        #10 rst_n = 1;    
        #10  bps_set=2'b10;
        #10  datain=8'b10010011;
		  #15000 rdy=1;
		  
		  /***************************
		  测试条件2：波特率：19200
					  数据： 1001 1111；
		  ****************************/
		  #500000 rdy=0;
		  #20 bps_set=2'b01;
		  #20 datain=8'b10011111;
		  #60000 rdy=1;
		  
		  /***************************
		  测试条件3：波特率：9600
					  数据： 0001 0101；
		  ****************************/
		  #1000000 rdy=0;
		  #20 bps_set=2'b00;
		  #20 datain=8'b00010101;
		  #150000 rdy=1;
       
        
        #1600000 $stop;

    end

	 
always #31.25 clk=~clk;   //16M时钟，1/16000000Hz=62.5s


endmodule
