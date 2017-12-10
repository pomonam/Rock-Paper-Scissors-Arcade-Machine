library verilog;
use verilog.vl_types.all;
entity subtractor is
    port(
        operandone      : in     vl_logic_vector(4 downto 0);
        operandtwo      : in     vl_logic_vector(4 downto 0);
        result          : out    vl_logic_vector(4 downto 0);
        enable          : in     vl_logic
    );
end subtractor;
