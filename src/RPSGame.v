module RPSGame(player, clk, stop, clear, winner);
	input [1:0] player;
	input clk;
	input stop;
	input clear;
	
	output reg [1:0] winner;
	wire reg [1:0] computer;
	
	RPScounter rps(
			.clk(clk),
			.clear_b(clear),
			.stop(stop),
			.q([1:0]computer)
			);
	
	always @(stop)
	begin
		if (stop == 1`b0)
			winner_indicator wi (
					.player(player),
					.computer([1:0]computer),
					.winner(winner)
					);
	end
endmodule
	
module winner_indicator(player, computer, winner);
	// winner: 00 indicates player winning.
	//         01 indicates computer winning.
	//         11 indicates draw
	input [1:0] player;
	input [1:0] computer;
	output reg [1:0] winner;
	
	// scissor 00
	// rock 01
	// paper 10
	always @(*)
	begin
		// scissor vs scissor
		// draw
		if (player == 2b'00 && computer == 2b'00)
			winner <= 2b'11;
		// scissor vs rock
		// lose
		else if (player == 2b'00 && computer == 2b'01)
			winner <= 2b'01;
		// scissor vs paper
		// win
		else if (player == 2b'00 && computer == 2b'10)
			winner <= 2b'00;
		// rock vs rock
		// draw
		else if (player == 2b'01 && computer == 2b'01)
			winner <= 2b'11;
		// rock vs paper
		// lose
		else if (player == 2b'01 && computer == 2b'10)
			winner <= 2b'01;
		// rock vs scissor
		// win
		else if (player == 2b'01 && computer == 2b'00)
			winner <= 2b'00;
		// paper vs paper
		// draw
		else if (player == 2b'10 && computer == 2b'10)
			winner <= 2b'11;
		// paper vs scissor
		// lose
		else if (player == 2b'10 && computer == 2b'00)
			winner <= 2b'01;
		// paper vs rock
		// win
		else
			winner <= 2b'00;
	end
endmodule
		
module RPScounter(clk, clear_b, stop, q);
    input clk;
    input clear_b;
    input stop;
    output reg [1:0] q = 0;
    
    always @(posedge clk)
    begin
        if (stop == 1'b1)
	   		if (clear_b == 1'b0)
	        	q <= 0;
	    	else if (q == 2'b10)
	        	q <= 0;
	    	else
	        	q <= q + 1'b1;
    end
endmodule 