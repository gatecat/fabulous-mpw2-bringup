#include <string>
#include <fstream>
#include <stdio.h>
#include <stdint.h>
#include <chrono>
#include <iostream>
#include <fstream>
#include <iterator>

#include <SDL2/SDL.h>
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

namespace {
constexpr unsigned htotal = 320;
constexpr unsigned vtotal = 525;
constexpr unsigned hscale = 2;
int32_t rgb_image[vtotal*htotal*hscale];

static int64_t render_time() {
  return std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::steady_clock::now().time_since_epoch()).count();
}

SDL_Window *vga_window;
SDL_Renderer *vga_renderer;
void flush_rgb() {
    SDL_Surface *surf = SDL_CreateRGBSurfaceFrom(
      (void *)rgb_image,
      htotal * hscale, vtotal,
      32, htotal * hscale * 4,
      0x000000FF, 0x0000FF00, 0x00FF0000, 0x0
    );

    SDL_Texture *tex = SDL_CreateTextureFromSurface(vga_renderer, surf);
    SDL_RenderClear(vga_renderer);
    SDL_RenderCopy(vga_renderer, tex, nullptr, nullptr);
    SDL_RenderPresent(vga_renderer);
    SDL_DestroyTexture(tex);
    SDL_FreeSurface(surf);

    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) {
            exit(0);
            break;
        }
    }
}

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

    // image load for fancier demo
    if (argc >= 2) {
        std::vector<char> img_data;
        std::ifstream file(argv[1], std::ios::binary);
        if (!file) {
            fprintf(stderr, "failed to open %s!\n", argv[1]);
            return 1;
        }
        std::istreambuf_iterator<char> start(file), end{};
        std::copy(start, end, std::back_inserter(img_data));

        io.fab_reset = 1;
        for (int i = 0; i < 100; i++) tick();
        io.fab_reset = 0;
        fprintf(stderr, "loading %u image bytes!\n", unsigned(img_data.size()));
        for (char byte : img_data) {
            for (int i = 0; i < 8; i++) {
                io.write_data = (uint8_t(byte) >> (7 - i)) & 0x1;
                for (int j = 0; j < 20; j++) tick();
                io.write_strobe = !io.write_strobe;
                for (int j = 0; j < 20; j++) tick();
            }
        }
        fprintf(stderr, "done loading!\n");
    }

    vga_window = SDL_CreateWindow("vga", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, htotal*hscale, vtotal, 0);
    if (vga_window == nullptr) {
        fprintf(stderr, "Failed to create window: %s.\n", SDL_GetError());
        exit(1);
    }
    vga_renderer =
      SDL_CreateRenderer(vga_window, -1, SDL_RENDERER_ACCELERATED);

    // main loop
    bool last_hsync = true, last_vsync = true;
    unsigned hcnt = 0, vcnt = 0;
    int64_t last_flush = render_time();
    while (true) {
        tick();
        if (hcnt < htotal && vcnt < vtotal) {
            uint32_t pix = (uint32_t(io.pixr) | uint32_t(io.pixg) << 8 | uint32_t(io.pixb) << 16);
            for (unsigned dx = 0; dx < hscale; dx++) {
                rgb_image[vcnt*htotal*hscale + hcnt*hscale + dx] = pix;
            }
        }
        hcnt++;
        if (last_hsync && !io.hsync) {
            hcnt = 0;
            vcnt++;
            if (render_time() >= (last_flush + 16000)) {
                flush_rgb();
                last_flush = render_time();
            }
        }
        if (last_vsync && !io.vsync) {
            vcnt = 0;
        }
        last_hsync = io.hsync;
        last_vsync = io.vsync;
    }
    fprintf(stderr, "\n");
    return 0;
}