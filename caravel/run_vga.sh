#!/usr/bin/env bash
set -ex

mpy-cross caravel_spi_vga.py
cp caravel_spi_vga.mpy ${FLASH}
cp ../sim/test_design/vga.bin ${FLASH}/counter.bin
sync
mpremote connect ${DEV} exec "import caravel_spi_vga; caravel_spi_vga.run()"
