#!/usr/bin/env bash
set -ex

MAX_BITBYTES=19200
BITSTREAM=../../test_designs/counter.bin

iverilog -D NO_SOC -o $1.vvp -s testbench $1 ../rtl/*.v
python3 ../../../sim/makehex.py $BITSTREAM $MAX_BITBYTES bitstream.hex

vvp $1.vvp -fst
