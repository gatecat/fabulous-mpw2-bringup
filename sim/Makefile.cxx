all: cxxrtl_tb

fabric.rtl.cc:
	yosys -p "read_verilog models_pack.v ../fabric/verilog/*.v; hierarchy -top eFPGA_top; write_cxxrtl -header -noflatten -g0 fabric.rtl.cc"

fabric.rtl.h: fabric.rtl.cc

%.rtl.o: %.rtl.cc
	clang++ -std=c++17 -w -g -O1 -I$(shell yosys-config --datdir)/include -c -o $@ $<

%.o: %.cc fabric.rtl.h
	clang++ -std=c++17 -O1 -g -I$(shell yosys-config --datdir)/include -c -o $@ $<

cxxrtl_tb: fabric.rtl.o cxxrtl_tb.o
	clang++ -std=c++17 -lSDL2 -o $@ $^
