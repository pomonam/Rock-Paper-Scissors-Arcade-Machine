library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        load_left       : in     vl_logic;
        load_right      : in     vl_logic;
        user_input_player: in     vl_logic_vector(1 downto 0);
        computer        : in     vl_logic_vector(1 downto 0);
        load_user       : in     vl_logic;
        enable_aalu     : in     vl_logic;
        enable_winner_indicator: in     vl_logic;
        clk             : in     vl_logic;
        stop_left       : in     vl_logic;
        stop_right      : in     vl_logic;
        resetn          : in     vl_logic;
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        LEDR            : out    vl_logic_vector(9 downto 8);
        status          : out    vl_logic_vector(1 downto 0);
        same_leftright  : out    vl_logic;
        score           : out    vl_logic_vector(4 downto 0)
    );
end datapath;
