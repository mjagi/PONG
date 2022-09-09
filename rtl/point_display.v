// File: point_display.v

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module point_display (
	input wire clk,
	input wire rst,
	input wire [1:0]score_p1,
	
	output wire [6:0] sseg_ca,   // segments (active LOW)
    output wire [3:0] sseg_an    // anode enable (active LOW)
);

// ring oscillator for multiplexing the displayed digits

    ring_counter
    #(
        .SIZE(4),          // 4-bit ring counter
        .INIT_VAL(4'b1110) // with single rotating 0
    )
    my_ring_counter
    (
        .clk(clk),
        .rst(rst),
        .ring(sseg_an)
    );
	
// multiplexing score to single output

    wire [2:0] point_selected; // code selected for display

    sseg_mux my_sseg_mux
    (
        .sel(sseg_an),
        .b0({1'b0,score_p1}),//X
        .b1(3'b000),//0
        .b2(3'b001),//1
        .b3(3'b100),//P
        .point_selected(point_selected)
    );

//------------------------------------------------------------------------------
// converting score to 7-segment display

    sseg_conv  my_sseg_conv
    (
        .point(point_selected),
        .sseg(sseg_ca)
    );	
	
endmodule	
