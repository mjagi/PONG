// File: game_ctl.v

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module game_ctl (
  input wire clk,
  input wire rst,
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] ypos,
  input wire [11:0] rgb_in,
  
  output reg vsync_out,
  output reg hsync_out,
  output reg [11:0] rgb_out
  );

  wire [10:0] hcount_out_bg, vcount_out_bg, hcount_out_rt, vcount_out_rt, hcount_out_ch, vcount_out_ch;
  wire vsync_out_bg, hsync_out_bg, hsync_out_rt, vsync_out_rt, hsync_out_ch, vsync_out_ch;
  wire hblnk_out_bg, vblnk_out_bg, hblnk_out_rt, vblnk_out_rt, hblnk_out_ch, vblnk_out_ch;
  wire [11:0] rgb_out_bg, rgb_out_rt,rgb_out_ch ,rgb_im, xpos_ctl, ypos_ctl, addr_im;
  wire rst_out, mouse_left, mouse_left_d;
  wire [7:0] char_line_pixel, xy_char;
  wire [3:0] char_line;
  wire [6:0] char_code;

  
  draw_background my_background (
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .pclk(clk),
	  .rst(rst_out),
	
	  .vcount_out(vcount_out_bg),
    .vsync_out(vsync_out_bg),
    .vblnk_out(vblnk_out_bg),
    .hcount_out(hcount_out_bg),
    .hsync_out(hsync_out_bg),
    .hblnk_out(hblnk_out_bg),
	  .rgb_out(rgb_out_bg)
  );
  
  draw_rect my_rect(
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
    .pclk(clk),
	.rst(rst_out),
	.rgb_in(rgb_out_bg),
	.y_pos(ypos),
	
	.vcount_out(vcount_out_rt),
    .vsync_out(vsync_out_rt),
    .vblnk_out(vblnk_out_rt),
    .hcount_out(hcount_out_rt),
    .hsync_out(hsync_out_rt),
    .hblnk_out(hblnk_out_rt),
	.rgb_out(rgb_out_rt)
  );
  
  draw_ball_ctl my_ball_ctl(
    .pclk(clk),
    .rst(rst_out),
    .mouse_left(mouse_left),
    .mouse_ypos(ypos),
    
    .xpos(xpos_ctl),
    .ypos(ypos_ctl)
  );
  
  vga_draw_ball my_draw_ball(
      .vcount_in(vcount_out_rt),
      .vsync_in(vsync_out_rt),
      .vblnk_in(vblnk_out_rt),
      .hcount_in(hcount_out_rt),
      .hsync_in(hsync_out_rt),
      .hblnk_in(hblnk_out_rt),
      .rgb_in(rgb_out_rt),
      .pclk(clk),
      .rst(rst_out),
      .xpos(xpos_ctl),
      .ypos(xpos_ctl),
      .rgb_pixel(rgb_im),
      
      .vcount_out(vcount_out_ch),
      .vsync_out(vsync_out),
      .vblnk_out(vblnk_out_ch),
      .hcount_out(hcount_out_ch),
      .hsync_out(hsync_out),
      .hblnk_out(hblnk_out_ch),
      .rgb_out(rgb_out),
      .pixel_addr(addr_im)
  );
  
  image_rom My_image(
	.clk(clk),
	.address(addr_im),
	.rgb(rgb_im)
);
/*
font_rom myfont_rom(
	.clk(pclk),
	.addr({char_code [6:0], char_line [3:0]}),
	.char_line_pixels(char_line_pixel)
);

char_rom_16x16 mychar_rom(
	.char_xy(xy_char),
	.char_code(char_code)	
);

*/
endmodule
