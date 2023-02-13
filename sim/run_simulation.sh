#!/usr/bin/env bash
set -ex
DESIGN=bram32
BITSTREAM=test_design/${DESIGN}.bin
VERILOG=../fabric/verilog
MAX_BITBYTES=16384

iverilog -s fab_tb -o fab_tb.vvp $VERILOG/*.v test_design/${DESIGN}.v fabulous_tb.v models_pack.v ${IVFLAGS}
python3 makehex.py $BITSTREAM $MAX_BITBYTES bitstream.hex
vvp fab_tb.vvp -fst
