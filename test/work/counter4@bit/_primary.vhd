library verilog;
use verilog.vl_types.all;
entity counter4Bit is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        count           : out    vl_logic_vector(3 downto 0);
        count_done      : out    vl_logic
    );
end counter4Bit;
