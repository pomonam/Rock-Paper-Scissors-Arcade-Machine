library verilog;
use verilog.vl_types.all;
entity winner_indicator is
    port(
        player          : in     vl_logic_vector(1 downto 0);
        computer        : in     vl_logic_vector(1 downto 0);
        winner          : out    vl_logic_vector(1 downto 0);
        enable          : in     vl_logic
    );
end winner_indicator;
