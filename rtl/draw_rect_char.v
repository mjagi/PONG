// File: vga_draw_rect_char.v
// This is the vga draw rectangle filled with characters design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_char (
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire pclk,
  input wire rst,
  input wire [11:0] rgb_in,
  input wire [7:0] char_pixels,

  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,  
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out,
  output reg [7:0] char_xy,
  output reg [3:0] char_line
  );

reg [11:0] rgb_nxt, rgb_temp;
reg [10:0] addr_y, addr_x;


parameter RECT_LENGTH = 256;
parameter RECT_WIDTH = 128;
parameter RECT_X = 300;
parameter RECT_Y = 200;
parameter RECT_COLOR = 12'h0_f_c;
parameter CHAR_COLOR = 12'hf_f_f;


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
  	  	if ((hcount_in > RECT_X) && (vcount_in >= RECT_Y) && (hcount_in <= RECT_X + RECT_WIDTH) && (vcount_in < RECT_Y + RECT_LENGTH))
		begin
		  if (char_pixels[4'b1000-addr_x[2:0]]) rgb_nxt = CHAR_COLOR;
		  else rgb_nxt = RECT_COLOR;
		end
		else rgb_nxt = rgb_temp;
	  end
		
	  char_xy = {addr_y[7:4], addr_x[6:3]};
	  char_line = addr_y[3:0];
	  addr_y = vcount_in - RECT_Y;
	  addr_x = hcount_in - RECT_X;
	end
		
endmodule
