//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   control
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-06
 Coding style: safe, with FPGA sync reset
 Description:   module that controls MouseDisplay.vhd module, responsible for drawing the coursor
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module control (
  input wire pclk,
  input wire rst,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  input wire [10:0] hcount_in,
  input wire [10:0] vcount_in,
  input wire vblnk_in,
  input wire hblnk_in,
  input wire [11:0] rgb_in,
  input wire hsync_in,
  input wire vsync_in,
  output reg hs_out,
  output reg vs_out,
  output reg [11:0] rgb_out
  );
//------------------------------------------------------------------------------
// local variables and wires
//------------------------------------------------------------------------------
reg vs_temp, hs_temp;
wire [3:0] r_nxt, g_nxt, b_nxt;

//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------	  
MouseDisplay My_MouseDisplay(
	.pixel_clk(pclk),
	.xpos(xpos),
	.ypos(ypos),
	.hcount({1'b0,hcount_in}),
	.vcount({1'b0,vcount_in}),
	.blank(hblnk_in || vblnk_in),
	.red_in(rgb_in[11:8]),
	.green_in(rgb_in[7:4]),
	.blue_in(rgb_in[3:0]),
	
	.enable_mouse_display_out(),
	.red_out(r_nxt),
	.green_out(g_nxt),
	.blue_out(b_nxt)
 );

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always @(posedge pclk) begin 
	hs_temp <= hsync_in;
	vs_temp <= vsync_in;
end

always @(posedge pclk) begin
	if (rst) begin
		hs_out <= 0;
		vs_out <= 0;
		rgb_out <= 0;
	end
	else begin
		hs_out <= hs_temp;
		vs_out <= vs_temp;
		rgb_out <= {r_nxt, g_nxt, b_nxt};
	end
end

endmodule
