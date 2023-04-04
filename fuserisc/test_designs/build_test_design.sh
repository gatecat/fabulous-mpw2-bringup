#!/usr/bin/env bash

SYNTH_TCL=${HOME}/FABulous/fabric_cad/synth/synth_fabulous.tcl
BIT_GEN=${HOME}/FABulous/fabric_cad/bit_gen.py


DESIGN=${DESIGN:-counter}

set -ex
yosys -qp "synth_fabulous -complex-dff -carry ha -top top_wrapper -json ${DESIGN}.json" ${DESIGN}.v top_wrapper_fuserisc.v

FAB_ROOT=../ nextpnr-generic --timing-allow-fail --uarch fabulous --json ${DESIGN}.json -o fasm=${DESIGN}_des.fasm
python3 ${BIT_GEN} -genBitstream ${DESIGN}_des.fasm ../npnroutput/meta_data.txt ${DESIGN}.bin
