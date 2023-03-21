all: gateware.bin

%.json: %.v
	yosys -p "synth_ice40 -json $@ -top top" $^

%.asc: %.json icebreaker.pcf
	nextpnr-ice40 --up5k --package sg48 --json $< --pcf icebreaker.pcf --asc $@

%.bin: %.asc
	icepack $< $@

prog: gateware.bin
	iceprog gateware.bin

.PRECIOUS: gateware.json gateware.asc gateware.bin
.PHONY: prog
