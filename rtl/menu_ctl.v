// File: menu_ctl.v

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module menu_ctl (
  input wire clk,
  input wire rst,
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] ypos,
  input wire [11:0] xpos,
  input wire [11:0] rgb_in,
  
  output reg vsync_out,
  output reg hsync_out,
  output reg [11:0] rgb_out
  );

  wire [10:0] hcount_out_if, vcount_out_if, hcount_out_rt, vcount_out_rt, hcount_out_start, vcount_out_start;
  wire vsync_out_if, hsync_out_if, hsync_out_rt, vsync_out_rt, hsync_out_start, vsync_out_start;
  wire hblnk_out_if, vblnk_out_if, hblnk_out_rt, vblnk_out_rt, hblnk_out_start, vblnk_out_start;
  wire [11:0] rgb_out_if, rgb_out_rt,rgb_out_start ,rgb_im, xpos_wire, ypos_wire, xpos_wire2, ypos_wire2,ypos_wire_d, xpos_wire_d, addr_im;
  wire rst_out, mouse_left, mouse_left_d;
  wire [7:0] char_line_pixel_start, xy_char_start;
  wire [3:0] char_line_start;
  wire [6:0] char_code_start;

  
  if_menu my_if_menu (
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .pclk(clk),
	.rst(rst),
	
	.vcount_out(vcount_out_if),
    .vsync_out(vsync_out_if),
    .vblnk_out(vblnk_out_if),
    .hcount_out(hcount_out_if),
    .hsync_out(hsync_out_if),
    .hblnk_out(hblnk_out_if),
	.rgb_out(rgb_out_if)
  );
  
  
  draw_rect_char draw_char_start(
    .vcount_in(vcount_out_if),
    .vsync_in(vsync_out_if),
    .vblnk_in(vblnk_out_if),
    .hcount_in(hcount_out_if),
    .hsync_in(hsync_out_if),
    .hblnk_in(hblnk_out_if),
  	.rgb_in(rgb_out_if),
    .pclk(clk),
  	.rst(rst),
  	.char_pixels(char_line_pixel_start),
  	
  	.vcount_out(vcount_out_start),
    .vsync_out(vsync_out_start),
    .vblnk_out(vblnk_out_start),
    .hcount_out(hcount_out_start),
    .hsync_out(hsync_out_start),
    .hblnk_out(hblnk_out_start),
  	.rgb_out(rgb_out_start),
  	.char_xy(xy_char_start),
  	.char_line(char_line_start)
  );

  char_rom_16x1_start char_rom_start(
	.char_xy(xy_char_start),
	.char_code(char_code_start)	
  );

  font_rom font_rom_start(
	.clk(pclk),
	.addr({char_code_start [6:0], char_line_start [3:0]}),
	.char_line_pixels(char_line_pixel_start)
  );


  control My_control (
	.pclk(clk),
	.rst(rst),
	.xpos(xpos),
	.ypos(ypos),
	.hcount_in(hcount_out_start),
	.vcount_in(vcount_out_start),
	.vblnk_in(vblnk_out_start),
	.hblnk_in(hblnk_out_start),
	.rgb_in(rgb_out_start),
	.vsync_in(vsync_out_start),
	.hsync_in(hsync_out_start),
	
	.hs_out(hsync_out),
	.vs_out(vsync_out),
	.rgb_out(rgb_out)
 );

endmodule
