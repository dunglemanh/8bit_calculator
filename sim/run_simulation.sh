#!/bin/bash

# File: run_simulation.sh
# Run with: source run_simulation.sh

echo "Compiling Verilog files..."
iverilog -o sim/calculator_sim \
    src/rtl/alu.v \
    src/rtl/control_unit.v \
    src/rtl/calculator_top.v \
    src/tb/calculator_tb.v

echo "Running simulation..."
vvp sim/calculator_sim

echo "Simulation complete. Check console output and waveform file."
