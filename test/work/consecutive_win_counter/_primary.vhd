library verilog;
use verilog.vl_types.all;
entity consecutive_win_counter is
    port(
        clk             : in     vl_logic;
        clear_b         : in     vl_logic;
        q               : out    vl_logic_vector(1 downto 0);
        enable          : in     vl_logic_vector(1 downto 0);
        three_wins      : out    vl_logic
    );
end consecutive_win_counter;
