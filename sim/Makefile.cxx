all: cxxrtl_tb

fabric.rtl.cc:
	yosys -p "read_verilog models_pack.v ../fabric/verilog/*.v; hierarchy -top eFPGA_top; write_cxxrtl -header -noflatten -g0 fabric.rtl.cc"

%.rtl.o: %.rtl.cc
	clang++ -w -O1 -I$(shell yosys-config --datdir)/include -c -o $@ $<

%.o: %.cc
	clang++ -O1 -I$(shell yosys-config --datdir)/include -c -o $@ $<

cxxrtl_tb: fabric.rtl.o cxxrtl_tb.o
	clang++ -lSDL2 -o $@ $^
