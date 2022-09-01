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
	input wire button,
  
	output reg vsync_out,
	output reg hsync_out,
	output reg [11:0] rgb_out
);
reg [11:0] rgb_menu, rgb_game, rgb_cred;
reg vsync_menu, hsync_menu, vsync_game, hsync_game, vsync_cred, hsync_cred;
reg [1:0] state, state_nxt;

localparam IDLE = 2'b00;
localparam GAME = 2'b01;
localparam CREDITS = 2'b10;

always@* begin
    case(state)
    IDLE:     state_nxt = (mouse_left && (ypos >= 46 && ypos <= 146) && (xpos >= 362 && xpos <= 674)) ? GAME : (mouse_left && (ypos >= 622 && ypos <= 722) && (xpos >= 362 && xpos <= 674)) ? IDLE : CREDITS;
    GAME:     state_nxt = button  ? IDLE : GAME;
    CREDITS:  state_nxt = button ? IDLE : CREDITS;
    default: state_nxt = IDLE;
    endcase
end

always@* begin
    case(state_nxt)
    IDLE: begin		
		
    end
    GAME: begin
        
    end
    CREDITS: begin
        
    end
    default: begin

    end
    endcase
end

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
			
		.vsync_out(vsync_menu),
		.hsync_out(hsync_menu),
		.rgb_out(rgb_menu)
	);
	
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
      
        .vsync_out(vsync_game),
        .hsync_out(hsync_game),
        .rgb_out(rgb_game)
    );


 always @(posedge clk) begin
	if (rst) begin
		
		hsync_out <= 0;
		vsync_out <= 0;	

		rgb_out <= 0;
	end
	else if(state == 2'b10) begin	
		hsync_out <= hsync_cred;
		vsync_out <= vsync_cred;	
		rgb_out <= rgb_cred;
	end
	else if (state == 2'b01) begin	
        hsync_out <= hsync_game;
        vsync_out <= vsync_game;    
        rgb_out <= rgb_game;
    end
    else begin
        hsync_out <= hsync_menu;
        vsync_out <= vsync_menu;    
        rgb_out <= rgb_menu;
    end
end

endmodule

