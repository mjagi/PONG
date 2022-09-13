//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_ball_ctl
 Author:        Mateusz Jagielski, Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-10
 Coding style: safe with FPGA sync reset
 Description:   module that controls movement of the ball
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module draw_ball_ctl (
  input wire pclk,
  input wire rst,
  input wire [9:0] mouse_ypos,
  input wire [11:0] mouse_ypos_sec,
  input wire mouse_left,
  input wire difficulty,
  input wire button,
  input wire start,

  output reg [11:0] xpos,
  output reg [11:0] ypos,
  output reg [1:0] score_p1,
  output reg [1:0] score_p2
  );

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------  
  localparam IDLE = 2'b00;
  localparam MOVING = 2'b01;
  localparam WALL = 2'b10;
  localparam SPEED_UP = 2'b11;
  
  localparam UPRIGHT = 2'b00;
  localparam DOWNRIGHT = 2'b01;
  localparam DOWNLEFT = 2'b10;
  localparam UPLEFT = 2'b11;
  
  localparam INTERVAL_START = 20'b1000_0000_0000_0000_0000;
  localparam INTERVAL_CHANGE_HARD = 20'b0000_1000_0000_0000_0000;
  localparam INTERVAL_CHANGE_EASY = 20'b0000_0000_0000_1000_0000;
  localparam BALL_DIAMETER = 16;

  localparam LEFT_WALL = 1;
  localparam RIGHT_WALL = 1022;
  localparam UP_WALL = 1;
  localparam DOWN_WALL = 766;
  
  localparam CENTRAL_LINE = 512;

  localparam RACKET_WIDTH = 10;
  localparam RACKET_LENGTH = 80;
  localparam RACKET_XPOS = 60;
  localparam RACKET_XPOS_SEC = 963;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------  
  reg [1:0] state, state_nxt, direction, direction_nxt;
  reg [11:0] speed_count, speed_count_nxt, speed_change_count, speed_change_count_nxt;
  reg [11:0] xpos_nxt, ypos_nxt;
  reg [19:0] pxl_interval, pxl_interval_nxt;
  reg [19:0] interval_count, interval_count_nxt;
  reg [19:0] interval_change, interval_change_nxt;
  reg [19:0] xtilt, xtilt_nxt;
  reg [19:0] ytilt, ytilt_nxt;
  reg [1:0] score_p1_nxt, score_p2_nxt;
  
//------------------------------------------------------------------------------
// output register
//------------------------------------------------------------------------------  
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
	  score_p1 <= 0;
	  score_p2 <= 0;
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
	  score_p1 <= score_p1_nxt;
	   score_p2 <= score_p2_nxt;
    end
  end
  
//------------------------------------------------------------------------------
// next state logic
//------------------------------------------------------------------------------  
  always @*
  begin
    case (state)
      IDLE:			state_nxt = (mouse_left && start) ? MOVING : IDLE;
      MOVING:		state_nxt = button ? IDLE : MOVING;
    default:
      state_nxt = IDLE;
    endcase

//------------------------------------------------------------------------------
// output logic
//------------------------------------------------------------------------------    
    case (state_nxt)
      IDLE: begin
            speed_count_nxt = 0;
            speed_change_count_nxt = 0;
            interval_count_nxt = 0;
            pxl_interval_nxt = INTERVAL_START;
            
            if (button) begin 
                    score_p1_nxt = 0;
                    score_p2_nxt = 0;
            end
            else begin
                    score_p1_nxt = score_p1;
                    score_p2_nxt = score_p2;
            end
        
            if(difficulty == 0) interval_change_nxt = INTERVAL_CHANGE_EASY;
            else interval_change_nxt = INTERVAL_CHANGE_HARD;
        
            xpos_nxt = CENTRAL_LINE;
            ypos_nxt = mouse_ypos;
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
          
          
                if((ypos >= (DOWN_WALL - BALL_DIAMETER)) || (ypos <= UP_WALL)) 
                begin 
                    score_p2_nxt = score_p2;
					score_p1_nxt = score_p1;
  	                case (direction)
                        UPRIGHT: begin                       
                            if (ypos < (UP_WALL + 1))
                                direction_nxt = DOWNRIGHT;
                        end
            
                        DOWNRIGHT: begin
                            if (ypos > (DOWN_WALL - BALL_DIAMETER - 1))
                                direction_nxt = UPRIGHT;
                        end

                        DOWNLEFT: begin
                            if (ypos > (DOWN_WALL - BALL_DIAMETER - 1))
                                direction_nxt = UPLEFT;
                        end

                        UPLEFT: begin
                            if (ypos < (UP_WALL + 1))
                                direction_nxt = DOWNLEFT;
                        end

                        default: begin 
                            if (ypos < (UP_WALL + 1))
                                direction_nxt = DOWNRIGHT;
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
					
				else if (xpos <= LEFT_WALL)	begin
					state_nxt = IDLE;
                    pxl_interval_nxt = INTERVAL_START;
                    score_p1_nxt = score_p1;
					if (score_p2 == 3)score_p2_nxt = score_p2;
					
					else score_p2_nxt = score_p2 + 1;
				
				end
				
				else if (xpos >= RIGHT_WALL - BALL_DIAMETER)	begin
					state_nxt = IDLE;
                    pxl_interval_nxt = INTERVAL_START;
                    score_p2_nxt = score_p2;
					if (score_p1 == 3)score_p1_nxt = score_p1;
					
					else score_p1_nxt = score_p1 + 1;
				
				end
				
				// LEFT RACKET
                else if((ypos >= (mouse_ypos - BALL_DIAMETER)) && (ypos <= (mouse_ypos + RACKET_LENGTH)) && (xpos == RACKET_XPOS)) begin
                    pxl_interval_nxt = pxl_interval;
                    score_p2_nxt = score_p2;
					score_p1_nxt = score_p1;
          		    case (direction)          
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
                
                // RIGHT RACKET
                else if((ypos >= (mouse_ypos_sec - BALL_DIAMETER)) && (ypos <= (mouse_ypos_sec + RACKET_LENGTH)) && (xpos == RACKET_XPOS_SEC - BALL_DIAMETER - 1)) begin
                    pxl_interval_nxt = pxl_interval;
                    score_p2_nxt = score_p2;
					score_p1_nxt = score_p1;
          		    case (direction)
                        UPRIGHT: begin 
                            direction_nxt = UPLEFT;
                        end
                      
                        DOWNRIGHT: begin
                            direction_nxt = DOWNLEFT;
                        end

                        default: begin 
                            direction_nxt = direction;
                        end
                    endcase
                end
          
                else begin
                    pxl_interval_nxt = pxl_interval;
                    direction_nxt = direction;
                    score_p2_nxt = score_p2;
					score_p1_nxt = score_p1;
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
			     score_p2_nxt = score_p2;
				 score_p1_nxt = score_p1;
  		    end
  		end
  		
  		default: begin
  		    speed_count_nxt = 0;
  		    speed_change_count_nxt = 0;
  		    interval_count_nxt = 0;
  		    pxl_interval_nxt = INTERVAL_START;
			score_p2_nxt = score_p2;
			score_p1_nxt = score_p1;
  		  
            if(difficulty == 0) interval_change_nxt = INTERVAL_CHANGE_EASY;
  		    else interval_change_nxt = INTERVAL_CHANGE_HARD;
  		  
  		    xpos_nxt = CENTRAL_LINE;
  		    ypos_nxt = mouse_ypos;
  		    direction_nxt = UPLEFT;
  		end
  	    endcase
  	end

endmodule