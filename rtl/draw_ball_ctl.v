// File: vga_draw_ball_ctl.v
// This is the vga draw rectangle control design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_ball_ctl (
  input wire pclk,
  input wire rst,
  //input wire [11:0] mouse_xpos,
  input wire [11:0] mouse_ypos,
  input wire mouse_left,
  input wire difficulty,

  output reg [11:0] xpos,
  output reg [11:0] ypos
  );
  
  parameter IDLE = 2'b00;
  parameter MOVING = 2'b01;
  parameter WALL = 2'b10;
  parameter SPEED_UP = 2'b11;
  
  parameter UPRIGHT = 2'b00;
  parameter DOWNRIGHT = 2'b01;
  parameter DOWNLEFT = 2'b10;
  parameter UPLEFT = 2'b11;
  
  parameter INTERVAL_START = 20'b1000_0000_0000_0000_0000;
  parameter INTERVAL_CHANGE_HARD = 20'b0000_1000_0000_0000_0000;
  parameter INTERVAL_CHANGE_EASY = 20'b0000_0000_0000_1000_0000;
//  parameter INTERVAL_MIN = 20'b0000_0000_1000_0000_0000;
  parameter BALL_DIAMETER = 16;
  
  parameter LEFT_WALL = 1;
  parameter RIGHT_WALL = 1022;
  parameter UP_WALL = 1;
  parameter DOWN_WALL = 766;
  
  parameter CENTRAL_LINE = 511;

  parameter SZEROKOSC = 10;
  parameter WYSOKOSC = 80;
  parameter ODLEGLOSC = 60;
  
  reg [1:0] state, state_nxt, direction, direction_nxt;
  reg [11:0] speed_count, speed_count_nxt, speed_change_count, speed_change_count_nxt;
  reg [11:0] xpos_nxt, ypos_nxt;
  reg [19:0] pxl_interval, pxl_interval_nxt;
  reg [19:0] interval_count, interval_count_nxt;
  reg [19:0] interval_change, interval_change_nxt;
  reg [19:0] xtilt, xtilt_nxt;
  reg [19:0] ytilt, ytilt_nxt;
  
  
  always@(posedge pclk)
  begin
    if (rst)
    begin
      xpos <= 0;
      ypos <= 0;
      speed_count <= 0;
      pxl_interval <= 0;
      interval_count <= 0;
      interval_change <= 0;
      state <= IDLE;
    end
    
    else
    begin
      xpos <= xpos_nxt;
      ypos <= ypos_nxt;
      speed_count <= speed_count_nxt;
      speed_change_count <= speed_change_count_nxt;
      pxl_interval <= pxl_interval_nxt;
      interval_count <= interval_count_nxt;
      interval_change <= interval_change_nxt;
      state <= state_nxt;
      direction <= direction_nxt;
    end
  end
  
  
  always @*
  begin
    case (state)
      IDLE:			state_nxt = mouse_left ? MOVING : IDLE;
      MOVING:		state_nxt = mouse_left ? IDLE : /*((ypos < (DOWN_WALL - BALL_DIAMETER)) && (ypos > UP_WALL) && (xpos < RIGHT_WALL - BALL_DIAMETER) && (xpos > LEFT_WALL)) ?*/ MOVING /*: WALL*/;
//      WALL:			state_nxt = /*(speed_count < (INTERVAL_START / INTERVAL_CHANGE_START)) ? SPEED_UP :*/ MOVING;
//      SPEED_UP:		state_nxt = MOVING;
    default:
      state_nxt = IDLE;
    endcase

    
    case (state_nxt)
      IDLE: begin
        speed_count_nxt = 0;
        speed_change_count_nxt = 0;
        interval_count_nxt = 0;
        pxl_interval_nxt = INTERVAL_START;
        
        if(difficulty == 0) interval_change_nxt = INTERVAL_CHANGE_EASY;
        else interval_change_nxt = INTERVAL_CHANGE_HARD;
        
        xpos_nxt = CENTRAL_LINE;
        ypos_nxt = 43;
        direction_nxt = UPLEFT;
      end
      
      MOVING: begin
        if(interval_count == pxl_interval)
        begin
          interval_count_nxt = 0;
          interval_change_nxt = interval_change;
          speed_count_nxt = speed_count;
          speed_change_count_nxt = speed_change_count;
          direction_nxt = direction;
          
          case (direction)
            UPRIGHT: begin
              xpos_nxt = xpos + 1;
              ypos_nxt = ypos - 1;
            end
            
            DOWNRIGHT: begin
              xpos_nxt = xpos + 1;
              ypos_nxt = ypos + 1;
            end

            DOWNLEFT: begin
              xpos_nxt = xpos - 1;
              ypos_nxt = ypos + 1;
            end

            UPLEFT: begin
              xpos_nxt = xpos - 1;
              ypos_nxt = ypos - 1;
            end
            
            default: begin
              xpos_nxt = xpos + 1;
              ypos_nxt = ypos - 1;
            end
          endcase
          
          
          if((ypos >= (DOWN_WALL - BALL_DIAMETER)) || (ypos <= UP_WALL) || (xpos >= RIGHT_WALL - BALL_DIAMETER) || (xpos <= LEFT_WALL)) 
            begin 
  	        case (direction)
            UPRIGHT: begin 
              if (ypos < (UP_WALL + 1))
                direction_nxt = DOWNRIGHT;
              else if (xpos > (RIGHT_WALL - BALL_DIAMETER - 1))
                direction_nxt = UPLEFT;
            end
            
            DOWNRIGHT: begin
              if (ypos > (DOWN_WALL - BALL_DIAMETER - 1))
                direction_nxt = UPRIGHT;
              else if (xpos > (RIGHT_WALL - BALL_DIAMETER - 1))
                direction_nxt = DOWNLEFT;
            end

            DOWNLEFT: begin
              if (ypos > (DOWN_WALL - BALL_DIAMETER - 1))
                direction_nxt = UPLEFT;
              else if (xpos < (LEFT_WALL + 1))
                direction_nxt = DOWNRIGHT;
            end

            UPLEFT: begin
              if (ypos < (UP_WALL + 1))
                direction_nxt = DOWNLEFT;
              else if (xpos < (LEFT_WALL + 1))
                direction_nxt = UPRIGHT;
            end

            default: begin 
              if (ypos < (UP_WALL + 1))
                direction_nxt = DOWNRIGHT;
              else if (xpos > (RIGHT_WALL - BALL_DIAMETER - 1))
                direction_nxt = UPLEFT;
            end
            endcase
            
            if(speed_count < 9)
              begin
                if(speed_change_count > 4)
                  begin
                    interval_change_nxt = interval_change>>1;
                    pxl_interval_nxt = pxl_interval - interval_change;
                    speed_change_count_nxt = 0;
                    speed_count_nxt = speed_count + 1;
                  end
                else
                  begin
                    pxl_interval_nxt = pxl_interval - interval_change;
                    speed_change_count_nxt = speed_change_count + 1;
                  end
              end
            else
              pxl_interval_nxt = pxl_interval;
            end
          
          else if(((mouse_ypos >= (768 - WYSOKOSC)) && (ypos >= (768 - WYSOKOSC)) && (xpos == ODLEGLOSC)) || ((ypos >= mouse_ypos) && (ypos < (mouse_ypos + WYSOKOSC)) && (xpos == ODLEGLOSC))) begin
          		case (direction)
                      UPRIGHT: begin 
                          direction_nxt = UPLEFT;
                      end
                      
                      DOWNRIGHT: begin
                          direction_nxt = DOWNLEFT;
                      end
          
                      DOWNLEFT: begin
                          direction_nxt = DOWNRIGHT;
                      end
          
                      UPLEFT: begin
                          direction_nxt = UPRIGHT;
                      end
          
                      default: begin 
                          direction_nxt = direction;
                      end
                      endcase
                end
          
          else begin
//            pxl_interval_nxt = pxl_interval - interval_change;
            pxl_interval_nxt = pxl_interval;
            direction_nxt = direction;
            end
          end
        
          else
			begin
			  xpos_nxt = xpos;
			  ypos_nxt = ypos;
			  interval_count_nxt = interval_count + 1;
			  interval_change_nxt = interval_change;
			  pxl_interval_nxt = pxl_interval;
			  speed_count_nxt = speed_count;
			  speed_change_count_nxt = speed_change_count;
			  direction_nxt = direction;
  			end
  		end
  		
  		default: begin
  		  speed_count_nxt = 0;
  		  speed_change_count_nxt = 0;
  		  interval_count_nxt = 0;
  		  pxl_interval_nxt = INTERVAL_START;
  		  
          if(difficulty == 0) interval_change_nxt = INTERVAL_CHANGE_EASY;
  		  else interval_change_nxt = INTERVAL_CHANGE_HARD;
  		  
  		  xpos_nxt = CENTRAL_LINE;
  		  ypos_nxt = 21;
  		  direction_nxt = UPLEFT;
  		end
  	    endcase
  	  end


  	  
//  	  WALL: begin
//		speed_count_nxt = speed_count;
//  	    interval_count_nxt = 0;
//  	    interval_change_nxt = interval_change;
//  	    pxl_interval_nxt = pxl_interval;
//  	    xpos_nxt = xpos;
//  	    ypos_nxt = ypos;
  	    
//  	    case (direction)
//  	      UPRIGHT: begin 
//  	        if (ypos < (UP_WALL + 1))
//  	          direction_nxt = DOWNRIGHT;
//  	        else if (xpos > (RIGHT_WALL - 1))
//  	          direction_nxt = UPLEFT;
//  	      end
  	      
//  	      DOWNRIGHT: begin 
//  	        if (ypos > (DOWN_WALL - 1))
//  	          direction_nxt = UPRIGHT;
//  	        else if (xpos > (RIGHT_WALL - 1))
//  	          direction_nxt = DOWNLEFT;
//  	      end

//  	      DOWNLEFT: begin
//  	        if (ypos > (DOWN_WALL - 1))
//  	          direction_nxt = UPLEFT;
//  	        else if (xpos < (LEFT_WALL + 1))
//  	          direction_nxt = DOWNRIGHT;
//  	      end

//  	      UPLEFT: begin
//  	        if (ypos < (UP_WALL + 1))
//  	          direction_nxt = DOWNLEFT;
//  	        else if (xpos < (LEFT_WALL + 1))
//  	          direction_nxt = UPRIGHT;
//  	      end
//  	    endcase
//  	  end
  	  
//  	  SPEED_UP: begin
//  	      xpos_nxt = xpos;
//  	      ypos_nxt = ypos;
//  	      interval_count_nxt = 0;
//  	      interval_change_nxt = interval_change;
//  	      pxl_interval_nxt = pxl_interval - interval_change;
//  	      speed_count_nxt = speed_count + 1;
//  	  end
//    endcase
//  end

endmodule