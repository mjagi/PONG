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
    // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_nxt <= 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount_in == 0) rgb_nxt <= 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount_in == 599) rgb_nxt <= 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_nxt <= 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount_in == 799) rgb_nxt <= 12'h0_0_f;
      // Active display, interior, fill with gray.
      
       //szkielet prosty liczby
           else if (hcount_in >= 50 && hcount_in < 52 && vcount_in >= 50 && vcount_in < 151) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 70 && hcount_in < 72 && ((vcount_in >= 65 && vcount_in < 86) || (vcount_in >= 115 && vcount_in < 136))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 50 && hcount_in < 61 && ((vcount_in >= 50 && vcount_in < 52) || (vcount_in >= 149 && vcount_in < 151)|| (vcount_in >= 97 && vcount_in < 99))) rgb_nxt <= 12'hf_f_f;
           //górny brzuch
           else if (hcount_in >= 61 && hcount_in < 63 && ((vcount_in >= 52 && vcount_in < 55)|| (vcount_in >= 99 && vcount_in < 102))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 63 && hcount_in < 65 && ((vcount_in >= 55 && vcount_in < 58)|| (vcount_in >= 102 && vcount_in < 105))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 65 && hcount_in < 67 && ((vcount_in >= 58 && vcount_in < 61)|| (vcount_in >= 105 && vcount_in < 108))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 67 && hcount_in < 69 && ((vcount_in >= 61 && vcount_in < 64)|| (vcount_in >= 108 && vcount_in < 111))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 69 && hcount_in < 71 && ((vcount_in >= 64 && vcount_in < 65)|| (vcount_in >= 111 && vcount_in < 115))) rgb_nxt <= 12'hf_f_f;
           //dolny brzuch
           else if (hcount_in >= 69 && hcount_in < 71 && ((vcount_in >= 86 && vcount_in < 89)|| (vcount_in >= 136 && vcount_in < 139))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 67 && hcount_in < 69 && ((vcount_in >= 89 && vcount_in < 92)|| (vcount_in >= 139 && vcount_in < 142))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 65 && hcount_in < 67 && ((vcount_in >= 92 && vcount_in < 95)|| (vcount_in >= 142 && vcount_in < 145))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 63 && hcount_in < 65 && ((vcount_in >= 95 && vcount_in < 98)|| (vcount_in >= 145 && vcount_in < 148))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 61 && hcount_in < 63 && ((vcount_in >= 98 && vcount_in < 101)|| (vcount_in >= 148 && vcount_in < 151))) rgb_nxt <= 12'hf_f_f;
           
           //dróga liczba
           //szkielet prosty liczby
           else if (hcount_in >= 80 && hcount_in < 82 && vcount_in >= 50 && vcount_in < 151) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 100 && hcount_in < 102 && ((vcount_in >= 65 && vcount_in < 86) || (vcount_in >= 115 && vcount_in < 136))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 80 && hcount_in < 91 && ((vcount_in >= 50 && vcount_in < 52) || (vcount_in >= 149 && vcount_in < 151)|| (vcount_in >= 97 && vcount_in < 99))) rgb_nxt <= 12'hf_f_f;
           //górny brzuch
           else if (hcount_in >= 91 && hcount_in < 93 && ((vcount_in >= 52 && vcount_in < 55)|| (vcount_in >= 99 && vcount_in < 102))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 93 && hcount_in < 95 && ((vcount_in >= 55 && vcount_in < 58)|| (vcount_in >= 102 && vcount_in < 105))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 95 && hcount_in < 97 && ((vcount_in >= 58 && vcount_in < 61)|| (vcount_in >= 105 && vcount_in < 108))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 97 && hcount_in < 99 && ((vcount_in >= 61 && vcount_in < 64)|| (vcount_in >= 108 && vcount_in < 111))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 99 && hcount_in < 101 && ((vcount_in >= 64 && vcount_in < 65)|| (vcount_in >= 111 && vcount_in < 115))) rgb_nxt <= 12'hf_f_f;
           //dolny brzuch
           else if (hcount_in >= 99 && hcount_in < 101 && ((vcount_in >= 86 && vcount_in < 89)|| (vcount_in >= 136 && vcount_in < 139))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 97 && hcount_in < 99 && ((vcount_in >= 89 && vcount_in < 92)|| (vcount_in >= 139 && vcount_in < 142))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 95 && hcount_in < 97 && ((vcount_in >= 92 && vcount_in < 95)|| (vcount_in >= 142 && vcount_in < 145))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 93 && hcount_in < 95 && ((vcount_in >= 95 && vcount_in < 98)|| (vcount_in >= 145 && vcount_in < 148))) rgb_nxt <= 12'hf_f_f;
           else if (hcount_in >= 91 && hcount_in < 93 && ((vcount_in >= 98 && vcount_in < 101)|| (vcount_in >= 148 && vcount_in < 151))) rgb_nxt <= 12'hf_f_f;

      // You will replace this with your own test.
      else rgb_nxt <= 12'h8_8_8;    
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
