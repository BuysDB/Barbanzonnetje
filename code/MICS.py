#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import Adafruit_ADS1x15

class MICS():
    def __init__(self, adc,
        red_port=None, ox_port=None, nh3_port=None, pre_heater_port = None

        ):
        self.adc = adc
        self.amplifier_gains = [2/3,1,2,4,8,16]
        self.ports = {'red':red_port, 'ox':ox_port, 'nh3':nh3_port}
        self.max_adc_readout = 32767

    def __repr__(self):
        return "MICS sensor"

    def aquire(self):
        results = {}
        for sensor_name, port in self.ports.items():
            if port is not None:
                results[sensor_name] = self._aquire_gain_inc(port)
        return results

    # Aquire port voltage by starting with a low gain, but increasing until an unsafe voltage is reached
    # This gives us the highest resolution possible
    def _aquire_gain_inc(self, adc_port):
        result_dict = dict()
        for gain, next_gain in zip(self.amplifier_gains, self.amplifier_gains[1:]+[None]):
            result = self.adc.read_adc(adc_port, gain=gain)
            # would we saturate the ADC if we would increase the gain?
            result_dict[gain] = result
            expected_next_adc_readout =  (result/gain)*next_gain
            if expected_next_adc_readout > self.max_adc_readout*0.95:
                break
        return result_dict

# Create an ADS1115 ADC (16-bit) instance.
adc = Adafruit_ADS1x15.ADS1115()
mics = MICS(adc, 0, 1)

while True:
    print( mics.aquire() )
    time.sleep(0.5)
