library verilog;
use verilog.vl_types.all;
entity AALU is
    port(
        x               : in     vl_logic_vector(4 downto 0);
        y               : in     vl_logic_vector(4 downto 0);
        lose            : out    vl_logic;
        bonus           : out    vl_logic_vector(4 downto 0);
        enable          : in     vl_logic
    );
end AALU;
