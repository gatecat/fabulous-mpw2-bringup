#!/usr/bin/env bash

mpy-cross caravel_spi.py
cp caravel_spi.mpy ${FLASH}
cp ../sim/test_design/counter.bin ${FLASH}
sync
mpremote connect ${DEV} exec "import caravel_spi; caravel_spi.run()"
