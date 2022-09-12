//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   rst_d
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-08-01
 Coding style: safe with FPGA sync reset
 Description:	module for delaying reset for all modules except clock
 */
//////////////////////////////////////////////////////////////////////////////

module rst_d (
  output reg rst_out,
  input wire locked,
  input wire clk
  );

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
reg [2:0] cycles, cycles_nxt;
reg rst_d_nxt, rst_d;

//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------	
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
