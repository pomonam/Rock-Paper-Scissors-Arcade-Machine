library verilog;
use verilog.vl_types.all;
entity d_ff is
    port(
        reg_input       : in     vl_logic;
        reg_output      : out    vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end d_ff;
