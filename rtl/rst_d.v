module rst_d (
  output reg rst_out,
  input wire locked,
  input wire clk
  );


reg [2:0] cycles, cycles_nxt;
reg rst_d_nxt, rst_d;

always@*
begin
	if(locked == 0) begin
		rst_d_nxt = 1;
		cycles_nxt = 0;
	end
	else if(cycles == 3'b111) begin
		rst_d_nxt = 0;
		cycles_nxt = 3'b111;
	end
	else begin
		cycles_nxt = cycles + 1;
		rst_d_nxt = 1;
	end 
end
	
always@(posedge clk or negedge locked) begin
	if(!locked) begin
		rst_d <= 0;
		cycles <= 0;
		end
	else begin
		cycles <= cycles_nxt;
		rst_d <= rst_d_nxt;
	end
	
end
	
always@(posedge clk) begin
		rst_out <= rst_d;	
end
		


endmodule
