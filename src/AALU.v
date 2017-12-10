// Advanced ALU.
// The main function is to compare two values and subtract them accordingly.

module AALU(x, y, lose, bonus);
	// x: first input
	// y: second input
	// lose: if 1, the player loses the game.
	// bonus: the achieved points.
	input [4:0] x;
	input [4:0] y;
	output reg [4:0] bonus;
	output lose;
	wire reg [4:0] greater
	wire reg [4:0] lower;
	
	comparator comp(
			.x(x[4:0]),
			.y(y[4:0]),
			.greater(greater[4:0]),
			.lower(lower[4:0]),
			.same(lose)
			);
	
	subtractor(
			.operandone(greater[4:0]),
			.operandtwo(lower[4:0]),
			.result(bonus[4:0])
			);

endmodule
	

module comparator(x, y, greater, lower, same);
	input [4:0] x;
	input [4:0] y;
	output reg [4:0] greater;
	output reg [4:0] lower;
	output reg same;
	
	always @(*)
		begin
		if (x > y)
			begin
			greater <= x;
			lower <= y;
			same <= 1b'0;
			end
		else if (x < y)
			begin
			greater <= y;
			lower <= x;
			same <= 1b'0;
			end
		else
			begin
			greater <= 5b'00000;
			lower <= 5b'00000;
			same <= 1b'1;
			end
	end
endmodule

module subtractor(operandone, operandtwo, result);
// For better readability, verilog operation used.
    input [4:0] operandone;
    input [4:0] operandtwo;
    output [4:0] result;

    result <= operandone - operandtwo;
    
endmodule

module register(data_in, resetn, clk, data_result);
    input [4:0] data_in;
    input resetn;
    input clk;
    output reg [4:0] data_result;

    always@(posedge clk) begin
        if (!resetn) begin
            data_result <= 5'b00000;
        end
        else
            data_result <= data_in;
    end
endmodule


		