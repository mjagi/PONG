`timescale 1ns / 1ps

module char_rom_16x2_cred
    (
        input  wire [7:0] char_xy,
        output reg  [6:0] char_code
    );

  parameter BLANK =	 	7'h20;
  parameter EXCLAMATION = 7'h21;
  parameter COMMA =	 	7'h2c;
  parameter DASH =	 	7'h2d;
  parameter DOT =	 	7'h2e;
  parameter COLON =	 	7'h3a;


  parameter ZERO =	 	7'h30;
  parameter ONE =	 	7'h31;
  parameter TWO =	 	7'h32;
  parameter THREE =	 	7'h33;
  parameter FOUR = 		7'h34;
  parameter FIVE = 		7'h35;
  parameter SIX = 		7'h36;
  parameter SEVEN = 	7'h37;
  parameter EIGHT = 	7'h38;
  parameter NINE = 		7'h39;
  
  parameter CAP_A =	 	7'h41;
  parameter CAP_B =	 	7'h42;
  parameter CAP_C =	 	7'h43;
  parameter CAP_D =	 	7'h44;
  parameter CAP_E = 	7'h45;
  parameter CAP_F = 	7'h46;
  parameter CAP_G = 	7'h47;
  parameter CAP_H = 	7'h48;
  parameter CAP_I = 	7'h49;
  parameter CAP_J = 	7'h4a;
  parameter CAP_K =	 	7'h4b;
  parameter CAP_L =	 	7'h4c;
  parameter CAP_M =	 	7'h4d;
  parameter CAP_N =	 	7'h4e;
  parameter CAP_O = 	7'h4f;
  parameter CAP_P = 	7'h50;
  parameter CAP_Q = 	7'h51;
  parameter CAP_R = 	7'h52;
  parameter CAP_S = 	7'h53;
  parameter CAP_T = 	7'h54;
  parameter CAP_U =	 	7'h55;
  parameter CAP_V =	 	7'h56;
  parameter CAP_W =	 	7'h57;
  parameter CAP_X =	 	7'h58;
  parameter CAP_Y = 	7'h59;
  parameter CAP_Z = 	7'h5a;
  
  parameter A =	 		7'h61;
  parameter B =	 		7'h62;
  parameter C =	 		7'h63;
  parameter D =	 		7'h64;
  parameter E = 		7'h65;
  parameter F = 		7'h66;
  parameter G = 		7'h67;
  parameter H = 		7'h68;
  parameter I = 		7'h69;
  parameter J = 		7'h6a;
  parameter K =		 	7'h6b;
  parameter L =		 	7'h6c;
  parameter M =		 	7'h6d;
  parameter N =		 	7'h6e;
  parameter O = 		7'h6f;
  parameter P = 		7'h70;
  parameter Q = 		7'h71;
  parameter R = 		7'h72;
  parameter S = 		7'h73;
  parameter T = 		7'h74;
  parameter U =		 	7'h75;
  parameter V =		 	7'h76;
  parameter W =		 	7'h77;
  parameter X =		 	7'h78;
  parameter Y = 		7'h79;
  parameter Z = 		7'h7a;

    always@*   
	  case(char_xy)
		8'h00: char_code = BLANK;
		8'h01: char_code = BLANK;
		8'h02: char_code = BLANK;
		8'h03: char_code = CAP_C;
		8'h04: char_code = R;
		8'h05: char_code = E;
		8'h06: char_code = A;
		8'h07: char_code = T;
		8'h08: char_code = E;
		8'h09: char_code = D;
		8'h0a: char_code = BLANK;
		8'h0b: char_code = B;
		8'h0c: char_code = Y;
		8'h0d: char_code = COLON;
		8'h0e: char_code = BLANK;
		8'h0f: char_code = BLANK;
		
		8'h10: char_code = BLANK;
		8'h11: char_code = BLANK; 
		8'h12: char_code = BLANK; 
		8'h13: char_code = BLANK; 
		8'h14: char_code = BLANK;
		8'h15: char_code = BLANK; 
		8'h16: char_code = BLANK;  
		8'h17: char_code = BLANK; 
		8'h18: char_code = BLANK; 
		8'h19: char_code = BLANK;
		8'h1a: char_code = BLANK; 
		8'h1b: char_code = BLANK; 
		8'h1c: char_code = BLANK;
		8'h1d: char_code = BLANK; 
		8'h1e: char_code = BLANK;
		8'h1f: char_code = BLANK; 

		8'h20: char_code = BLANK; 
		8'h21: char_code = BLANK; 
		8'h22: char_code = BLANK;   
		8'h23: char_code = BLANK;   
		8'h24: char_code = CAP_B;   
		8'h25: char_code = A;   
		8'h26: char_code = R;   
		8'h27: char_code = T;   
		8'h28: char_code = O;   
		8'h29: char_code = S;   
		8'h2a: char_code = Z;   
		8'h2b: char_code = BLANK;   
		8'h2c: char_code = BLANK;   
		8'h2d: char_code = BLANK;   
		8'h2e: char_code = BLANK;   
		8'h2f: char_code = BLANK;
				  
		8'h30: char_code = BLANK;   
		8'h31: char_code = BLANK;   
		8'h32: char_code = BLANK;   
		8'h33: char_code = CAP_B;   
		8'h34: char_code = I;   
		8'h35: char_code = A;   
		8'h36: char_code = L;   
		8'h37: char_code = K;   
		8'h38: char_code = O;   
		8'h39: char_code = W;   
		8'h3a: char_code = S;   
		8'h3b: char_code = K;   
		8'h3c: char_code = I;   
		8'h3d: char_code = BLANK;   
		8'h3e: char_code = BLANK;   
		8'h3f: char_code = BLANK;
				   
		8'h40: char_code = BLANK;   
		8'h41: char_code = BLANK;   
		8'h42: char_code = BLANK;   
		8'h43: char_code = BLANK;   
		8'h44: char_code = CAP_M;   
		8'h45: char_code = A;   
		8'h46: char_code = T;   
		8'h47: char_code = E;   
		8'h48: char_code = U;   
		8'h49: char_code = S;   
		8'h4a: char_code = Z;   
		8'h4b: char_code = BLANK;   
		8'h4c: char_code = BLANK;   
		8'h4d: char_code = BLANK;   
		8'h4e: char_code = BLANK;   
		8'h4f: char_code = BLANK;
		
		8'h50: char_code = BLANK;           
		8'h51: char_code = BLANK;   
		8'h52: char_code = BLANK;   
		8'h53: char_code = CAP_J;   
		8'h54: char_code = A;   
		8'h55: char_code = G;   
		8'h56: char_code = I;   
		8'h57: char_code = E;   
		8'h58: char_code = L;
		8'h59: char_code = S;   
		8'h5a: char_code = K;   
		8'h5b: char_code = I;   
		8'h5c: char_code = BLANK;   
		8'h5d: char_code = BLANK;   
		8'h5e: char_code = BLANK;   
		8'h5f: char_code = BLANK;   
		default: char_code = BLANK; 
	  endcase
endmodule
