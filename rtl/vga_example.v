//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_pong
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-08
 Coding style: safe, with FPGA sync reset
 Description:  
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module vga_example (
	inout wire ps2_clk,
	inout wire ps2_data,
	input wire button,
	input wire clk,
	input wire rst,
	inout wire ps2_clk_sec,
	inout wire ps2_data_sec,
	
	output wire vs,
	output wire hs,
	output wire [3:0] r,
	output wire [3:0] g,
	output wire [3:0] b,
	output wire vs2,
	output wire hs2,
	output wire [3:0] red,
	output wire [3:0] green,
	output wire [3:0] blue,	
	//output wire pclk_mirror,
	output wire [6:0] sseg_ca,
    output wire [3:0] sseg_an 
);
// Mirrors pclk on a pin for use by the testbench;
//assign pclk_mirror = pclk;

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------

//clk wire ;
	wire locked;
	wire pclk, mclk;
	
//wires connecting modules
	wire [10:0] vcount, hcount;
	wire vsync, hsync;
	wire vblnk, hblnk;
	wire [11:0] xpos_wire, ypos_wire, ypos_wire_d, xpos_wire_d;
	wire [11:0] ypos_wire_sec, ypos_wire_sec_d;
	wire rst_out, mouse_left, mouse_left_d;

	assign vs2 = vs;
	assign hs2 = hs;
	assign red = r;
	assign green = g;
	assign blue = b;	
//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------	

	// Converts 100 MHz clk into 65 MHz pclk and 97,5 MHz mclk.
	clk_wiz_0 my_clk_wiz(
		.clk(clk),
		.reset(rst),
		.locked(locked),
		.clk65MHz(pclk),
		.clk97_5MHz(mclk)
	);


	rst_d my_rst_d(
		.rst_out(rst_out),
		.locked(locked),
		.clk(pclk)
	);

	vga_timing my_timing (
		.vcount(vcount),
		.vsync(vsync),
		.vblnk(vblnk),
		.hcount(hcount),
		.hsync(hsync),
		.hblnk(hblnk),
		.pclk(pclk),
		.rst(rst_out)
	);
	
	top_ctl My_top_ctl(
		.clk(pclk),
		.rst(rst_out),
		.vcount_in(vcount),
		.hcount_in(hcount),
		.vsync_in(vsync),
		.vblnk_in(vblnk),
		.hsync_in(hsync),
		.hblnk_in(hblnk),
		.ypos(ypos_wire_d),
		.xpos(xpos_wire_d),
		.mouse_left(mouse_left_d),
		.button(button),
		.ypos_sec(ypos_wire_sec_d),
			
		.vsync_out(vs),
		.hsync_out(hs),
		.sseg_ca(sseg_ca),
		.sseg_an(sseg_an),
		.rgb_out({r,g,b})
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
	
	MouseCtl My_MouseCtl_sec(
		.clk(mclk),
		.rst(rst_out),
		.value(12'b0),
		.setx(1'b0),
		.sety(1'b0),
		.setmax_x(1'b0),
		.setmax_y(1'b0),
		.ps2_clk(ps2_clk_sec),
		.ps2_data(ps2_data_sec),
		.xpos(),
		.ypos(ypos_wire_sec),
		.zpos(),
		.left(),
		.middle(),
		.right(),
		.new_event()
	);

	Mouse_delay My_mouse_delay(
		.clk(pclk),
		.rst(rst_out),
		.xpos_in(xpos_wire),
		.ypos_in(ypos_wire),
		.ypos_in_sec(ypos_wire_sec),
		.mouse_left_in(mouse_left),
		.xpos_out(xpos_wire_d),
		.ypos_out(ypos_wire_d),
		.ypos_out_sec(ypos_wire_sec_d),
		.mouse_left_out(mouse_left_d)
  );

endmodule
