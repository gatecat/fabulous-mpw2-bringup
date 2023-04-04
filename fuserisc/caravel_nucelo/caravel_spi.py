#!/usr/bin/env python3

# from pyftdi.ftdi import Ftdi
import time
import sys, os
# from pyftdi.spi import SpiController
from array import array as Array
import binascii
from io import StringIO

from nucleo_api import Test, ProgSupply

from machine import Pin, SPI, SoftSPI, sleep, I2C, SoftI2C

CARAVEL_PASSTHRU = 0xC4
CARAVEL_STREAM_READ = 0x40
CARAVEL_STREAM_WRITE = 0x80
CARAVEL_REG_READ = 0x48
CARAVEL_REG_WRITE = 0x88
CARAVEL_REG_READ2 = 0x50
CARAVEL_REG_WRITE2 = 0x90


class SPI:
    def __init__(self, enabled=True):

        if enabled:
            self.cs = Pin('SPI5_CS', mode=Pin.OUT, value=1)
            self.sck = Pin('SPI5_SCK', mode=Pin.OUT, value=0)
            self.mosi = Pin('SPI5_MISO', mode=Pin.OUT)  # PF9 = IO[2] = caravel input
            self.miso = Pin('SPI5_MOSI', mode=Pin.IN)  # PF8 = IO[1] = caravel output
            self.spi = SoftSPI(baudrate=00000, polarity=0, phase=0, sck=self.sck, mosi=self.mosi, miso=self.miso)
        else:
            self.cs = Pin('SPI5_CS', mode=Pin.IN, pull=None)
            self.sck = Pin('SPI5_SCK', mode=Pin.IN, pull=None)
            self.mosi = Pin('SPI5_MISO', mode=Pin.IN, pull=None)  # PF9 = IO[2] = caravel input
            self.miso = Pin('SPI5_MOSI', mode=Pin.IN, pull=None)  # PF8 = IO[1] = caravel output
            self.spi = None

    def write(self, buf):
        txdata = bytearray(buf)
        self.cs.value(0)
        self.spi.write(txdata)
        self.cs.value(1)

    def exchange(self, buf, n):
        
        txdata = bytearray(buf)
        txdata += '\0'*(n)
        m = len(txdata)
        rxdata = bytearray(m)

        self.cs.value(0)
        self.spi.write_readinto(txdata, rxdata)
        self.cs.value(1)
        return rxdata[m-n:m]

    def set_gpio(self, value):
        for i in range(4):
            self.write([CARAVEL_STREAM_WRITE, 0x6d-i, (value >> (8*i)) & 0xFF])

def run():
    print("Powering up...")
    slave = SPI()
    # in some cases, you may need to comment or uncomment this line
    #slave.write([CARAVEL_REG_WRITE, 0x0b, 0x01])
    # ------------

    # disable HKSPI
    slave.write([CARAVEL_REG_WRITE, 0x6f, 0xff])

    data = slave.exchange([CARAVEL_STREAM_READ, 0x03], 4)
    print("   disabled ID = {:08x} (should be 00)".format(int.from_bytes(data, 'big')))

    slave.__init__(enabled=False)

    supply = ProgSupply()
    # set vcc to 1.8V for better fabric perf
    voltage = 1.8
    R2 = 360 / ((voltage / 1.25) - 1)
    Rpot = (1 / (1 / R2 - 1 / 5000)) - 500
    P = Rpot / 38.911
    Pval = int(P)

    print('Writing ' + str(Pval) + ' to potentiometer.')
    supply.write_1v8(Pval)

    fpga_clk = Pin('IO_0', mode=Pin.OUT, value=0)
    fpga_clksel0 = Pin('IO_1', mode=Pin.OUT, value=0)
    fpga_clksel1 = Pin('IO_2', mode=Pin.OUT, value=0)
    fpga_sclk = Pin('IO_3', mode=Pin.OUT, value=0)
    fpga_sdata = Pin('IO_4', mode=Pin.OUT, value=0)
    fpga_rx = Pin('IO_5', mode=Pin.OUT, value=1)

    fpga_rxled = Pin('IO_6', mode=Pin.IN, pull=0)
    last_rxled = False

    # use fast clock for configuration
    fpga_clksel0.value(1)
    fpga_clksel1.value(0)

    # load bitstream, check receive LED
    ctrl_word = 0x0000FAB1
    # make sure we start desynced
    data = bytes(0xFF for i in range(128))
    with open("counter.bin", mode='rb') as f:
        data += f.read()
    for i, byte in enumerate(data):
        for j in range(8):
            fpga_sdata.value((byte >> (7-j)) & 0x1)
            # tog_clk()
            fpga_sclk.value(1)
            # tog_clk()
            fpga_sdata.value((ctrl_word >> (31-(8*(i%4) + j))) & 0x1)
            # tog_clk()
            fpga_sclk.value(0)
            # tog_clk()
        if (i % 100) == 0:
            print("{}".format(i))

    fpga_out = [Pin(f'IO_{i+17}', mode=Pin.IN, pull=0) for i in range (10)]

    for i in range(1000):
        b = 0
        for k, p in enumerate(fpga_out):
            if p.value():
                b |= (1 << k)
        print("out: {:010b}".format(b))
