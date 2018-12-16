module div(
				input        clk_16m,
				input        rst_n,
				input [1:0]  bps_set,  
				
				output  reg  clk_bps
);

//-----------------------------------
//根据波特率设置位产生对应时钟

/*********************************
分频计算：
       
		 16000000/9600 =1666
		 16000000/19200=834
		 16000000/38400=416
**********************************/	
reg [10:0]  cnt;

always@(posedge clk_16m or negedge rst_n)
begin
	if(!rst_n)
		begin
			cnt <= 0;
			clk_bps <= 0;
		end
	
	else
		case(bps_set)
			2'b00:
					begin
						if(cnt==11'd833)
							begin
								clk_bps <= 1;
								cnt <= cnt+1;
							end
							
						else if (cnt==11'd1666)
							begin
								clk_bps <= 0;
								cnt <= 0;
							end
							
						else 
							cnt <= cnt+1;
					end
					
			2'b01:
					begin
						if(cnt==11'd417)
							begin
								clk_bps <= 1;
								cnt <= cnt+1;
							end
							
						else if (cnt==11'd834)
							begin
								clk_bps <= 0;
								cnt <= 0;
							end
							
						else 
							cnt <= cnt+1;
					end
			
			2'b10:
					begin
						if(cnt==11'd208)
							begin
								clk_bps <= 1;
								cnt <= cnt+1;
							end
							
						else if (cnt==11'd416)
							begin
								clk_bps <= 0;
								cnt <= 0;
							end
							
						else 
							cnt <= cnt+1;					
					end
		endcase
end
//-----------------------------------

endmodule

