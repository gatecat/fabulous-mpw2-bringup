#include <string>
#include <fstream>
#include <stdio.h>
#include <stdint.h>
#include "fabric.rtl.h"

typedef cxxrtl_design::p_eFPGA__top design_t;

struct ModuleIO {
	// system configuration
	bool sys_clk = false, bit_clk = false, bit_data = false, uart_rx = true, fab_reset = false;
	// extra video BRAM loading logic
	bool write_strobe = false, write_data = false;
	// outputs from fabric/
	uint8_t pixr = 0, pixg = 0, pixb = 0;
	bool rxled, hsync, vsync;
};

void update_io(design_t &top, ModuleIO &io) {
	auto io_out = top.p_io__out.get<uint64_t>();
	io.rxled = (io_out >> 6) & 0x1;
	io.hsync = (io_out >> 8) & 0x1;
	io.vsync = (io_out >> 9) & 0x1;
	// TODO: these pinouts grew over time and are a bit chaotic, maybe tweak
	io.pixr = (((io_out >> 10) & 0x1) << 7) | (((io_out >> 15) & 0x1) << 6);
	io.pixg = (((io_out >> 11) & 0x1) << 7) | (((io_out >> 16) & 0x1) << 6);
	io.pixb = (((io_out >> 12) & 0x1) << 7) | (((io_out >> 17) & 0x1) << 6);
	uint64_t io_in = (
		uint64_t(io.sys_clk) << 0 |
		uint64_t(io.bit_clk) << 3 |
		uint64_t(io.bit_data) << 4 |
		uint64_t(io.uart_rx) << 5 |
		uint64_t(io.fab_reset) << 7 |
		uint64_t(io.write_strobe) << 13 |
		uint64_t(io.write_data) << 14
	);
	top.p_io__in.set(io_in);
	top.step();
}

int main(int argc, char *argv[]) {
	uint64_t io_in = 0b0;
	
	// top instance
	ModuleIO io;
	cxxrtl_design::p_eFPGA__top top;
	auto tick = [&]() {
		io.sys_clk = false;
		update_io(top, io);
		io.sys_clk = true;
		update_io(top, io);
	};
	// bitstream
	std::vector<uint8_t> bitstream;
	for (int i = 0; i < 128; i++)
		bitstream.push_back(0xFF);
	{
		if (argc < 2) {
			fprintf(stderr, "no bitstream specified on command line!\n");
			return 1;
		}
		std::ifstream in(argv[1], std::ifstream::binary);
		if (!in) {
			fprintf(stderr, "failed to open input bitstream file!\n");
			return 1;
		}
    	std::istreambuf_iterator<char> it{in}, end;
    	unsigned pad_size = bitstream.size();
    	while (it != end) {
    		bitstream.push_back(uint8_t(*it));
    		++it;
    	}
    	fprintf(stderr, "bitstream size: %u bytes\n", unsigned(bitstream.size() - pad_size));
	}
	uint32_t ctrl_word = 0x0000FAB1;
	for (int i = 0; i < 100; i++) {
		fprintf(stderr, "%d\n", i);
		tick();
	}
	fprintf(stderr, "loading bitstream");
	for (unsigned i = 0; i < bitstream.size(); i += 4) {
		for (unsigned j = 0; j < 32; j++) {
			io.bit_data = (bitstream.at(i + j/8) >> (7 - (j % 8))) & 0x1;
			for (int k = 0; k < 4; k++) tick();
			io.bit_clk = true;
			for (int k = 0; k < 4; k++) tick();
			io.bit_data = (ctrl_word >> (31 - j)) & 0x1;
			for (int k = 0; k < 4; k++) tick();
			io.bit_clk = false;
			for (int k = 0; k < 4; k++) tick();
		}
		/* if ((i % 400) == 0) {
			fprintf(stderr, ".");
			fflush(stderr);
		} */
	}
	fprintf(stderr, "\n");
	return 0;
}