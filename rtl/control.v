// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

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
  output reg [3:0] r,	
  output reg [3:0] g,
  output reg [3:0] b
  );

reg vs_temp, hs_temp;
wire [3:0] r_nxt, g_nxt, b_nxt;

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

always @(posedge pclk) begin 
	hs_temp <= hsync_in;
	vs_temp <= vsync_in;
end

always @(posedge pclk) begin
	if (rst) begin
		hs_out <= 0;
		vs_out <= 0;
		r <= 0;
		g <= 0;
		b <= 0;
	end
	else begin
		hs_out <= hs_temp;
		vs_out <= vs_temp;
		r <= r_nxt;
		g <= g_nxt;
		b <= b_nxt;
	end
end

endmodule
