library verilog;
use verilog.vl_types.all;
entity SevenSegment is
    port(
        HEXleft         : out    vl_logic_vector(6 downto 0);
        HEXright        : out    vl_logic_vector(6 downto 0);
        num             : in     vl_logic_vector(4 downto 0)
    );
end SevenSegment;
