library verilog;
use verilog.vl_types.all;
entity RPScounter is
    port(
        clk             : in     vl_logic;
        clear_b         : in     vl_logic;
        stop            : in     vl_logic;
        q               : out    vl_logic_vector(1 downto 0);
        enable          : in     vl_logic
    );
end RPScounter;
