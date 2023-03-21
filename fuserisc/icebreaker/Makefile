all: gateware.bin

%.json: %.v
	yosys -qp "synth_ice40 -json $@ -top top" $^

%.asc: %.json icebreaker.pcf
	nextpnr-ice40 --up5k --package sg48 --json $< --pcf icebreaker.pcf --asc $@

%.bin: %.asc
	icepack -s $< $@

prog: gateware.bin
	iceprog -k gateware.bin

.PRECIOUS: gateware.json gateware.asc gateware.bin
.PHONY: prog
