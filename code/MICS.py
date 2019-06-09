#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import Adafruit_ADS1x15


def set_bit(v, index, x):
    """Set the index:th bit of v to 1 if x is truthy, else to 0, and return the new value."""
    mask = 1 << index   # Compute mask, an integer with just bit 'index' set.
    v &= ~mask          # Clear the bit indicated by the mask (if x is False)
    if x:
        v |= mask         # If x was True, set the bit indicated by the mask.
    return v            # Return the result, we're done.

class MICS():
    def __init__(self, adc,
        red_port=None, ox_port=None, nh3_port=None, pre_heater_port = None

        ):
        self.adc = adc
        self.amplifier_gains = [2/3,1,2,4,8,16]
        self.ports = {'red':red_port, 'ox':ox_port, 'nh3':nh3_port}
        self.max_adc_readout = 32767
        self.vdd = 5

    def __repr__(self):
        return "MICS sensor"

    def aquire(self):
        results = {}
        for sensor_name, port in self.ports.items():
            if port is not None:
                results[sensor_name] = self._aquire_gain_inc(port)
        return results

    def get_full_scale_range(self, gain):
        return self.vdd*(1/effective_gain)  #This is the range we map the signal to [0, VDD*gain]

    def get_mv(self, raw_val, gain):

        sign =  raw_val & 0b10
        nosignval = set_bit(raw_val, 0, 0)
        LSBuV = nosignval * (self.get_full_scale_range(gain) / (32767.0/1000.0));
        return LSBuV*(-1 if sign else 1)

    def aquire_mv(self):
        results = {}
        for sensor_name, port in self.ports.items():
            if port is not None:
                for gain, raw_val in  self._aquire_gain_inc(port,max_only=True).items():
                      results[sensor_name] = self.get_mv(raw_val, gain)


        return results
    # Aquire port voltage by starting with a low gain, but increasing until an unsafe voltage is reached
    # This gives us the highest resolution possible
    def _aquire_gain_inc(self, adc_port, max_only=False):
        result_dict = dict()
        for gain, next_gain in zip(self.amplifier_gains, self.amplifier_gains[1:]+[None]):
            result = self.adc.read_adc(adc_port, gain=gain)
            # would we saturate the ADC if we would increase the gain?
            if max_only:
                result_dict = {gain:result}
            else:
                result_dict[gain] = result
            expected_next_adc_readout =  (result/gain)*next_gain
            if expected_next_adc_readout > self.max_adc_readout*0.95:
                break
        return result_dict

# Create an ADS1115 ADC (16-bit) instance.
adc = Adafruit_ADS1x15.ADS1115()
mics = MICS(adc, 0, 1)

while True:
    print( mics.aquire_mv() )
    time.sleep(0.5)
