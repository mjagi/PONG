// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect (
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire pclk,
  input wire rst,
  input wire [11:0] x_pos,
  input wire [11:0] y_pos,
  input wire [11:0] rgb_in,
  input wire [11:0] rgb_pixel,
  
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg vsync_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out,
  output reg [11:0] pixel_addr
  );

localparam SZEROKOSC = 48;
localparam WYSOKOSC = 64;

reg hsync_temp, vsync_temp, hblnk_temp, vblnk_temp, hsync_temp2, vsync_temp2, hblnk_temp2, vblnk_temp2;
reg [10:0] hcount_temp, vcount_temp, hcount_temp2, vcount_temp2;
reg [11:0] rgb_nxt,rgb_temp, rgb_temp2;
reg [10:0] addrx, addry;

always @(posedge pclk) begin
	if (rst) begin
		hcount_temp <= 0;
		vcount_temp <= 0;
		
		hblnk_temp <= 0;
		vblnk_temp <= 0;
		
		hsync_temp <= 0;
		vsync_temp <= 0;
		rgb_temp <= 0;	
	end
	else begin
		hcount_temp <= hcount_in;
		vcount_temp <= vcount_in;
	
		hblnk_temp <= hblnk_in;
		vblnk_temp <= vblnk_in;
	
		hsync_temp <= hsync_in;
		vsync_temp <= vsync_in;
		rgb_temp <= rgb_in;
	end
end

always @(posedge pclk) begin
	if (rst) begin
		hcount_temp2 <= 0;
		vcount_temp2 <= 0;
		
		hblnk_temp2 <= 0;
		vblnk_temp2 <= 0;
		
		hsync_temp2 <= 0;
		vsync_temp2 <= 0;
		rgb_temp2 <= 0;	
	end
	else begin
		hcount_temp2 <= hcount_temp;
		vcount_temp2 <= vcount_temp;
	
		hblnk_temp2 <= hblnk_temp;
		vblnk_temp2 <= vblnk_temp;
	
		hsync_temp2 <= hsync_temp;
		vsync_temp2 <= vsync_temp;		
		rgb_temp2 <= rgb_temp;	
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
		hcount_out <= hcount_temp2;
		vcount_out <= vcount_temp2;
	
		hblnk_out <= hblnk_temp2;
		vblnk_out <= vblnk_temp2;
	
		hsync_out <= hsync_temp2;
		vsync_out <= vsync_temp2;
		
		rgb_out <= rgb_nxt;
		pixel_addr <= {addry[5:0], addrx[5:0]};
	end
end

  // This is a simple rectangle pattern generator.
  
  always @*
  begin
    //if(vcount_in == y_pos && hcount_in == x_pos) rgb_nxt <= 12'h000;
    if ((vcount_temp2 >= y_pos) && (vcount_temp2 < (y_pos + WYSOKOSC)) && (hcount_temp2 >= x_pos) && 
	(hcount_temp2 < (x_pos + SZEROKOSC)))
	begin
	rgb_nxt = rgb_pixel; 
	addrx = hcount_in - x_pos;
    addry = vcount_in - y_pos;
	end
    else begin
    rgb_nxt = rgb_temp2;
    addrx = hcount_in - x_pos;
    addry = vcount_in - y_pos;
    end
	
  end


endmodule
