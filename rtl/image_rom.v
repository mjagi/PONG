//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   image_rom
 Author:        Mateusz Jagielski
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: Xilinx recommended + ANSI ports
 Description:  Template for ROM module as recommended by Xilinx

 ** This example shows the use of the Vivado rom_style attribute
 **
 ** Acceptable values are:
 ** block : Instructs the tool to infer RAMB type components.
 ** distributed : Instructs the tool to infer LUT ROMs.
 **
 */
//////////////////////////////////////////////////////////////////////////////
// file modification for project purpose
// This is the ROM for the ball image.
// The image size is 16 x 16 pixels.
// The input 'address' is a 8-bit number, composed of the concatenated
// 4-bit y and 4-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)

module image_rom (
    input wire clk ,
    input wire [11:0] color1,
    input wire [11:0] color2,
    input wire [7:0] address,  // address = {addry[3:0], addrx[3:0]}
    output reg [11:0] rgb
);

reg [11:0] rom [0:255];
reg [11:0] rgb_nxt;

initial $readmemh("image_rom.data", rom); 

always @*
	begin
		if(rom[address] == 000) rgb_nxt = color1;
		else rgb_nxt = color2;
	end
		

always @(posedge clk)
    rgb <= rgb_nxt;

endmodule
