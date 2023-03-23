#!/usr/bin/env bash
set -ex
iverilog -o $1.vvp -s testbench $1 ../rtl/*.v
vvp $1.vvp -fst
