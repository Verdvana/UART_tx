`timescale 1ns/1ps

module uart_tx(
					input              clk,               
					input              rst_n,             

					input      [7:0]   datain,          
					input      [1:0]   bps_set,	
					input              rdy,              
					output wire        busy,          
					output wire        tx              


);

wire clk_wire;


div u0(
			.clk_16m(clk),
			.rst_n(rst_n),
			.bps_set(bps_set),
			
			.clk_bps(clk_wire)
);


tx u1(
			.clk(clk_wire),              
			.rst_n(rst_n),             

			.datain(datain),        
			.rdy(rdy),              
			.busy(busy),             
			.tx(tx)                  
);


endmodule
