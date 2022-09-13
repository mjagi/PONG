//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_rect
 Author:        Bartosz Białkowski, Mateusz Jagielski
 Version:       1.0
 Last modified: 2022-09-08
 Coding style: safe with FPGA sync reset
 Description:   module that draws players racket
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module draw_rect (
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire pclk,
  input wire rst,
  input wire [11:0] y_pos,
  input wire [9:0] y_pos_sec,
  input wire [11:0] rgb_in,
  input wire [11:0] color2,
  
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg vsync_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out
  );

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
localparam WIDTH = 10;
localparam LENGTH = 80;
localparam XPOS = 60;
localparam XPOS_SEC = 963;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [11:0] rgb_nxt, rgb_temp;

//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------  
  always @*
  begin 
    if ((vcount_in >= y_pos) && (vcount_in < (y_pos + LENGTH)) && (hcount_in >= (XPOS - WIDTH)) && 
        (hcount_in < XPOS)) rgb_nxt = color2;
    else if ((vcount_in >= y_pos_sec) && (vcount_in < (y_pos_sec + LENGTH)) && (hcount_in >= (XPOS_SEC)) && 
        (hcount_in < XPOS_SEC + WIDTH)) rgb_nxt = color2;
	else rgb_nxt = rgb_in;
  end

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------  
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
