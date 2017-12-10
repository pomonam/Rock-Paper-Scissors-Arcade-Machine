module register(data_in, resetn, clk, data_result);
// Did not use D flip flop. However, it is possible to implement it using
// D flip flop.
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
            reg_output <= reg_input;
    end
endmodule



