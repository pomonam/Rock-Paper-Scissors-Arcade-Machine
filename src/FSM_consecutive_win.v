module consecutive_win(signal, reset, clk, light_output, status);
	// FSM that examines whether the player won 3 games in a row.
	// signal[1:0] controls the FSM input.
	input [1:0] signal;
	input reset;
	input clk;
	// For each light, it specifies the number of consecutive victories.
	output [2:0] light_output;
	output [1:0] status;
	// Output specification
	// State E, F -> output: 00 Game Over, Dead State
	// State A, B, C -> output: 01 Game in Progress
	// state D -> output: 11 Game Won
	wire w;
	
	reg [2:0] y_Q, Y_D; //y_Q represents current state, y_D represents next state.
	
	localparam A = 3'b000, B = 3'b001, C = 3'b011, D = 3'b111, E = 3'b101, F = 3'b010;
	
	assign w[1:0] = signal[1:0];
	// For signal[1:0], followings are the input definitions.
	// 00: Lose
	// 01: Draw
	// 11: Win
	
	//State table
	always@(*)
	begin: state_table
		case (y_Q)
			A: begin
					if (w == 2'b00) Y_D <= F;
					else if (w == 2'01) Y_D <= A;
					else Y_D <= B;
				end
			B: begin
					if (w == 2'b00) Y_D <= E;
					else if (w == 2'b01) Y_D <= B;
					else Y_D <= C;
				end
			C: begin
					if (w == 2'b00) Y_D <= F;
					else if (w == 2'b01) Y_D <= C;
					else Y_D <= D;
				end
			D: begin
					Y_D <= D; // Stay in the current state until reset.
				end
			E: begin
					Y_D <= E;
				end
			F: begin
					Y_D <= F;
				end
			default: Y_D = A;
		endcase
	end // State table.
	
	// State Registers
	always @(posedge clk)
	begin: state_FFs
		if (reset == 1'b0)
			y_Q <= A; // Should set reset state to state A.
		else
			y_Q <= Y_D;
	end // state register
	
	// Output Logic
	// Set out_light to 1 to turn on LED when in relevant states
	always @(*)
	begin: output_logic
		case(y_Q)
			A: begin
					light_output[0] <= 1'b0;
					light_output[1] <= 1'b0;
					light_output[2] <= 1'b0;
					status <= 2'b01; // Game in progress.
				end
			B: begin
					light_output[0] <= 1'b0;
					light_output[1] <= 1'b0;
					light_output[2] <= 1'b1;
					status <= 2'b01; // Game in progress.
				end
			C: begin
					light_output[0] <= 1'b0;
					light_output[1] <= 1'b1;
					light_output[2] <= 1'b1;
					status <= 2'b01; // Game in progress.
				end
			D: begin
					light_output[0] <= 1'b1;
					light_output[1] <= 1'b1;
					light_output[2] <= 1'b1;
					status <= 2'b11; // Game won.
				end
			E: begin
					light_output[0] <= 1'b1;
					light_output[1] <= 1'b1;
					light_output[2] <= 1'b1;
					status <= 2'b00; // Game lost.
				end
			F: begin
					light_output[0] <= 1'b1;
					light_output[1] <= 1'b1;
					light_output[2] <= 1'b1;
					status <= 2'b00; // Game lost.
				end
			default: begin
					light_output[0] <= 1'b0;
					light_output[1] <= 1'b0;
					light_output[2] <= 1'b0;
					status <= 2'b00;
				end
		endcase
	end // output_logic