#!/usr/bin/env bash
set -ex

mpy-cross caravel_spi.py
cp caravel_spi.mpy ${FLASH}
sync
mpremote connect ${DEV} exec "import caravel_spi; caravel_spi.run()"