// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
//  inout wire ps2_clk,
//  inout wire ps2_data,
  input wire clk,
  input wire rst,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror
  );

  // Converts 100 MHz clk into 65 MHz pclk.
  // This uses a vendor specific primitive
  // called MMCME2, for frequency synthesis.

  //wire clk_in;
  wire locked;
  wire pclk, mclk;
  
  clk_wiz_0 my_clk_wiz(
    .clk(clk),
    .reset(rst),
    .locked(locked),
    .clk65Mhz(pclk),
    .clk100MHz(mclk)
  );

  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.
/*
  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );
*/
assign pclk_mirror = pclk;
  // Instantiate the vga_timing module, which is
  // the module you are designing for this lab.

  wire [10:0] vcount, hcount, hcount_out_bg, vcount_out_bg, hcount_out_rt, vcount_out_rt, hcount_out_ch, vcount_out_ch;
  wire vsync, hsync, vsync_out_bg, hsync_out_bg, hsync_out_rt, vsync_out_rt, hsync_out_ch, vsync_out_ch;
  wire vblnk, hblnk, hblnk_out_bg, vblnk_out_bg, hblnk_out_rt, vblnk_out_rt, hblnk_out_ch, vblnk_out_ch;
  wire [11:0] rgb_out_bg, rgb_out_rt,rgb_out_ch ,rgb_im, xpos_wire, ypos_wire, xpos_wire2, ypos_wire2,ypos_wire_d, xpos_wire_d, addr_im;
  wire rst_out, mouse_left;
  wire [7:0] char_line_pixel, xy_char;
  wire [3:0] char_line;
  wire [6:0] char_code;
  /*
  rst_d my_rst_d(
	.rst_out(rst_out),
	.locked(locked),
	.clk(pclk)
  );
*/
  vga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(pclk),
	  .rst(rst)
  );
  
  draw_background my_background (
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .pclk(pclk),
	  .rst(rst),
	
	  .vcount_out(vcount_out_bg),
    .vsync_out(vs),
    .vblnk_out(vblnk_out_bg),
    .hcount_out(hcount_out_bg),
    .hsync_out(hs),
    .hblnk_out(hblnk_out_bg),
	  .rgb_out({r,g,b})
  );
 /* 
  draw_rect my_rect(
    .vcount_in(vcount_out_ch),
    .vsync_in(vsync_out_ch),
    .vblnk_in(vblnk_out_ch),
    .hcount_in(hcount_out_ch),
    .hsync_in(hsync_out_ch),
    .hblnk_in(hblnk_out_ch),
    .pclk(pclk),
	.rst(rst_out),
	.rgb_in(rgb_out_ch),
	.x_pos(xpos_wire2),
	.y_pos(ypos_wire2),
	.rgb_pixel(rgb_im),
	
	.vcount_out(vcount_out_rt),
    .vsync_out(vsync_out_rt),
    .vblnk_out(vblnk_out_rt),
    .hcount_out(hcount_out_rt),
    .hsync_out(hsync_out_rt),
    .hblnk_out(hblnk_out_rt),
	.rgb_out(rgb_out_rt),
	.pixel_addr(addr_im)
  );
  
  draw_rect_ctl my_draw_ctl(
    .clk(pclk),
    .rst(rst_out),
    .mouse_left(mouse_left),
    .mouse_xpos(xpos_wire_d),
    .mouse_ypos(ypos_wire_d),
    
    .xpos(xpos_wire2),
    .ypos(ypos_wire2)
  );
  
  MouseCtl My_MouseCtl(
	.clk(mclk),
	.rst(rst_out),
	.value(12'b0),
	.setx(1'b0),
	.sety(1'b0),
	.setmax_x(1'b0),
	.setmax_y(1'b0),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.xpos(xpos_wire),
	.ypos(ypos_wire),
	.zpos(),
	.left(mouse_left),
	.middle(),
	.right(),
	.new_event()
  );
  
  Mouse_delay My_mouse_deley(
	.clk(pclk),
	.rst(rst_out),
	.xpos_in(xpos_wire),
	.ypos_in(ypos_wire),
	.xpos_out(xpos_wire_d),
	.ypos_out(ypos_wire_d)
  );
  
  image_rom My_image(
	.clk(pclk),
	.address(addr_im),
	.rgb(rgb_im)
);

font_rom myfont_rom(
	.clk(pclk),
	.addr({char_code [6:0], char_line [3:0]}),
	.char_line_pixels(char_line_pixel)
);

draw_rect_char mydraw_char(
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
	.rgb_in(rgb_out_bg),
    .pclk(pclk),
	.rst(rst_out),
	.char_pixels(char_line_pixel),
	
	.vcount_out(vcount_out_ch),
    .vsync_out(vsync_out_ch),
    .vblnk_out(vblnk_out_ch),
    .hcount_out(hcount_out_ch),
    .hsync_out(hsync_out_ch),
    .hblnk_out(hblnk_out_ch),
	.rgb_out(rgb_out_ch),
	.char_xy(xy_char),
	.char_line(char_line)
);

char_rom_16x16 mychar_rom(
	.char_xy(xy_char),
	.char_code(char_code)	
);

 
  control My_control (
	.pclk(pclk),
	.rst(rst_out),
	.xpos(xpos_wire_d),
	.ypos(ypos_wire_d),
	.hcount_in(hcount_out_rt),
	.vcount_in(vcount_out_rt),
	.vblnk_in(vblnk_out_rt),
	.hblnk_in(hblnk_out_rt),
	.rgb_in(rgb_out_rt),
	.vsync_in(vsync_out_rt),
	.hsync_in(hsync_out_rt),
	.hs_out(hs),
	.vs_out(vs),
	.r(r),
	.g(g),
	.b(b)
 );
*/
endmodule
