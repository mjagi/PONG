`timescale 1 ns / 1 ps

module top_ctl(
	input wire clk,
	input wire rst,
	input wire mouse_left,
	input wire [11:0] mouse_xpos,
	input wire [11:0] mouse_ypos,

	output reg [11:0] xpos,
	output reg [11:0] ypos
);

localparam IDLE = 2'b00;
localparam GAME = 2'b01;
localparam CREDITS = 2'b10;

always@* begin
    case(state)
    IDLE:     state_nxt = (mouse_left && (ypos >= 46 && ypos <= 146) && (xpos >= 362 && xpos <= 674)) ? GAME : (IDLE : CREDITS);
    GAME:     state_nxt = button1  ? IDLE : GAME;
    CREDITS:   state_nxt = button1 ? IDLE : CREDITS;
    default: state_nxt = IDLE;
    endcase
end

always@* begin
    case(state_nxt)
    IDLE: begin		
		menu_ctl My_menu_ctl(
			.clk(),
			.rst(),
			.vcount_in(),
			.hcount_in(),
			.vsync_in(),
			.vblnk_in(),
			.hsync_in(),
			.hblnk_in(),
			.ypos(),
			.xpos(),
			.rgb_in(),
			
			.vcount_out(),
			.hcount_out(),
			.vsync_out(),
			.hsync_out(),
			.hblnk_out(),
			.vblnk_out(),
			.rgb_out()
		);
    end
    GAME: begin
		game_ctl My_game_ctl(
			.clk(),
			.rst(),
			.vcount_in(),
			.hcount_in(),
			.vsync_in(),
			.vblnk_in(),
			.hsync_in(),
			.hblnk_in(),
			.ypos(),
			.rgb_in(),
  
			.vcount_out(),
			.hcount_out(),
			.vsync_out(),
			.hsync_out(),
			.hblnk_out(),
			.vblnk_out(),
			.rgb_out()
		);
        
    end
    CREDITS: begin
        
    end
    default: begin
        
    end
    endcase


endmodule
