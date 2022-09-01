`timescale 1 ns / 1 ps

module top_ctl(
	input wire clk,
	input wire rst,
	input wire [10:0] vcount_in,
	input wire [10:0] hcount_in,
	input wire vsync_in,
	input wire vblnk_in,
	input wire hsync_in,
	input wire hblnk_in,
	input wire [11:0] ypos,
	input wire [11:0] xpos,
	input wire mouse_left,
  
	output reg [10:0] vcount_out,
	output reg [10:0] hcount_out,
	output reg vsync_out,
	output reg hsync_out,
	output reg hblnk_out,
	output reg vblnk_out,
	output reg [11:0] rgb_out
);
reg [11:0] rgb_temp;
reg [10:0] vcount_temp, hcount_temp;
reg vsync_temp, hsync_temp, vblnk_temp, hblnk_temp;

localparam IDLE = 2'b00;
localparam GAME = 2'b01;
localparam CREDITS = 2'b10;

always@* begin
    case(state)
    IDLE:     state_nxt = (mouse_left && (ypos >= 46 && ypos <= 146) && (xpos >= 362 && xpos <= 674)) ? GAME : (mouse_left && (ypos >= 622 && ypos <= 722) && (xpos >= 362 && xpos <= 674)) ? IDLE : CREDITS;
    GAME:     state_nxt = button1  ? IDLE : GAME;
    CREDITS:   state_nxt = button1 ? IDLE : CREDITS;
    default: state_nxt = IDLE;
    endcase
end

always@* begin
    case(state_nxt)
    IDLE: begin		
		menu_ctl My_menu_ctl(
			.clk(clk),
			.rst(rst),
			.vcount_in(vcount_in),
			.hcount_in(hcount_in),
			.vsync_in(vsync_in),
			.vblnk_in(vblnk_in),
			.hsync_in(hsync_in),
			.hblnk_in(hblnk_in),
			.ypos(ypos),
			.xpos(xpos),
			
			.vcount_out(vcount_temp),
			.hcount_out(hcount_temp),
			.vsync_out(vsync_temp),
			.hsync_out(hsync_temp),
			.hblnk_out(hblnk_temp),
			.vblnk_out(vblnk_temp),
			.rgb_out(rgb_temp)
		);
    end
    GAME: begin
		game_ctl My_game_ctl(
			.clk(clk),
			.rst(rst),
			.vcount_in(vcount_in),
			.hcount_in(hcount_in),
			.vsync_in(vsync_in),
			.vblnk_in(vblnk_in),
			.hsync_in(hsync_in),
			.hblnk_in(hblnk_in),
			.ypos(ypos),
  
			.vcount_out(vcount_temp),
			.hcount_out(hcount_temp),
			.vsync_out(vsync_temp),
			.hsync_out(hsync_temp),
			.hblnk_out(hblnk_temp),
			.vblnk_out(vblnk_temp),
			.rgb_out(rgb_temp)
		);
        
    end
    CREDITS: begin
        
    end
    default: begin
		menu_ctl My_menu_ctl(
			.clk(clk),
			.rst(rst),
			.vcount_in(vcount_in),
			.hcount_in(hcount_in),
			.vsync_in(vsync_in),
			.vblnk_in(vblnk_in),
			.hsync_in(hsync_in),
			.hblnk_in(hblnk_in),
			.ypos(ypos),
			.xpos(xpos),
			
			.vcount_out(vcount_temp),
			.hcount_out(hcount_temp),
			.vsync_out(vsync_temp),
			.hsync_out(hsync_temp),
			.hblnk_out(hblnk_temp),
			.vblnk_out(vblnk_temp),
			.rgb_out(rgb_temp)
		);       
    end
    endcase

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
		hcount_out <= hcount_temp;
		vcount_out <= vcount_temp;
	
		hblnk_out <= hblnk_temp;
		vblnk_out <= vblnk_temp;
	
		hsync_out <= hsync_temp;
		vsync_out <= vsync_temp;
		
		rgb_out <= rgb_nxt;
	end
end

endmodule
