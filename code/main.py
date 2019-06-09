#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import Adafruit_ADS1x15
from mics import MICS
from mcp230xx import MCP230XX
import serial
import SHT31_Array

sht_array = SHT31_Array.SHT31_Array(TCA9548A_address=0x70, N_SHTs =8)

adc = Adafruit_ADS1x15.ADS1115()
mics = MICS(adc, 0, 1)
mics2 = MICS(adc, 2, 3)

mcp = MCP230XX('MCP23017', 0x20, '16bit')
# Setup outputs
for i in range(4):
    mcp.set_mode(i, 'output')



def change_serial_channel(channel=0, serial_mcp):
    serial_mcp.output(0, (channel&0b0001) > 0)
    serial_mcp.output(1, (channel&0b0010) > 0)
    serial_mcp.output(2, (channel&0b0100) > 0)
    serial_mcp.output(3, (channel&0b1000) > 0)

while True:
    values = mics.aquire_mv()
    print( '%s\t%s' %  tuple(values[x] for x in ['red','ox']), end='' )
    values2 = mics2.aquire_mv()
    print( '\t%s\t%s\t' %  tuple(values2[x] for x in ['red','ox']), end='' )

    print('\t'.join( [str(x) for x in sht_array.read_all_temperature_humidity()]))

    time.sleep(0.5)
