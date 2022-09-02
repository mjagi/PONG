// This is the ROM for the ball image.
// The image size is 16 x 16 pixels.
// The input 'address' is a 8-bit number, composed of the concatenated
// 4-bit y and 4-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
module image_rom (
    input wire clk ,
    input wire [7:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [7:0] rom [0:255];

initial $readmemh("F:/Vivado/BartoszBialkowski/PROJECT/rtl/image_rom.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule
