library verilog;
use verilog.vl_types.all;
entity RPSGame is
    port(
        player          : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        stop            : in     vl_logic;
        clear           : in     vl_logic;
        winner          : out    vl_logic_vector(1 downto 0);
        enable          : in     vl_logic
    );
end RPSGame;
