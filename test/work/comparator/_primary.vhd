library verilog;
use verilog.vl_types.all;
entity comparator is
    port(
        x               : in     vl_logic_vector(4 downto 0);
        y               : in     vl_logic_vector(4 downto 0);
        greater         : out    vl_logic_vector(4 downto 0);
        lower           : out    vl_logic_vector(4 downto 0);
        same            : out    vl_logic;
        enable          : in     vl_logic
    );
end comparator;
