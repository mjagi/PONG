//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_cred_char
 Author:        Mateusz Jagielski, Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-09
 Coding style: safe, with FPGA sync reset
 Description: 
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module draw_cred_char (
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
  input wire [11:0] color1,
  input wire [11:0] color2,
  input wire [11:0] xpos,
  input wire [11:0] ypos,

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

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------ 
localparam RECT_LENGTH = 96;
localparam RECT_WIDTH = 128;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [11:0] rgb_nxt, rgb_temp;
reg [7:0] addr_y;
reg [6:0] addr_x;

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------
wire [10:0] hcount_del, vcount_del; 
wire hsync_del, hblnk_del, vsync_del, vblnk_del;

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
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
      hcount_out <= hcount_del;
      hsync_out <= hsync_del;
      hblnk_out <= hblnk_del;
      vcount_out <= vcount_del;
      vsync_out <= vsync_del;
      vblnk_out <= vblnk_del;
	  rgb_temp <= rgb_in;
      rgb_out <= rgb_nxt;
	end
  end

//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------  
    delay #(
		.WIDTH (26),
		.CLK_DEL(1)
	) u_delay (
		.clk (pclk),
		.rst (rst),
		.din ({hcount_in, hsync_in, vcount_in, vsync_in, hblnk_in, vblnk_in}),
		.dout ({hcount_del, hsync_del, vcount_del, vsync_del, hblnk_del, vblnk_del})
	);

//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------ 
  always @*
  	begin
  	  if (vblnk_out || hblnk_out) rgb_nxt = 12'h0_0_0;
  	  else
  	  begin
  	  	if ((hcount_in > xpos) && (vcount_in >= ypos) && (hcount_in <= xpos + RECT_WIDTH) && (vcount_in < ypos + RECT_LENGTH))
		begin
		  if (char_pixels[4'b1000-addr_x[2:0]]) rgb_nxt = color2;
		  else rgb_nxt = color1;
		end
		else rgb_nxt = rgb_temp;
	  end
		
	  char_xy = {addr_y[7:4], addr_x[6:3]};
	  char_line = addr_y[3:0];
	  addr_y = vcount_in - ypos;
	  addr_x = hcount_in - xpos;
	end
		
endmodule
