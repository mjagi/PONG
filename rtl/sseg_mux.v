`timescale 1ns/1ps
/******************************************************************************
 * (C) Copyright 2016 AGH UST All Rights Reserved
 *
 * MODULE:    sseg_mux
 * DEVICE:    general
 * PROJECT:   stopwatch
 *
 * ABSTRACT:  Multiplexer of four 3-bit input numbers into one 3-bit bus
 *
 * Module provided by lecturer. Modified
 *
 * HISTORY:
 * 4 Jan 2016, RS - initial version
 * 10 Sep 2022, BB - modification for project purpose
 *
 *******************************************************************************/
module sseg_mux (
        input  wire [3:0] sel,         // single zero will select the input
        input  wire [2:0] b0,
        input  wire [2:0] b1,
        input  wire [2:0] b2,
        input  wire [2:0] b3,
        output reg  [2:0] point_selected
    );

    always @*
        case(sel)
            4'b1110: point_selected = b0;
            4'b1101: point_selected = b1;
            4'b1011: point_selected = b2;
            4'b0111: point_selected = b3;
            default: point_selected = 3'bxxx;
        endcase

endmodule
