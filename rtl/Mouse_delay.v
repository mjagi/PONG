//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   Mouse_delay
 Author:        Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-01
 Coding style: safe with FPGA sync reset
 Description:	buffer to change recived data speed from 97,5MHz to 65MHz
 */
//////////////////////////////////////////////////////////////////////////////
module Mouse_delay (
  input wire clk,
  input wire rst,
  input wire [11:0] ypos_in,
  input wire [9:0] ypos_in_one,
  input wire mouse_left_in,

  output reg [11:0] ypos_out,
  output reg [9:0] ypos_out_one,
  output reg mouse_left_out
  );

//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always @(posedge clk)
  begin
  	if(rst)
  	begin
      ypos_out <= 0;
      mouse_left_out <= 0;
      ypos_out_one <= 0;
  	end
  	else
  	begin
  	  ypos_out <= ypos_in;
  	  mouse_left_out <= mouse_left_in;
  	  ypos_out_one <= ypos_in_one;

  	end
  end
  
endmodule
 
 
 