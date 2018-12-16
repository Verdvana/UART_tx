module tx(
				input              clk,                //时钟信号
				input              rst_n,              //复位

				input      [7:0]   datain,             //需要发送的数据	
				input              rdy,                //数据准备好信号
				output reg         busy,               //线路状态指示，高为线路忙，低为线路空闲
				output reg         tx                  //发送数据信号

);



//----------------------------------------------------------------
//检测发送命令rdy的上升沿,有上升沿则rdyrise为1


reg rdybuf, rdyrise;

always @(posedge clk)
begin
   rdybuf <= rdy;
   rdyrise <= (~rdybuf) & rdy;  
end
//-----------------------------------------------------------------


//------------------------------------------------------------------
//启动串口发送程序
//------------------------------------------------------------------
reg [3:0] cnt; 
reg send;
always @(posedge clk)
begin
  if (rdyrise &&  (~busy))  //当发送命令有效且线路为空闲时，启动新的数据发送进程
  begin
     send <= 1'b1;
  end
  else if(cnt == 4'd11)      //一帧数据发送结束
  begin
     send <= 1'b0;
  end
end


//-------------------------------------------------------------------
//串口发送程序, 16个时钟发送一个bit
//------------------------------------------------------------------
reg       check;    //偶校验

parameter value = 1'b0;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
         tx    <= 1'b0;
         busy  <= 1'b0;
			cnt   <= 4'd0;
			check <= 1'b0;
  end		
  else if(send == 1'b1)  begin
    case(cnt)                 //产生起始位
    4'd0: begin
         tx   <= 1'b0;
         busy <= 1'b1;
         cnt  <= cnt + 4'd1;
			end
    4'd1: begin
         tx    <= datain[0];    //发送数据0位
         check <= datain[0]^value;
         busy  <= 1'b1;
         cnt   <= cnt + 4'd1;
			end
    4'd2: begin
         tx    <= datain[1];    //发送数据1位
         check <= datain[1]^check;
         busy  <= 1'b1;
         cnt   <= cnt + 4'd1;
			end
    4'd3: begin
         tx <= datain[2];    //发送数据2位
         check <= datain[2]^check;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd4: begin
         tx <= datain[3];    //发送数据3位
         check <= datain[3]^check;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd5: begin 
         tx <= datain[4];    //发送数据4位
         check <= datain[4]^check;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd6: begin
         tx <= datain[5];    //发送数据5位
         check <= datain[5]^check;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd7: begin
         tx <= datain[6];    //发送数据6位
         check <= datain[6]^check;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd8: begin 
         tx <= datain[7];    //发送数据7位
         check <= datain[7]^check;
         busy <= 1'b1;
         cnt <= cnt +4 'd1;
			end
    4'd9: begin
         tx <= check;      //发送奇偶校验位
         check <= datain[0]^value;
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd10: begin
         tx <= 1'b1;         //发送停止位            
         busy <= 1'b1;
         cnt <= cnt + 4'd1;
			end
    4'd11: begin
         tx <= 1'b1;             
         busy <= 1'b0;       //一帧数据发送结束
         cnt <= cnt + 4'd1;
			end
    default: begin
         cnt <= cnt + 4'd1;
			end
   endcase
  end
  else  
		begin
			tx <= 1'b1;
			cnt <= 4'd0;
			busy <= 1'b0;
		end
end


endmodule

