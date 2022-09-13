//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   point_display
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-08
 Coding style: safe with FPGA sync reset
 Description: 	structural module for 7 segment display
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module point_display (
	input wire clk,
	input wire rst,
	input wire [1:0]score_p2,
	
	output wire [6:0] sseg_ca,   // segments (active LOW)
    output wire [3:0] sseg_an    // anode enable (active LOW)
);

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------
	wire clk300Hz;
	wire [2:0] point_selected; // code selected for display

//------------------------------------------------------------------------------
// modules
//------------------------------------------------------------------------------
	// clock divider to produce stopwatch 300 Hz clock from 100 MHz external clock
    clk_divider 
    #(
    .OUT_FREQUENCY(300)
    )
    divider_sseg
    (
        .clk100MHz(clk), //input clock 100 MHz
        .rst (rst),            //async reset active high
        .clk_div (clk300Hz)
    );

    ring_counter
    #(
        .SIZE(4),          // 4-bit ring counter
        .INIT_VAL(4'b1110) // with single rotating 0
    )
    my_ring_counter
    (
        .clk(clk300Hz),
        .rst(rst),
        .ring(sseg_an)
    );
	
    sseg_mux my_sseg_mux
    (
        .sel(sseg_an),
        .b0({1'b0,score_p2}),//X - current score
        .b1(3'b101),//-
        .b2(3'b010),//2
        .b3(3'b100),//P
        .point_selected(point_selected)
    );

    sseg_conv  my_sseg_conv
    (
        .point(point_selected),
        .sseg(sseg_ca)
    );	
	
endmodule	
