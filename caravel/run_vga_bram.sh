#!/usr/bin/env bash
set -ex

mpy-cross caravel_spi_vga_bram.py
cp caravel_spi_vga_bram.mpy ${FLASH}
cp ../sim/test_design/vga_bram.bin ${FLASH}/counter.bin
sync
mpremote connect ${DEV} exec "import caravel_spi_vga_bram; caravel_spi_vga_bram.run()"
