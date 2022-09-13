//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_ctl
 Author:        Bartosz Białkowski, Mateusz Jagielski
 Version:       1.0
 Last modified: 2022-09-10
 Coding style: safe with FPGA sync reset
 Description:  top module 
 */
//////////////////////////////////////////////////////////////////////////////
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
	input wire [9:0] ypos_one,
  
	output reg vsync_out,
	output reg hsync_out,
	output wire [6:0] sseg_ca,
    output wire [3:0] sseg_an,
	output reg [11:0] rgb_out
	);

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
localparam IDLE = 2'b00;
localparam GAME = 2'b01;
localparam CREDITS = 2'b10;

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------
wire [11:0] rgb_menu, rgb_game, rgb_cred;
wire vsync_menu, hsync_menu, vsync_game, hsync_game, vsync_cred, hsync_cred;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [11:0] rgb_nxt, color1, color2;
reg vsync_nxt, hsync_nxt;
reg [1:0] state, state_nxt;
reg [2:0] color_state, color_state_nxt;
reg difficulty, difficulty_nxt, start; 

//------------------------------------------------------------------------------
// next state logic
//------------------------------------------------------------------------------
always@* begin
    case(state)
    IDLE:     state_nxt = (mouse_left && (ypos_one >= 46 && ypos_one <= 146) && (xpos >= 362 && xpos <= 674)) ? GAME : (mouse_left && (ypos_one >= 622 && ypos_one <= 722) && (xpos >= 362 && xpos <= 674)) ? CREDITS : IDLE;
    GAME:     state_nxt = button ? IDLE : GAME;
    CREDITS:  state_nxt = button ? IDLE : CREDITS;
    default: state_nxt = IDLE;
    endcase
end

//------------------------------------------------------------------------------
// output logic
//------------------------------------------------------------------------------
always@* begin
    case(state_nxt)
    IDLE: begin		
		vsync_nxt = vsync_menu;
		hsync_nxt = hsync_menu;
		rgb_nxt = rgb_menu;
		color_state_nxt = 0;
		start = 0;

		if(mouse_left && (ypos_one >= 238 && ypos_one <= 338) && (xpos >= 362 && xpos <= 674)) begin
		  if (difficulty == 1) difficulty_nxt = 0;
		  else difficulty_nxt = 1;
		end
		else difficulty_nxt = difficulty;
		
		if(mouse_left && (ypos_one >= 430 && ypos_one <= 530) && (xpos >= 362 && xpos <= 674)) begin
			if(color_state >= 6) color_state_nxt = 0;
			else color_state_nxt = color_state + 1;
		end
		else color_state_nxt = color_state;
    end

    GAME: begin
		vsync_nxt = vsync_game;
    	hsync_nxt = hsync_game;
    	rgb_nxt = rgb_game;
    	difficulty_nxt = difficulty;
    	color_state_nxt = color_state;
    	start = 1;
    end

    CREDITS: begin
        vsync_nxt = vsync_cred;
    	hsync_nxt = hsync_cred;
    	rgb_nxt = rgb_cred;
    	difficulty_nxt = difficulty;
     	color_state_nxt = color_state;
     	start = 0;
    end

    default: begin
		vsync_nxt = vsync_menu;
    	hsync_nxt = hsync_menu;
    	rgb_nxt = rgb_menu;
    	difficulty_nxt = 0;
    	color_state_nxt = color_state;
    	start = 0;
    end
    endcase
    
    
    case(color_state_nxt)
    0: begin
    	color1 = 12'h0_0_0;
    	color2 = 12'hf_f_f;
    end
    
    1: begin
    	color1 = 12'h0_9_9;
    	color2 = 12'hf_6_6;
    end

	2: begin
    	color1 = 12'h9_0_9;
    	color2 = 12'h6_f_6;
    end
    
	3: begin
    	color1 = 12'h9_9_0;
    	color2 = 12'h6_6_f;
    end
    
	4: begin
    	color1 = 12'h3_3_9;
    	color2 = 12'hf_f_6;
    end
    
	5: begin
    	color1 = 12'h9_3_3;
    	color2 = 12'h6_f_f;
    end

	6: begin
    	color1 = 12'h3_9_3;
    	color2 = 12'hf_6_f;
    end

	default: begin
    	color1 = 12'h0_0_0;
    	color2 = 12'hf_f_f;
    end    
    endcase
end

//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------
    menu_ctl My_menu_ctl(
		.clk(clk),
		.rst(rst),
		.vcount_in(vcount_in),
		.hcount_in(hcount_in),
		.vsync_in(vsync_in),
		.vblnk_in(vblnk_in),
		.hsync_in(hsync_in),
		.hblnk_in(hblnk_in),
//		.ypos(ypos_one),
//		.xpos(xpos),
		.difficulty(difficulty),
		.color1(color1),
		.color2(color2),
			
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
        .ypos_one(ypos_one),
        .mouse_left(mouse_left),
        .difficulty(difficulty),
        .color1(color1),
        .color2(color2),
		.button(button),
		.start(start),
		
        .vsync_out(vsync_game),
        .hsync_out(hsync_game),
		.sseg_ca(sseg_ca),
		.sseg_an(sseg_an),
        .rgb_out(rgb_game)
    );
	
	cred_ctl My_cred_ctl(
		.clk(clk),
		.rst(rst),
		.vcount_in(vcount_in),
		.hcount_in(hcount_in),
		.vsync_in(vsync_in),
		.vblnk_in(vblnk_in),
		.hsync_in(hsync_in),
		.hblnk_in(hblnk_in),
		.mouse_left(mouse_left),
		.color1(color1),
		.color2(color2),
  
		.vsync_out(vsync_cred),
		.hsync_out(hsync_cred),
		.rgb_out(rgb_cred)
  );

//------------------------------------------------------------------------------
// output register
//------------------------------------------------------------------------------
 always @(posedge clk) begin
	if (rst) begin
	    state <= 0;
		hsync_out <= 0;
		vsync_out <= 0;	
		rgb_out <= 0;
		difficulty <= 0;
		color_state <= 0;
	end
	else begin	
	    state <= state_nxt;
		hsync_out <= hsync_nxt;
		vsync_out <= vsync_nxt;	
		rgb_out <= rgb_nxt;
		difficulty <= difficulty_nxt;
		color_state <= color_state_nxt;
	end
end

endmodule

