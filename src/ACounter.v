module SevenSegment(HEXleft, HEXright, num);
	// This is a seven HEX decoder. It receives 5-bit input and
	// decodes into two seven segment.
	output reg [6:0] HEXleft, HEXright;
	input [4:0] num;
 
	always @(num)
		case (num)
    	// Digit 0
    	5'b00000: begin
    	HEXleft = 7'b0000001;
    	HEXright = 7'b0000001;
      	end
      	// Digit 1
      	5'b00001: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b10011111;
      	end
      	// Digit 2
      	5'b00010: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0010010;
      	end
      	// Digit 3
      	5'b00011: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0000110;
      	end
      	// Digit 4
      	5'b0100: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b1001101;
      	end
      	// Digit 5
      	5'b00101: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0100100;
      	end
      	// Digit 6
      	5'b00110: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0100000;
      	end
      	// Digit 7
      	5'b00111: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0001111;
      	end
      	// Digit 8
      	5'b01000: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0000000;
      	end
      	// Digit 9
      	5'b01001: begin
      	HEXleft = 7'b0000001;
      	HEXright = 7'b0001100;
      	end
      	// Digit 10.
      	5'b01010: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0000001;
      	end
      	// Digit 11.
      	5'b01011: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b10011111;
      	end
      	// Digit 12
      	5'b01100: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0010010;
      	end
      	// Digit 13
      	5'b01101: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0000110;
      	end
      	// Digit 14
      	5'b01110: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b1001101;
      	end
      	// Digit 15
      	5'b01111: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0100100;
      	end
      	// Digit 16
      	5'b10000: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0100000;
      	end
      	// Digit 17
      	5'b10001: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0001111;
      	end
      	// Digit 18
      	5'b10010: begin
      	HEXleft = 7'b0000000;
      	HEXright = 7'b0000000;
      	end
      	// Digit 19
      	5'b10011: begin
      	HEXleft = 7'b10011111;
      	HEXright = 7'b0001100;
      	end
      	// Digit 20
      	5'b10100: begin
      	HEXleft = 7'b0010010;
      	HEXright = 7'b0000001;
      	end
      	// Default case will show 88.
      	// This case should not be displayed and handled in datapath module.
		default: begin
		HEXleft = 7'b0000000;
		HEXright = 7'b0000000;
		end
	endcase
endmodule

module counter(clk, clear_b, stop, q);
    input clk;
    input clear_b;
    input stop;
    output reg [4:0] q = 0;
    
    always @(posedge clk)
    begin
        if (stop == 1'b1)
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

module displaycounter(clk, clear_b, out);
    input clk;
    input clear_b;
    output [5:0] out;
    reg [5:0] q = 0;

    assign out = q;
    
    always @(posedge clk)
    begin
        if (clear_b == 1'b0)
            q <= 0;
        else if (q == 5'b10100)
            q <= 0;
        else if (clk == 1'b1)
            q <= q + 1'b1;
    end

endmodule

