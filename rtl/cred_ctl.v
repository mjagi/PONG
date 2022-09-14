//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   cred_ctl
 Author:        Bartosz Białkowski, Mateusz Jagielski
 Version:       1.0
 Last modified: 2022-09-08
 Coding style: safe, with FPGA sync reset
 Description:  structural module for credits screen modules
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module cred_ctl (
  input wire clk,
  input wire rst,
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire mouse_left,
  input wire [11:0] color1,
  input wire [11:0] color2,
  
  output wire vsync_out,
  output wire hsync_out,
  output wire [11:0] rgb_out
  );

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------
 wire [10:0] hcount_out_bg, vcount_out_bg;
  wire vsync_out_bg, hsync_out_bg, hsync_out_cred, vsync_out_cred;
  wire hblnk_out_bg, vblnk_out_bg;
  wire [11:0] rgb_out_bg, xpos_ctl, ypos_ctl;
  wire [7:0] char_line_pixel_cred, xy_char_cred;
  wire [3:0] char_line_cred;
  wire [6:0] char_code_cred;
  
//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------ 
  draw_background my_background (
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .color1(color1),
    .color2(color2),
    .pclk(clk),
	.rst(rst),
	
	.vcount_out(vcount_out_bg),
    .vsync_out(vsync_out_bg),
    .vblnk_out(vblnk_out_bg),
    .hcount_out(hcount_out_bg),
    .hsync_out(hsync_out_bg),
    .hblnk_out(hblnk_out_bg),
	.rgb_out(rgb_out_bg)
  );
  
  draw_cred_ctl my_cred_ctl(
    .pclk(clk),
    .rst(rst),
    .mouse_left(mouse_left),
    
    .xpos(xpos_ctl),
    .ypos(ypos_ctl)
  );
  
  draw_cred_char My_draw_cred_char(
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
  	.rgb_in(rgb_out_bg),
  	.color1(color1),
  	.color2(color2),
  	.xpos(xpos_ctl),
  	.ypos(ypos_ctl),
    .pclk(clk),
  	.rst(rst),
  	
  	.char_pixels(char_line_pixel_cred),
    .vsync_out(vsync_out),
    .hsync_out(hsync_out),
  	.rgb_out(rgb_out),
  	.char_xy(xy_char_cred),
  	.char_line(char_line_cred)
  );

  char_rom_16x6_cred char_rom_cred(
	.char_xy(xy_char_cred),
	.char_code(char_code_cred)
  );

  font_rom font_rom_cred(
	.clk(clk),
	.addr({char_code_cred [6:0], char_line_cred [3:0]}),
	.char_line_pixels(char_line_pixel_cred)
  );

endmodule
