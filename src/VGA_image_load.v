module VGA
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK		
		VGA_SYNC_N,						//	VGA SYNC			
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),	
			.VGA_SYNC(VGA_SYNC_N),			
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.mono.mif";
			
	// Should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	wire counterReset;
	wire counterEnable;
	wire resetRegisters;
	wire [3:0] counterCount;
	
	wire loadX;
	wire loadY;
	
	// Instansiate FSM control
	// control c0(...);
	control c(counterCount, CLOCK_50, KEY[3:0], counterEnable, counterReset, resetRegisters, loadX, loadY, writeEn); 
	
	// Increment the counter
	counter4Bit c4b(CLOCK_50, counterReset, counterEnable, counterCount);					
	
	// Instansiate datapath
	// datapath d0(...);
	datapath d(CLOCK_50, SW[9:7], SW[6:0], counterCount, loadX, loadY, resetRegisters, y, x, colour);
	
endmodule


module datapath(clock, color, swIn, counterCount, loadX, loadY, resetRegisters, yOut, xOut, colorOut);
	
	input clock;
	input [2:0] color;
	input [6:0]swIn;
	input[3:0] counterCount;
	input loadX, loadY, resetRegisters;
	
	wire [6:0] plotY;
	wire [7:0] plotX;
	wire[14:0] counter15Out;
	wire [6:0] initialX, initialY;
	
	output reg [6:0] yOut;
	output reg [7:0] xOut;
	output reg [2:0] colorOut;
	
	// Initialize the x and y values
	register xReg(loadX, swIn, initialX, resetRegisters, clock);
	register yReg(loadY, swIn, initialY, resetRegisters, clock);
	
	// Pick x and y based on the counter
	assign plotY= initialY + counterCount[1:0];
	assign plotX= initialX + counterCount[3:2];
	
	always@ (*) begin
		yOut= plotY+1;
		xOut=plotX+1;
		colorOut= color;
	end
endmodule



module control(counterCount, clock, key, counterEnable, counterReset, resetRegisters, loadX, loadY, plot);
	input [3:0] counterCount;
	input clock;
	input [3:0]key;
	
	output reg counterEnable, counterReset, resetRegisters, loadX, loadY, plot;
	
	reg [2:0] currentState, nextState;
	
	parameter reset= 3'b000, counterEnabled= 3'b001, counterDisabled= 3'b010, loadRegX= 3'b011, loadRegY= 3'b100; //states
	
	always@(*) begin
		case(currentState)
		
			loadRegX: begin
				counterEnable= 0;
				counterReset=0;
				resetRegisters=0;
				loadX=1;
				loadY=0;
				plot=0;
			end
			
			loadRegY: begin
				counterEnable= 0;
				counterReset=0;
				resetRegisters=0;
				loadX=0;
				loadY=1;
				plot=0;
			end
			
			reset: begin
				counterReset=1;
				counterEnable=0;
				resetRegisters=1;
				loadX=0;
				loadY=0;
				plot=0;
			end
			
			counterEnabled: begin
				counterReset=0;
				counterEnable=1;
				resetRegisters=0;
				loadX=0;
				loadY=0;
				plot=1;
			end
			
			counterDisabled: begin
				counterReset=0;
				counterEnable=0;
				resetRegisters=0;
				loadX=0;
				loadY=0;
				plot=1;
			end
			
			default: begin
				counterReset=1;
				counterEnable=0;
				resetRegisters=1;
				loadX=0;
				loadY=0;
				plot=0;
			end
		endcase
	end
	
	always@(posedge clock) begin
		if(key[0]==0) 
			currentState= reset;
		else
			currentState= nextState;
	end

	always@(*) begin //state table
		case(currentState)
			reset: nextState= (key[3]==0)? loadRegX: reset;
			loadRegX: nextState= loadRegY;
			loadRegY: nextState= (key[1]==0)? counterEnabled: loadRegY;
			counterEnabled: nextState= (counterCount==15)? counterDisabled:counterEnabled;
			counterDisabled: nextState= reset;
			default: nextState= reset;
		endcase
	end
endmodule

module counter4Bit(clock, reset, enable, count);
	input clock;
	input reset, enable;
	
	output reg [3:0] count;
	
	initial count=0;
	
	always@ (posedge clock) begin
		if(reset==1)
			count<=0;
		else if(enable)
			count<= count+1;
	end
endmodule

module counter15Bit(clock, reset, enable, count);
	input clock;
	input reset, enable;
	
	output reg [14:0] count;
	
	always@ (posedge clock) begin
		if(reset==1)
			count<=0;
		else if(enable)
			count<= count+1;
	end
endmodule

module register(load, in, out, reset, clock);
	input load, clock, reset;
	input [6:0] in;
	output reg[6:0] out;
	
	always@(posedge clock) begin
		if(reset==1)
			out<=0;
		else if(load==1) begin
			out<=in;
		end
	end
endmodule

