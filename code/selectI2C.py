#!/usr/bin/env python3.7
import Adafruit_GPIO
import Adafruit_GPIO.I2C as I2C
import time
import sys
import argparse
import os

argparser = argparse.ArgumentParser(
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    description="Select I2C channel multiplexed by TCA9548A")
argparser.add_argument('ch', nargs='?', help="channel", type=int)
args = argparser.parse_args()

TCA9548A = I2C.get_i2c_device(0x70)

if args.ch is None:
    for channel in range(0,8):
        print(f"== CHANNEL {channel} ==")
        TCA9548A.write8(0, 1<<channel)
        os.system("i2cdetect -y 1")
else:
    TCA9548A.write8(0, 1<<args.ch)
