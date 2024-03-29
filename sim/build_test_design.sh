#!/usr/bin/env bash

SYNTH_TCL=${HOME}/FABulous/fabric_cad/synth/synth_fabulous.tcl
BIT_GEN=${HOME}/FABulous/fabric_cad/bit_gen.py


DESIGN=${DESIGN:-counter}

set -ex
yosys -qp "synth_fabulous -complex-dff -carry ha -top top_wrapper -json test_design/${DESIGN}.json" test_design/${DESIGN}.v test_design/top_wrapper.v

FAB_ROOT=../fabric nextpnr-generic --timing-allow-fail --uarch fabulous --json test_design/${DESIGN}.json -o fasm=test_design/${DESIGN}_des.fasm
python3 ${BIT_GEN} -genBitstream test_design/${DESIGN}_des.fasm ../fabric/npnroutput/meta_data.txt test_design/${DESIGN}.bin
