# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog datapath.v

# Load simulation using mux as the top level simulation module.
vsim datapath

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clk} 0 0, 1 50 -repeat 100
force {resetn} 0
run 100ns

force {load_left} 1
force {resetn} 1
force {stop_left} 1
run 800ns

force {stop_left} 0
force {load_left} 0
run 100ns

force {load_right} 1
force {stop_right} 1
run 1000ns

force {stop_right} 0
force {load_right} 0
force {enable_aalu} 1 
run 100ns

#scissor: 00 rock: 01 paper: 10
#winner => 00: win 01: lose 11: draw
force {player} 00
force {enable_aalu} 0
force {stop_rps} 1
force {load_user} 1
run 1200ns

force {stop_rps} 0
force {load_user} 0
run 100ns



