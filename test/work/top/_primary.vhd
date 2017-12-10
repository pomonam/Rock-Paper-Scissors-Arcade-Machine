library verilog;
use verilog.vl_types.all;
entity top is
    port(
        SW              : in     vl_logic_vector(9 downto 0);
        KEY             : in     vl_logic_vector(3 downto 0);
        CLOCK_50        : in     vl_logic;
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        LEDR            : out    vl_logic_vector(9 downto 0)
    );
end top;
