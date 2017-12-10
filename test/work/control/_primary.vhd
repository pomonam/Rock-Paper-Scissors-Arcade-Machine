library verilog;
use verilog.vl_types.all;
entity control is
    port(
        clear           : out    vl_logic;
        confirm         : in     vl_logic;
        clk             : in     vl_logic;
        resetn          : in     vl_logic;
        ld_user         : out    vl_logic;
        enable_aalu     : out    vl_logic;
        ld_left         : out    vl_logic;
        ld_right        : out    vl_logic;
        stop_left       : in     vl_logic;
        stop_right      : in     vl_logic;
        stop_user       : in     vl_logic;
        status          : in     vl_logic_vector(1 downto 0);
        return_to_load_left: in     vl_logic;
        go_to_get_user  : in     vl_logic;
        curr_state      : out    vl_logic_vector(5 downto 0);
        plot            : out    vl_logic;
        color           : out    vl_logic_vector(2 downto 0);
        xOut            : out    vl_logic_vector(7 downto 0);
        yOut            : out    vl_logic_vector(6 downto 0);
        opponent        : out    vl_logic_vector(1 downto 0);
        enable_winner_indicator: out    vl_logic
    );
end control;
