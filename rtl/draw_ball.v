// File: vga_draw_ball.v
// This is the vga draw rectangle design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_draw_ball (
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire pclk,
  input wire rst,
  input wire [11:0] rgb_in,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  input wire [11:0] rgb_pixel,

  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,  
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out,
  output wire [7:0] pixel_addr
  );

reg [11:0] rgb_nxt, rgb_temp;
wire [3:0] pixel_addr_y, pixel_addr_x;
reg [10:0] vcount_nxt, vcount_nxt2, hcount_nxt, hcount_nxt2;



parameter RECT_LENGTH = 16;
parameter RECT_WIDTH = 16;
//parameter RECT_X = 317;
//parameter RECT_Y = 40;
//parameter RECT_COLOR = 12'h0_f_c;

  assign pixel_addr_y = vcount_in - ypos;
  assign pixel_addr_x = hcount_in - xpos;
  assign pixel_addr = {pixel_addr_y[3:0], pixel_addr_x[3:0]};
  

  always @(posedge pclk)
  begin
    if(rst)
    begin
      hcount_out <= 0;
      hsync_out <= 0;
      hblnk_out <= 0;
      vcount_out <= 0;
      vsync_out <= 0;
      vblnk_out <= 0;
      rgb_out <= 0;
	  rgb_temp <= 0;
    end
    
    else 
    begin
      hcount_out <= hcount_in;
      hsync_out <= hsync_in;
      hblnk_out <= hblnk_in;
      vcount_out <= vcount_in;
      vsync_out <= vsync_in;
      vblnk_out <= vblnk_in;
	  rgb_temp <= rgb_in;
      rgb_out <= rgb_nxt;
	end
  end
  
  always @*
 	begin
 	  if (vblnk_out || hblnk_out) rgb_nxt = 12'h0_0_0;
 	  else
  	  	begin
  	  	if ((hcount_in > xpos) && (vcount_in >= ypos) && (hcount_in <= xpos + RECT_WIDTH) && (vcount_in < ypos + RECT_LENGTH))
		  rgb_nxt = rgb_pixel;
		else rgb_nxt = rgb_temp;
		end
	end
		
endmodule