//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_cred_ctl
 Author:        Mateusz Jagielski, Bartosz Białkowski
 Version:       1.0
 Last modified: 2022-09-08
 Coding style: safe with FPGA sync reset
 Description:
 */
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module draw_cred_ctl (
  input wire pclk,
  input wire rst,
  input wire mouse_left,

  output reg [11:0] xpos,
  output reg [11:0] ypos
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
  localparam INTERVAL_CHANGE_EASY = 20'b0000_0000_0000_1000_0000;
  localparam BALL_DIAMETER = 128;

  localparam LEFT_WALL = 1;
  localparam RIGHT_WALL = 1022;
  localparam UP_WALL = 1;
  localparam DOWN_WALL = 766;
  
  localparam CENTRAL_LINE = 511;

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
  
//------------------------------------------------------------------------------
// next state logic
//------------------------------------------------------------------------------    
  always @*
  begin
    case (state)
      IDLE:			state_nxt = mouse_left ? MOVING : IDLE;
      MOVING:		state_nxt = mouse_left ? IDLE : MOVING;
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
			interval_change_nxt = INTERVAL_CHANGE_EASY;        
            xpos_nxt = CENTRAL_LINE;
            ypos_nxt = 40;
            direction_nxt = UPRIGHT;
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
          
                else begin
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
			interval_change_nxt = INTERVAL_CHANGE_EASY;	  
  		    xpos_nxt = CENTRAL_LINE;
  		    ypos_nxt = 40;
  		    direction_nxt = UPRIGHT;
  		end
  	    endcase
  	end

endmodule