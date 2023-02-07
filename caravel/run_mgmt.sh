#!/usr/bin/env bash

mpy-cross caravel_spi_xor.py
cp caravel_spi_xor.mpy ${FLASH}
sync
mpremote connect ${DEV} exec "import caravel_spi_xor; caravel_spi_xor.run()"
