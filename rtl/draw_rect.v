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
  input wire [11:0] y_pos,
  input wire [11:0] rgb_in,
  
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg vsync_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out
  );

localparam SZEROKOSC = 10;
localparam WYSOKOSC = 80;
localparam ODLEGLOSC = 60;
localparam KOLOR = 12'hf_f_f;

reg [11:0] rgb_nxt, rgb_temp;
//reg [10:0] vcount_temp, hcount_temp;
//reg vsync_temp, hsync_temp, vblnk_temp, hblnk_temp;

  // This is a simple rectangle pattern generator.
  
  always @*
  begin
    //if(vcount_in == y_pos && hcount_in == x_pos) rgb_nxt <= 12'h000;
    if ((y_pos >= (768 - WYSOKOSC)) && (vcount_in >= (768 - WYSOKOSC)) && (hcount_in >= (ODLEGLOSC - SZEROKOSC)) && (hcount_in < ODLEGLOSC)) rgb_nxt = KOLOR;
    
    else if ((vcount_in >= y_pos) && (vcount_in < (y_pos + WYSOKOSC)) && (hcount_in >= (ODLEGLOSC - SZEROKOSC)) && 
        (hcount_in < ODLEGLOSC)) rgb_nxt = KOLOR;
	else rgb_nxt = rgb_in;
  end
 /* 
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
  */
  
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
