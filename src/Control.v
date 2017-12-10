`timescale 1ns / 1ns // `timescale time_unit/time_precision

module control(clk, resetn, ld_user, ld_left, ld_right, stop_left, stop_right, stop_rps);
	input clk, resetn;
        input stop_left, stop_right, stop_rps;
	output reg ld_user, ld_left, ld_right;
	reg[5:0] current_state, next_state;
	localparam LOAD_LEFT = 5'd0,
		   LOAD_LEFT_WAIT = 5'd1,
		   LOAD_RIGHT = 5'd2,
		   LOAD_RIGHT_WAIT = 5'd3,
		   LOAD_USER = 5'd4,
		   LOAD_USER_WAIT = 5'd5;
			// add some cycles later
	always@(*)
	begin: state_table
		case(current_state)
			LOAD_LEFT: next_state = ~stop_left? LOAD_LEFT_WAIT : LOAD_LEFT;
			LOAD_LEFT_WAIT: next_state = ~stop_left? LOAD_LEFT_WAIT : LOAD_RIGHT;
			LOAD_RIGHT : next_state = ~stop_right? LOAD_RIGHT_WAIT: LOAD_RIGHT;
			LOAD_RIGHT_WAIT: next_state = ~stop_right? LOAD_RIGHT_WAIT: LOAD_USER;
			LOAD_USER: next_state = ~stop_rps? LOAD_USER_WAIT: LOAD_USER;
			//LOAD_USER_WAIT: next_state = ~stop_rps? // some cycle;
			default: next_state = LOAD_LEFT;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		ld_left = 1'b0;
		ld_right = 1'b0;
		ld_user = 1'b0;
		  
		case (current_state)
		    LOAD_LEFT: begin
			ld_left = 1'b1;
			end
		    LOAD_RIGHT: begin
		    	ld_right = 1'b1;
			end
		    LOAD_USER: begin
			ld_user = 1'b1;
			end
			// Incomplete
		endcase
        end
    
    // State Registers
	always @(posedge clk)
	begin: state_FFs
		if (resetn == 1'b0)
		    current_state <= LOAD_LEFT; // Should set reset state to state A.
		else
		    current_state <= next_state;
	end // state register
endmodule