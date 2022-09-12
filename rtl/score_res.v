//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   score_res
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-10
 Coding style: safe with FPGA sync reset
 Description:	game end screen generator
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module score_res (
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
  input wire [1:0] score_p1,
  input wire [1:0] score_p2,
  input wire [11:0] rgb_in,
  
  output reg vsync_out,
  output reg hsync_out,
  output reg [11:0] rgb_out
  );

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
	reg [11:0] rgb_nxt;
  
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------  
always @* begin
	if(score_p2 == 3)begin 
		// During blanking, make it it gray.
		if (vblnk_in || hblnk_in) rgb_nxt = 12'h3_3_3; 
		else begin
			//L
			if((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 40 && hcount_in <= 140)) rgb_nxt = color2;
			
			else if ((vcount_in >= 567 && vcount_in <= 667) && (hcount_in >= 100 && hcount_in <= 240)) rgb_nxt = color2;
			//O
			else if ((vcount_in >= 150 && vcount_in <= 617) && (hcount_in >= 250 && hcount_in <= 340)) rgb_nxt = color2;
			
			else if (((vcount_in >= 100 && vcount_in <= 150)||(vcount_in >= 617 && vcount_in <= 667)) && (hcount_in >= 340 && hcount_in <= 410)) rgb_nxt = color2;
			
			else if ((vcount_in >= 150 && vcount_in <= 617) && (hcount_in >= 410 && hcount_in <= 500)) rgb_nxt = color2;
			//S
			else if ((vcount_in >= 100 && vcount_in <= 380) && (hcount_in >= 510 && hcount_in <= 610)) rgb_nxt = color2;
			
			else if (((vcount_in >= 100 && vcount_in <= 213)||(vcount_in >= 326 && vcount_in <= 439)||(vcount_in >= 552 && vcount_in <= 667)) && (hcount_in >= 510 && hcount_in <= 760)) rgb_nxt = color2;
			
			else if ((vcount_in >= 380 && vcount_in <= 667) && (hcount_in >= 660 && hcount_in <= 760)) rgb_nxt = color2;
			//E
			else if((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 770 && hcount_in <= 870)) rgb_nxt = color2;
			
			else if (((vcount_in >= 100 && vcount_in <= 213)||(vcount_in >= 326 && vcount_in <= 439)||(vcount_in >= 552 && vcount_in <= 667)) && (hcount_in >= 770 && hcount_in <= 980)) rgb_nxt = color2;
			//background
			else rgb_nxt = color1;
		end	
	end
	else if(score_p1 == 3)begin 
		// During blanking, make it it gray.
		if (vblnk_in || hblnk_in) rgb_nxt = 12'h3_3_3; 
		else begin
			//W
			if((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 50 && hcount_in <= 150)) rgb_nxt = color2;
			
			else if (((vcount_in >= 630 - hcount_in) && (vcount_in <= 720 - hcount_in)) && (hcount_in >= 150 && hcount_in <= 240)) rgb_nxt = color2;
			
			else if (((vcount_in >= hcount_in + 240) && (vcount_in <= hcount_in + 330)) && (hcount_in >= 240 && hcount_in <= 330)) rgb_nxt = color2;
			
			else if ((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 330 && hcount_in <= 430)) rgb_nxt = color2;
			//I
			else if ((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 450 && hcount_in <= 550)) rgb_nxt = color2;
			//N
			else if ((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 570 && hcount_in <= 670)) rgb_nxt = color2;
			
			else if (((vcount_in >= hcount_in - 420) && (vcount_in <= hcount_in - 350)) && (hcount_in >= 670 && hcount_in <= 870)) rgb_nxt = color2;
			
			else if ((vcount_in >= 100 && vcount_in <= 667) && (hcount_in >= 870 && hcount_in <= 970)) rgb_nxt = color2;
			//background
			else rgb_nxt = color1;
		end
	end	
	else	rgb_nxt = rgb_in;    
end  

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------  
  always @(posedge pclk) begin
	if (rst) begin		
		hsync_out <= 0;
		vsync_out <= 0;	
		rgb_out <= 0;
	end
	else begin	
		hsync_out <= hsync_in;
		vsync_out <= vsync_in;		
		rgb_out <= rgb_nxt;
	end
end

endmodule
