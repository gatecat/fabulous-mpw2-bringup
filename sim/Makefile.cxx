all: cxxrtl_tb

fabric.rtl.cc:
	yosys -D EMULATION -p "read_verilog test_design/vga.vh ../fabric/verilog_emulation/*.v models_pack.v; script yosys_build_emul.ys"

fabric.rtl.h: fabric.rtl.cc

%.rtl.o: %.rtl.cc
	clang++ -std=c++17 -w -g -O1 -I$(shell yosys-config --datdir)/include -c -o $@ $<

%.o: %.cc fabric.rtl.h
	clang++ -std=c++17 -O1 -g -I$(shell yosys-config --datdir)/include -c -o $@ $<

cxxrtl_tb: fabric.rtl.o cxxrtl_tb.o
	clang++ -std=c++17 -lSDL2 -o $@ $^

clean:
	rm -f fabric.rtl.cc fabric.rtl.h fabric.rtl.o cxxrtl_tb.o cxxrtl_tb

.PHONY: clean
