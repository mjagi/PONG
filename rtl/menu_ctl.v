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
  input wire difficulty,
  
  output wire vsync_out,
  output wire hsync_out,
  output wire [11:0] rgb_out
  );

  wire [10:0] hcount_out_if, vcount_out_if, hcount_out_start, vcount_out_start,hcount_out_credits, vcount_out_credits;
  wire vsync_out_if, hsync_out_if, hsync_out_start, vsync_out_start, vsync_out_credits, hsync_out_credits;
  wire hblnk_out_if, vblnk_out_if,hblnk_out_start, vblnk_out_start,hblnk_out_credits, vblnk_out_credits;
  wire [11:0] rgb_out_if, rgb_out_start,rgb_out_credits, rgb_im, addr_im;
  wire rst_out;
  wire [7:0] char_line_pixel_start, xy_char_start,char_line_pixel_credits, xy_char_credits;
  wire [3:0] char_line_start,char_line_credits;
  wire [6:0] char_code_start,char_code_credits;

  
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
  
//---------- Start game  
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
	.clk(clk),
	.addr({char_code_start [6:0], char_line_start [3:0]}),
	.char_line_pixels(char_line_pixel_start)
  );

//---------- credits
  draw_rect_char 
  #(
        .RECT_Y(672)
    )
  draw_char_credits(
    .vcount_in(vcount_out_start),
    .vsync_in(vsync_out_start),
    .vblnk_in(vblnk_out_start),
    .hcount_in(hcount_out_start),
    .hsync_in(hsync_out_start),
    .hblnk_in(hblnk_out_start),
  	.rgb_in(rgb_out_start),
    .pclk(clk),
  	.rst(rst),
  	.char_pixels(char_line_pixel_credits),
  	
  	.vcount_out(vcount_out_credits),
    .vsync_out(vsync_out_credits),
    .vblnk_out(vblnk_out_credits),
    .hcount_out(hcount_out_credits),
    .hsync_out(hsync_out_credits),
    .hblnk_out(hblnk_out_credits),
  	.rgb_out(rgb_out_credits),
  	.char_xy(xy_char_credits),
  	.char_line(char_line_credits)
  );

  char_rom_16x1_credits char_rom_credits(
	.char_xy(xy_char_credits),
	.char_code(char_code_credits)	
  );

  font_rom font_rom_credits(
	.clk(clk),
	.addr({char_code_credits [6:0], char_line_credits [3:0]}),
	.char_line_pixels(char_line_pixel_credits)
  );
//--------
  control My_control (
	.pclk(clk),
	.rst(rst),
	.xpos(xpos),
	.ypos(ypos),
	.hcount_in(hcount_out_credits),
	.vcount_in(vcount_out_credits),
	.vblnk_in(vblnk_out_credits),
	.hblnk_in(hblnk_out_credits),
	.rgb_in(rgb_out_credits),
	.vsync_in(vsync_out_credits),
	.hsync_in(hsync_out_credits),
	
	.hs_out(hsync_out),
	.vs_out(vsync_out),
	.rgb_out(rgb_out)
 );
/* 
  always @(posedge clk) begin
    if (rst) begin
        hsync_out <= 0;
        vsync_out <= 0;    
        rgb_out <= 0;
    end
    else begin    
        hsync_out <= hsync_ctl;
        vsync_out <= vsync_ctl;    
        rgb_out <= rgb_ctl;
    end
end
*/
endmodule
