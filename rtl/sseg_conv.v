`timescale 1ns/1ps
/******************************************************************************
 * (C) Copyright 2016 AGH UST All Rights Reserved
 *
 * MODULE:    bcd2sseg
 * DEVICE:    general
 * PROJECT:   stopwatch
 * ABSTRACT:  This module converts 8421 BCD code into 7-segment display code
 *            (active LOW)
 *
 * HISTORY:
 * 1 Jan 2016, RS - initial version
 *******************************************************************************/
module sseg_conv (
        input  wire [2:0] point,
        output reg  [6:0] sseg
    );

    // bits for segments  gfedcba
    localparam SSEG_0 = 7'b1000000;
    localparam SSEG_1 = 7'b1111001;
    localparam SSEG_2 = 7'b0100100;
    localparam SSEG_3 = 7'b0110000;
    localparam SSEG_4 = 7'b0011001;
    localparam SSEG_5 = 7'b0010010;
    localparam SSEG_6 = 7'b0000010;
    localparam SSEG_7 = 7'b1111000;
    localparam SSEG_8 = 7'b0000000;
    localparam SSEG_9 = 7'b0010000;
	localparam SSEG_P = 7'b0001100;
    localparam SSEG_X = SSEG_2 | SSEG_5;

    always @*
        case(point)
            3'b000 : sseg    = SSEG_0;
            3'b001 : sseg    = SSEG_1;
            3'b010 : sseg    = SSEG_2;
            3'b011 : sseg    = SSEG_3;
            3'b100 : sseg    = SSEG_P;
            default : sseg = SSEG_X;
        endcase

endmodule
