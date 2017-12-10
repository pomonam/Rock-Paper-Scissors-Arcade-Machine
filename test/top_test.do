# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog top_test.v

# Load simulation using mux as the top level simulation module.
vsim top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#scissor: 00 rock: 01 paper: 10
#winner => 00: win 
#01: lose 
#11: draw

#KEY[3] resetn
#SW[2] confirm
#KEY[2] stop_left
#KEY[0] stop_right
#KEY[1] stop_user
#SW[1:0] user_input_player
#HEX0, HEX1 => left
#HEX4, HEX5 => right
#LEDR[9:8] => status
#LEDR[7:3] => score

force {CLOCK_50} 0 0, 1 50 -repeat 100
force {KEY[3]} 0
run 100ns

force {KEY[3]} 1
force {KEY[2]} 1
run 200ns

force {KEY[2]} 0
run 100ns

force {KEY[2]} 1
force {KEY[0]} 1
run 200ns

force {KEY[0]} 0
run 100ns

force {KEY[0]} 1
run 100ns

force {SW[1:0]} 10
force {SW[2]} 1
run 100ns
# 3300ns

force {SW[2]} 0
run 4000ns

force {KEY[0]} 0
run 4000ns

force {KEY[1]} 1
run 100ns

force {SW[1:0]} 01
force {SW[2]} 1
run 100ns

force {KEY[1]} 0
run 4000ns

force {KEY[1]} 1
run 100ns

force {SW[1:0]} 01
force {SW[2]} 1
run 100ns

force {KEY[1]} 0
run 4000ns

force {KEY[1]} 1
run 100ns

