// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_background (
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire pclk,
  input wire rst,
  input wire [11:0] color1,
  input wire [11:0] color2,
    
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg vsync_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out
  );


	reg [11:0] rgb_nxt;

  // This is a simple test pattern generator.
  
  always @*
  begin
    // During blanking, make it it gray.
    if (vblnk_in || hblnk_in) rgb_nxt = 12'h3_3_3; 
    else
    begin
      // Active display, top edge, make a white line.
      if (vcount_in == 0) rgb_nxt = color2;
      // Active display, bottom edge, make a white line.
      else if (vcount_in == 767) rgb_nxt = color2;
      // Active display, left edge, make a white line.
      else if (hcount_in == 1) rgb_nxt = color2;
      // Active display, right edge, make a white line.
      else if (hcount_in == 1023) rgb_nxt = color2;
      // Active display, interior, fill with black.
      else rgb_nxt = color1;    
    end
  end
  
  
  always @(posedge pclk) begin
	if (rst) begin
		hcount_out <= 0;
		vcount_out <= 0;
		
		hblnk_out <= 0;
		vblnk_out <= 0;
		
		hsync_out <= 0;
		vsync_out <= 0;	

		rgb_out <= 0;
	end
	else begin
		hcount_out <= hcount_in;
		vcount_out <= vcount_in;
	
		hblnk_out <= hblnk_in;
		vblnk_out <= vblnk_in;
	
		hsync_out <= hsync_in;
		vsync_out <= vsync_in;
		
		rgb_out <= rgb_nxt;
	end
end


endmodule
