// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire rst
  );


localparam HOR_TOTAL_TIME = 1056;
localparam HOR_BLANK_START = 800;
localparam HOR_BLANK_STOP = 1056;
localparam HOR_SYNC = 840;
localparam HOR_SYNC_TIME = 128;

localparam VER_TOTAL_TIME = 628;
localparam VER_BLANK_START = 600;
localparam VER_BLANK_STOP = 628;
localparam VER_SYNC = 601;
localparam VER_SYNC_TIME = 4;

reg [10:0] vcount_next;
reg [10:0] hcount_next;
reg hsync_next;
reg vsync_next;
reg hblanc_next;
reg vblanc_next;


always @* begin
    if(hcount == (HOR_TOTAL_TIME - 1))
        hcount_next = 0;
    else
        hcount_next = hcount + 1;
    
    if(hcount == (HOR_TOTAL_TIME - 1) && vcount == (VER_TOTAL_TIME - 1))
        vcount_next = 0;
    else if(hcount == (HOR_TOTAL_TIME - 1))
        vcount_next = vcount + 1;
    else
        vcount_next = vcount;

	if(hcount >= (HOR_BLANK_START - 1) && hcount <= (HOR_BLANK_STOP - 2))
        hblanc_next = 1;
    else
        hblanc_next = 0;
  
	if (vcount == (VER_BLANK_START - 1) && hcount == (HOR_TOTAL_TIME - 1))
        vblanc_next = 1;
    else if (vcount >= (VER_BLANK_START) && vcount <= (VER_BLANK_STOP - 2))
        vblanc_next = 1;
    else if (vcount == (VER_BLANK_STOP - 1) && hcount <= (HOR_TOTAL_TIME - 2))
        vblanc_next = 1;
    else
        vblanc_next = 0;
	
	if ((hcount >= (HOR_SYNC - 1)) && (hcount < (HOR_SYNC + HOR_SYNC_TIME - 1))) begin
		hsync_next = 1;
	end
	else hsync_next = 0;
	
	
	if (vcount == (VER_SYNC + VER_SYNC_TIME - 1) && (hcount == HOR_TOTAL_TIME - 1))begin
	vsync_next = 0;
	end
	else if((vcount == (VER_SYNC + VER_SYNC_TIME - 1)) && (hcount == (HOR_TOTAL_TIME - 2))) begin
	   vsync_next = 1;
	end
	else if ((vcount >= VER_SYNC) && (vcount < (VER_SYNC + VER_SYNC_TIME))) begin
        vsync_next = 1;
    end
	else if ((hcount == HOR_TOTAL_TIME - 1) && (vcount == (VER_SYNC - 1))) begin
		vsync_next = 1;
    end
	else vsync_next = 0;

end

always @(posedge pclk) begin
	if (rst) begin
		hcount <= 0;
		vcount <= 0;
		
		hblnk <= 0;
		vblnk <= 0;
		
		hsync <= 0;
		vsync <= 0;		
	end
	else begin
		hcount <= hcount_next;
		vcount <= vcount_next;
	
		hblnk <= hblanc_next;
		vblnk <= vblanc_next;
	
		hsync <= hsync_next;
		vsync <= vsync_next;
	end
end


  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.

endmodule
