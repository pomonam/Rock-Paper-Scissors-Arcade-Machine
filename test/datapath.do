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
force {load_left} 1
force {resetn} 0
run 100ns

force {resetn} 1
run 400ns

force {stop_left} 1
run 100ns