# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog datapath.v

# Load simulation using mux as the top level simulation module.
vsim control

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clk} 0 0, 1 50 -repeat 100
force {resetn} 0
run 100ns

force {resetn} 1
force {return_to_load_left} 0
force stop_left 0
run 100ns

force stop_left 1
run 100ns

force stop_right 0
run 100ns

force stop_right 1
run 100ns

force stop_rps 0
run 100ns

force stop_rps 1
run 100ns

force stop_rps 0 
run 100ns

force stop_rps 1
run 100ns

force stop_rps 0
run 100ns

force stop_rps 1

force {return_to_load_left} 1
run 100ns	


