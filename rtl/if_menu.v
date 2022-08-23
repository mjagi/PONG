`timescale 1 ns / 1 ps


module if_menu (
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

  // This is a simple menu pattern generator.
  
  always @*
  begin
    // During blanking, make it it gray.
    if (vblnk_in || hblnk_in) rgb_nxt = 12'h3_3_3; 
    else
    begin
      // Active display, top edge, make a white line.
      if (vcount_in == 0) rgb_nxt = 12'hf_f_f;
      // Active display, bottom edge, make a white line.
      else if (vcount_in == 767) rgb_nxt = 12'hf_f_f;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_nxt = 12'hf_f_f;
      // Active display, right edge, make a red line.
      else if (hcount_in == 1023) rgb_nxt = 12'hf_f_f;
	  // Active display, boxes gray
	  else if (hcount_in >= 362 && hcount_in <= 674 &&(vcount_in == 46 || vcount_in ==  146 || 
	  vcount_in == 238 || vcount_in == 338 || vcount_in == 430 || vcount_in == 530 ||
	  vcount_in == 622 || vcount_in == 722)) rgb_nxt = 12'h3_3_3;
	  
	  else if ((hcount_in = 362 || hcount_in = 674) && ((vcount_in >= 46 && vcount_in <= 146) || 
	  (vcount_in >= 238 || vcount_in <= 338) || (vcount_in >= 430 || vcount_in <= 530) ||
	  (vcount_in >= 622 || vcount_in <= 722))) rgb_nxt = 12'h3_3_3;
	  
      // Active display, interior, fill with black.
      else rgb_nxt = 12'h0_0_0;    
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
