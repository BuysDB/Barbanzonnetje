#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import Adafruit_ADS1x15
from mics import MICS
from mcp230xx import MCP230XX

adc = Adafruit_ADS1x15.ADS1115()
mics = MICS(adc, 0, 1)
mics2 = MICS(adc, 2, 3)

mcp = MCP230XX('MCP23017', 0x20, '16bit')
# Setup outputs
for i in range(4):
    mcp.set_mode(i, 'output')

def change_serial_channel(channel=0, serial_mcp):

    MCP.output(0, (channel&0b0001) > 0)
    MCP.output(1, (channel&0b0010) > 0)
    MCP.output(2, (channel&0b0100) > 0)
    MCP.output(3, (channel&0b1000) > 0)


while True:
    values = mics.aquire_mv()
    print( '%s\t%s' %  tuple(values[x] for x in ['red','ox']), end='' )
    values2 = mics2.aquire_mv()
    print( '\t%s\t%s' %  tuple(values2[x] for x in ['red','ox']) )
    time.sleep(0.5)
