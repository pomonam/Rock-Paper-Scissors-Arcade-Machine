`timescale 1ns / 1ns // `timescale time_unit/time_precision

module top(SW, KEY, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
        input CLOCK_50;
        input [3:0] KEY;
        input [9:0] SW;
	 
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;

	 wire load_left, load_right, load_user;
	 
	 wire [1:0] status;
	 wire three_wins;
	 
	 wire same_leftright;
	 wire [1:0] consecutive_win;
	 wire enable_winner_indicator;
	 wire [1:0] computer;
	 wire enable_aalu;
	 wire [4:0] score;
	 reg enable_high_score;
	 wire clear_done;
	 reg return_to_load_left;
	 reg go_to_get_user;
	 wire plot;
	 wire [2:0] color;
	 wire [7:0] x;
	 wire [6:0] y;
	 wire clk; 
	 
	 //wire [4:0] score;
	 wire [5:0] current_state; //remove this!!
	// winner: 00 indicates player winning.
	//         01 indicates computer winning.
	//         11 indicates draw
	 control cont (
	             
	             .clk(clk), //inputs
	             .resetn(KEY[3]),
	             .confirm(SW[2:2]),
	             .status(status[1:0]),
	             .return_to_load_left(return_to_load_left),
	             .go_to_get_user(go_to_get_user),
	             .stop_left(KEY[2]),
	             .stop_right(KEY[0]),
	             .stop_user(KEY[1]),
	             .enable_winner_indicator(enable_winner_indicator),
	             .enable_aalu(enable_aalu),
	             .ld_user(load_user),
	             .ld_left(load_left),
	             .ld_right(load_right),
	             .curr_state(current_state[5:0]), //remove!!!!
	             .opponent(computer[1:0]), //outputs
	             .plot(plot),
	             .color(color[2:0]),
	             .xOut(x),
	             .yOut(y)
	             );
	             
	 data data (
	             .clk(clk),
	             .load_left(load_left),
	             .load_right(load_right),
	             .stop_left(KEY[2]),
	             .stop_right(KEY[0]),
	             .resetn(KEY[3]),
	             .enable_aalu(enable_aalu),
	             .enable_winner_indicator(enable_winner_indicator),
	             .load_user(load_user),
	             .user_input_player(SW[1:0]),
	             .computer(computer[1:0]),
	             .HEX0(HEX0[6:0]),
	             .HEX1(HEX1[6:0]),
	             .HEX4(HEX4[6:0]),
	             .HEX5(HEX5[6:0]),
	             .LEDR(LEDR[9:8]),
	             .score(score[4:0]),
	             
	             .status(status[1:0]),
	             .same_leftright(same_leftright)
	             );

	
	             
    assign LEDR[7:3] = score[4:0];
	 assign LEDR[1:0] = consecutive_win[1:0];
    always@(*)
    begin
        if (same_leftright == 1'b1 || status == 2'b01)
            return_to_load_left <= 1'b1;
        else
            return_to_load_left <= 1'b0;
    end
	 
	 
    SevenSegment seg(
	     .HEXleft(HEX3[6:0]),
		  .HEXright(HEX2[6:0]),
		  .num({3'b000 ,consecutive_win[1:0]})
		  );
    
	 ratedivider rd (
	     .clk(CLOCK_50),
		  .clear_b(KEY[3]),
		  .out(clk)
		  );
		  
    always@(posedge three_wins)
    begin
        if (three_wins == 1'b1)
            enable_high_score <= 1'b1;
        else
            enable_high_score <= 1'b0;
    end
    
    //always@(posedge enable_high_score)
        
    consecutive_win_counter cwc (
                .clk(clk),
		.clear_b(KEY[3]),
		.q(consecutive_win),
		.enable(status[1:0]),
		.three_wins(three_wins)
		);
	 
    endmodule	 
	 

module data(load_left, load_right, user_input_player, computer, load_user, enable_aalu,enable_winner_indicator,
clk, stop_left, stop_right, resetn, HEX0, HEX1, HEX4, HEX5, LEDR, status, same_leftright, score);

    
	input load_left, load_right, clk, stop_left, stop_right, resetn, enable_aalu, enable_winner_indicator, load_user;
	input [1:0] user_input_player;
	input [1:0] computer;
	reg [1:0] player;
	output [6:0] HEX0, HEX1, HEX4, HEX5;
	output [9:8] LEDR;
        output [4:0] score;
        output [1:0] status;
        output reg same_leftright;
        
	wire [4:0] left;
	wire [4:0] right;
	wire lose;
	wire [4:0] bonus;
        wire [1:0] winner;

counter left_counter(

            .clk(clk),

            .clear_b(resetn),

            .enable(load_left),

            .stop(stop_left),

            .q(left[4:0])

            );

    counter right_counter(

            .clk(clk),

            .clear_b(resetn),

            .enable(load_right),

            .stop(stop_right),
 
            .q(right[4:0])

            );
				
	 AALU aalu(              
	         .x(left[4:0]),
	         .y(right[4:0]),
	         .lose(lose),
	         .bonus(bonus[4:0]),
	         .enable(enable_aalu)	
	         );
		  
	 always @(*)
	 begin
	     if (lose == 1'b1)
		      same_leftright <= 1'b1;
		  else
		      same_leftright <= 1'b0;
	 end
	 
	 always @(*)
	 begin
	     if (load_user == 1'b1)
	         player <= user_input_player;
	 end
	 
	 winner_indicator wi (
	     .player(player[1:0]),
	     .computer(computer[1:0]),
	     .winner(winner[1:0]),
	     .enable(enable_winner_indicator)
	     );

    SevenSegment display_left (
        .HEXleft(HEX5[6:0]),
        .HEXright(HEX4[6:0]),
        .num(left[4:0])
        );
    
    SevenSegment display_right (
        .HEXleft(HEX1[6:0]),
        .HEXright(HEX0[6:0]),
        .num(right[4:0])
        );
    
    
	
	// Assign the light if and only if the player won.
	assign score[4:0] = bonus[4:0];
	assign LEDR[9:8] = winner[1:0];
	assign status[1:0] = winner[1:0];
	
endmodule

`timescale 1ns / 1ns // `timescale time_unit/time_precision

module control(confirm, clk, resetn, ld_user, enable_aalu, ld_left, ld_right, stop_left, stop_right, stop_user, status,
return_to_load_left, go_to_get_user, curr_state, plot, color, xOut, yOut, opponent, enable_winner_indicator);
	input clk, resetn;
	input confirm;
	input [1:0] status;
	input return_to_load_left;
        input stop_left, stop_right, stop_user;
        input go_to_get_user;
        output reg enable_winner_indicator;
	output reg ld_user, ld_left, ld_right;
	output [5:0] curr_state; //remove this!!
	reg [1:0] current_opponent;	
	output reg [1:0] opponent;
	reg[5:0] current_state, next_state;
	reg enable_counter_clear, enable_counter_fill;
	output reg plot;

	reg [7:0] initialX_rock = 80;
	reg [6:0] initialY_rock = 40;
	reg [7:0] initialX_scissors = 110;
	reg [6:0] initialY_scissors = 80;
	reg [7:0] initialX_paper = 50;
	reg [6:0] initialY_paper = 80;
	output reg [2:0] color;
	output reg [7:0] xOut;
	output reg [6:0] yOut;
	output reg enable_aalu;
	wire [3:0] counter_count_fill, counter_count_clear;
	wire fill_done, clear_done;
	
	
	// scissor 00
	// rock 01
	// paper 10
	
	// winner: 00 indicates player winning.
	//         01 indicates computer winning.
	//         11 indicates draw
	//         10 normal state
	
	localparam LOAD_LEFT = 5'd0,
		   LOAD_LEFT_WAIT = 5'd1,
		   LOAD_RIGHT = 5'd2,
		   LOAD_RIGHT_WAIT = 5'd3,
		   GET_USER = 5'd4,
		   DRAW_SQUARE_ROCK = 5'd5,
		   CLEAR_SCISSORS = 5'd6,
		   DRAW_SQUARE_PAPER = 5'd7,
		   CLEAR_ROCK = 5'd8,
		   DRAW_SQUARE_SCISSORS = 5'd9,
		   CLEAR_PAPER = 5'd10,
		   COMPARE = 5'd11;
		  


	assign curr_state[5:0] = current_state[5:0];
	
	always@(*)
	begin: state_table
		case(current_state)
			LOAD_LEFT: next_state = ~stop_left? LOAD_LEFT_WAIT : LOAD_LEFT;
			LOAD_LEFT_WAIT: next_state = ~stop_left? LOAD_LEFT_WAIT : LOAD_RIGHT;
			LOAD_RIGHT : next_state = ~stop_right? LOAD_RIGHT_WAIT: LOAD_RIGHT;
			LOAD_RIGHT_WAIT: next_state = ~stop_right? LOAD_RIGHT_WAIT: GET_USER;
			GET_USER: next_state = (confirm == 1'b1)? DRAW_SQUARE_ROCK: GET_USER;
			DRAW_SQUARE_ROCK: if (fill_done == 1'b1) begin
								           next_state <= CLEAR_SCISSORS;
								   end else begin
									         next_state <= DRAW_SQUARE_ROCK;
									end
			CLEAR_SCISSORS: if (stop_user == 1'b0 && fill_done == 1'b1) begin
			                          next_state <= COMPARE;
									end else if (stop_user == 1'b1 && fill_done == 1'b1) begin
								           next_state <= DRAW_SQUARE_PAPER;
								   end else begin
									         next_state <= CLEAR_SCISSORS;
									end
			
			DRAW_SQUARE_PAPER: if (fill_done == 1'b1) begin
								           next_state <= CLEAR_ROCK;
								   end else begin
									         next_state <= DRAW_SQUARE_PAPER;
									end
			
			CLEAR_ROCK: if (stop_user == 1'b0 && fill_done == 1'b1) begin
			                          next_state <= COMPARE;
									end else if (stop_user == 1'b1 && fill_done == 1'b1) begin
								           next_state <= DRAW_SQUARE_SCISSORS;
								   end else begin
									         next_state <= CLEAR_ROCK;
									end
			
			DRAW_SQUARE_SCISSORS: if (fill_done == 1'b1) begin
								           next_state <= CLEAR_PAPER;
								   end else begin
									         next_state <= DRAW_SQUARE_SCISSORS;
									end
			
			CLEAR_PAPER: if (stop_user == 1'b0 && fill_done == 1'b1) begin
			                          next_state <= COMPARE;
									end else if (stop_user == 1'b1 && fill_done == 1'b1) begin
								           next_state <= DRAW_SQUARE_ROCK;
								   end else begin
									         next_state <= CLEAR_PAPER;
									end
			COMPARE: next_state = (status == 2'b00 || status == 2'b11)? GET_USER: LOAD_LEFT;
			default: next_state = LOAD_LEFT;
		endcase
	end
	
	always @(posedge clear_done) begin
	   if (stop_user == 1'b0) begin
	        opponent <= current_opponent;
	        
	    end   
	end
	

	    
	always @(*)
	begin: enable_signals
		ld_left = 1'b0;
		ld_right = 1'b0;
		ld_user = 1'b0;
		enable_aalu = 1'b0;
		plot = 1'b0;
		enable_counter_fill = 1'b0;
		
		enable_winner_indicator = 1'b0;
		
		  
		case (current_state)
		   LOAD_LEFT: begin
			ld_left <= 1'b1;
			end
		   LOAD_RIGHT: begin
		   ld_right <= 1'b1;
		   enable_aalu <= 1'b1;
			end
	           GET_USER: begin
	           ld_user <= 1'b1;
	           end
	           DRAW_SQUARE_ROCK: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b001;
	                plot = 1'b1;
	                xOut <= initialX_rock + counter_count_fill[1:0];
	                yOut <= initialY_rock + counter_count_fill[3:2];
	                current_opponent <= 2'b00;
	                end
	           CLEAR_SCISSORS: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b000;
	                plot = 1'b1;
	                xOut <= initialX_scissors + counter_count_fill[1:0];
	                yOut <= initialY_scissors + counter_count_fill[3:2];
	                current_opponent <= 2'b00;
	                end
	           DRAW_SQUARE_PAPER: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b001;
	                plot = 1'b1;
	                xOut <= initialX_paper + counter_count_fill[1:0];
	                yOut <= initialY_paper + counter_count_fill[3:2];
	                current_opponent <= 2'b01;
	                end
	           CLEAR_ROCK: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b000;
	                plot = 1'b1;
	                xOut <= initialX_rock + counter_count_fill[1:0];
	                yOut <= initialY_rock + counter_count_fill[3:2];
	                current_opponent <= 2'b01;
	                end
	           DRAW_SQUARE_SCISSORS: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b001;
	                plot = 1'b1;
	                xOut <= initialX_scissors + counter_count_fill[1:0];
	                yOut <= initialY_scissors + counter_count_fill[3:2];
	                current_opponent <= 2'b10;
	                end
	           CLEAR_PAPER: begin
	                enable_counter_fill = 1'b1;
	                color = 3'b000;
	                plot = 1'b1;
	                xOut <= initialX_paper + counter_count_fill[1:0];
	                yOut <= initialY_paper + counter_count_fill[3:2];
	                current_opponent <= 2'b10;
	                end
	           COMPARE: begin
	                enable_winner_indicator <= 1'b1;
	                end
		endcase
        end
        //always@(*)
        //begin
        //    if (return_to_load_left == 1'b1)
        //        current_state <= LOAD_LEFT;
        //end
	
    // State Registers
	always @(posedge clk)
	begin: state_FFs
		if (resetn == 1'b0)
		    current_state <= LOAD_LEFT; // Should set reset state to state A.
		else
		    current_state <= next_state;
	end // state register
	
	counter4Bit drawCount(
	        .clock(clk),
	        .reset(resetn),
	        .enable(enable_counter_fill),
	        .count(counter_count_fill[3:0]),
	        .count_done(fill_done)
	        );
	        
	//counter4Bit drawCount2(
	//        .clock(clk),
	 //       .reset(resetn),
	  //      .enable(enable_counter_clear),
	  //      .count(counter_count_clear[3:0]),
	   //     .count_done(clear_done)
	   //     );
	        
	   
endmodule

module counter(clk, clear_b, stop, q, enable);
    input clk;
    input clear_b;
    input enable;
    input stop;
    output reg [4:0] q = 0;
    
    always @(posedge clk)
    begin
        if (stop == 1'b1 && enable == 1'b1)
        	begin
	    	if (clear_b == 1'b0)
	        	q <= 0;
	    	else if (q == 5'b10100)
	        	q <= 0;
	    	else
	        	q <= q + 1'b1;
	        end
    end
endmodule

module counter4Bit(clock, reset, enable, count, count_done);
	input clock;
	input reset, enable;
	
	output reg [3:0] count;
	output reg count_done;
	
	
	always@ (posedge clock) begin
		if(reset == 0) begin
			count<=0;
			count_done <= 1'b0;
			end
			
	        else if(count == 4'b1111) begin
	            count <= 4'b0000;
	            count_done <= 1'b1;
	            end
		else if(enable) begin
			count<= count+1;
			count_done <= 1'b0;
			end
	        else 
	            count_done <= 1'b0;
	end
endmodule

module consecutive_win_counter(clk, clear_b, q, enable, three_wins);
    input clk;
    input clear_b;
    input [1:0] enable;
    output reg [1:0] q = 0;
    output reg three_wins = 0;
    
    always @(negedge enable)
    begin
        if (enable == 2'b00) //if player wins update counter.
        begin
	    if (clear_b == 1'b0) begin
	        	q <= 0;
	        	three_wins <= 1'b0;
	        	end
	    else if (q == 2'b11) begin
	        	q <= 0;
	        	three_wins <= 1'b1;
	        	end
	    else
	    	begin
	        	q <= q + 1'b1;
	        	three_wins <= 1'b0;
	        end
	  end
end
endmodule
    

module d_ff(reg_input, reg_output, clk, reset);
// D flip flop.
    input reg_input;
    output reg reg_output;
    input clk;
    input reset;

    always @(posedge clk)
    begin
        if (reset == 1'b1)
            reg_output <= 1'b0;
        else
            if (reg_input >= reg_output)
                reg_output <= reg_input;
    end
endmodule

module AALU(x, y, lose, bonus, enable);
	// x: first input
	// y: second input
	// lose: if 1, the player loses the game.
	// bonus: the achieved points.
	input [4:0] x;
	input [4:0] y;
	input enable;
	output [4:0] bonus;
	output lose;
	wire [4:0] greater;
	wire [4:0] lower;
	
	comparator comp(
			.x(x[4:0]),
			.y(y[4:0]),
			.greater(greater[4:0]),
			.enable(enable),
			.lower(lower[4:0]),
			.same(lose)
			);
	
	subtractor sub(
			.operandone(greater[4:0]),
			.operandtwo(lower[4:0]),
			.enable(enable),
			.result(bonus[4:0])
			);

endmodule

module comparator(x, y, greater, lower, same, enable);
	input [4:0] x;
	input [4:0] y;
	output reg [4:0] greater;
	input enable;
	output reg [4:0] lower;
	output reg same;
	
	always @(*)
		begin
		if (enable == 1'b1)
			if (x > y)
				begin
					greater <= x;
				lower <= y;
				same <= 1'b0;
				end
			else if (x < y)
				begin
				greater <= y;
				lower <= x;
				same <= 1'b0;
				end
			else
				begin
				greater <= 5'b00000;
				lower <= 5'b00000;
				same <= 1'b1;
				end
		
	end
endmodule

module subtractor(operandone, operandtwo, result, enable);
// For better readability, verilog operation used.
    input [4:0] operandone;
    input [4:0] operandtwo;
	 input enable;
    output reg [4:0] result;
    always@(*) begin
	 if (enable == 1'b1)
	    result <= operandone - operandtwo;
    end
    
endmodule

module SevenSegment(HEXleft, HEXright, num);
	// This is a seven HEX decoder. It receives 5-bit input and
	// decodes into two seven segment.
	output reg [6:0] HEXleft, HEXright;
	input [4:0] num;
 
	always @(num) begin
		case (num)
    	// Digit 0
    	5'b00000: begin
    	HEXleft = 7'b100_0000;
    	HEXright = 7'b100_0000;
      	end
      	// Digit 1
      	5'b00001: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b111_1001;
      	end
      	// Digit 2
      	5'b00010: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b010_0100;
      	end
      	// Digit 3
      	5'b00011: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b011_0000;
      	end
      	// Digit 4
      	5'b0100: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b001_1001;
      	end
      	// Digit 5
      	5'b00101: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b001_0010;
      	end
      	// Digit 6
      	5'b00110: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b000_0010;
      	end
      	// Digit 7
      	5'b00111: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b111_1000;
      	end
      	// Digit 8
      	5'b01000: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b000_0000;
      	end
      	// Digit 9
      	5'b01001: begin
      	HEXleft = 7'b100_0000;
      	HEXright = 7'b001_1000;
      	end
      	// Digit 10.
      	5'b01010: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b100_0000;
      	end
      	// Digit 11.
      	5'b01011: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b111_1001;
      	end
      	// Digit 12
      	5'b01100: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b010_0100;
      	end
      	// Digit 13
      	5'b01101: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b011_0000;
      	end
      	// Digit 14
      	5'b01110: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b001_1001;
      	end
      	// Digit 15
      	5'b01111: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b001_0010;
      	end
      	// Digit 16
      	5'b10000: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b000_0010;
      	end
      	// Digit 17
      	5'b10001: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b111_1000;
      	end
      	// Digit 18
      	5'b10010: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b000_0000;
      	end
      	// Digit 19
      	5'b10011: begin
      	HEXleft = 7'b111_1001;
      	HEXright = 7'b001_1000;
      	end
      	// Digit 20
      	5'b10100: begin
      	HEXleft = 7'b010_0100;
      	HEXright = 7'b100_0000;
      	end
      	// Default case will show 88.
      	// This case should not be displayed and handled in datapath module.
		default: begin
		HEXleft = 7'b0000000;
		HEXright = 7'b0000000;
		end
	endcase
end
endmodule

module RPSGame(player, clk, stop, clear, winner, enable);
	input [1:0] player;
	input clk;
	input enable;
	input stop;
	input clear;
	
	output [1:0] winner;
	wire [1:0] computer;
	
	RPScounter rps(
			.clk(clk),
			.clear_b(clear),
			.stop(stop),
			.enable(enable),
			.q(computer[1:0])
			);
	
	
	winner_indicator wi (
			.player(player),
			.computer(computer[1:0]),
			.stop(stop),
			.winner(winner)
			);

endmodule
	
module winner_indicator(player, computer, winner, enable);
	// winner: 00 indicates player winning.
	//         01 indicates computer winning.
	//         11 indicates draw
	input [1:0] player;
	input [1:0] computer;
	input enable;
	output reg [1:0] winner;
	
	// scissor 00
	// rock 01
	// paper 10
	always @(*)
	begin
	   if (enable == 1'b1)
		// scissor vs scissor
		// draw
			if (player == 2'b00 && computer == 2'b00)
				winner <= 2'b11;
		// scissor vs rock
		// lose
			else if (player == 2'b00 && computer == 2'b01)
				winner <= 2'b01;
		// scissor vs paper
		// win
			else if (player == 2'b00 && computer == 2'b10)
				winner <= 2'b00;
		// rock vs rock
		// draw
			else if (player == 2'b01 && computer == 2'b01)
				winner <= 2'b11;
		// rock vs paper
		// lose
			else if (player == 2'b01 && computer == 2'b10)
				winner <= 2'b01;
		// rock vs scissor
		// win
			else if (player == 2'b01 && computer == 2'b00)
				winner <= 2'b00;
		// paper vs paper
		// draw
			else if (player == 2'b10 && computer == 2'b10)
				winner <= 2'b11;
		// paper vs scissor
		// lose
			else if (player == 2'b10 && computer == 2'b00)
				winner <= 2'b01;
		// paper vs rock
		// win
			else
				winner <= 2'b00;
		else
		    winner <= 2'b11;
		
	end
endmodule

module ratedivider(clear_b, clk, out);

    input clear_b;
    input clk;
    output out;

    reg [30:0] q;
    reg [30:0] t = 125000;
	                 
    assign out = (q == 0) ? 1 : 0;
    
 

    always @(posedge clk)
    begin
        if (clear_b == 1'b0)
            q <= t;
        else if (q == 1'b0)
            q <= t;
        else
            q <= q - 1'b1;
    end
endmodule    

module RPScounter(clk, clear_b, stop, q, enable);
    input clk;
    input clear_b;
    input stop;
	 input enable;
    output reg [1:0] q = 0;
    
    always @(posedge clk && enable == 1'b1)
    begin
        if (stop == 1'b1)
	   		if (clear_b == 1'b0)
	        	q <= 0;
	    	else if (q == 2'b10)
	        	q <= 0;
	    	else
	        	q <= q + 1'b1;
	else
	    q <= q;
    end
endmodule
