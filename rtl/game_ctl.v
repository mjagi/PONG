//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   game_ctl
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-10
 Coding style: safe, with FPGA sync reset
 Description:  structural module for game modules
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

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
  input wire [11:0] ypos_sec,
  input wire mouse_left,
  input wire difficulty,
  input wire [11:0] color1,
  input wire [11:0] color2,
  input wire button,
  
  output wire vsync_out,
  output wire hsync_out,
  output wire [6:0] sseg_ca,
  output wire [3:0] sseg_an,
  output wire [11:0] rgb_out
  );

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------
  wire [10:0] hcount_out_bg, vcount_out_bg, hcount_out_rt, vcount_out_rt, hcount_out_ball, vcount_out_ball;
  wire vsync_out_bg, hsync_out_bg, hsync_out_rt, vsync_out_rt, hsync_out_ball, vsync_out_ball;
  wire hblnk_out_bg, vblnk_out_bg, hblnk_out_rt, vblnk_out_rt, hblnk_out_ball, vblnk_out_ball;
  wire [11:0] rgb_out_bg, rgb_out_rt, rgb_out_ball,rgb_im, xpos_ctl, ypos_ctl;
  wire [7:0] char_line_pixel, xy_char, addr_im;
  wire [3:0] char_line;
  wire [6:0] char_code;
  wire [1:0] score_p1, score_p2;

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
  
  draw_rect my_rect(
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
    .pclk(clk),
	.rst(rst),
	.rgb_in(rgb_out_bg),
	.y_pos(ypos),
	.y_pos_sec(ypos_sec),
	.color2(color2),
	
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
    .rst(rst),
    .mouse_left(mouse_left),
    .mouse_ypos(ypos),
    .difficulty(difficulty),
	.button(button),
	.mouse_ypos_sec(ypos_sec),
    
    .xpos(xpos_ctl),
    .ypos(ypos_ctl),
	.score_p1(score_p1),
	.score_p2(score_p2)
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
      .rst(rst),
      .xpos(xpos_ctl),
      .ypos(ypos_ctl),
      .rgb_pixel(rgb_im),
      
      .vcount_out(vcount_out_ball),
      .vsync_out(vsync_out_ball),
      .vblnk_out(vblnk_out_ball),
      .hcount_out(hcount_out_ball),
      .hsync_out(hsync_out_ball),
      .hblnk_out(hblnk_out_ball),
      .rgb_out(rgb_out_ball),
      .pixel_addr(addr_im)
  );
  
  image_rom My_image(
	.clk(clk),
	.address(addr_im),
    .color1(color1),
	.color2(color2),
	.rgb(rgb_im)
);

	score_res my_score_res(
		.vcount_in(vcount_out_ball),
		.hcount_in(hcount_out_ball),
		.vsync_in(vsync_out_ball),
		.vblnk_in(vblnk_out_ball),
		.hsync_in(hsync_out_ball),
		.hblnk_in(hblnk_out_ball),
		.pclk(clk),
		.rst(rst),
		.color1(color1),
		.color2(color2),
		.score_p1(score_p1),
		.score_p2(score_p2),
		.rgb_in(rgb_out_ball),
  
		.vsync_out(vsync_out),
		.hsync_out(hsync_out),
		.rgb_out(rgb_out)	
	);
	
	point_display my_point_display(
		.clk(clk),
		.rst(rst),
		.score_p1(score_p1),
	
		.sseg_ca(sseg_ca),   // segments (active LOW)
		.sseg_an(sseg_an)    // anode enable (active LOW)
	);	

endmodule
