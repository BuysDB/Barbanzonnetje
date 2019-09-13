#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import Adafruit_ADS1x15
from mics import MICS
from mcp230xx import MCP230XX
import Adafruit_GPIO.I2C as I2C
from Adafruit_SHT31 import SHT31
import serial
import pynmea2
import colorama
import sys
import numpy as np
import collections
import struct
import datetime
import os
import signal

import traceback

n = datetime.datetime.now()
log_folder = '/home/pi/logs'
log_file=None
log_created = None
def  new_log_file():
    global log_file
    global log_created
    if log_file is not None:
        log_file.close()
    log_file_name = f"{n.strftime('%Y-%m-%d-%H-%M-%S')}.tsv"
    if not os.path.exists(log_folder):
        os.makedirs(log_folder)
    log_file = open(f'{log_folder}/{log_file_name}','w')
    log_created = datetime.datetime.now()
new_log_file()

def printerr(message,end='\n'):
    sys.stderr.write(f'{message}{end}')
    sys.stderr.flush()





class SDS011:

    def __init__(self, port):
        self.port = port
        self.baud=9600
        self.serialConnection = None
        self.initConnection()


    def cast_byte_str(self,s):
        return bytes( [ ord(p) for p in s ] )

    def initConnection(self):
        print("Opening connection")
        self.serialConnection = serial.Serial(self.port, self.baud, timeout=4)
        #self.textIO = io.TextIOWrapper(io.BufferedRWPair(self.serialConnection, self.serialConnection), line_buffering=True)

    def construct_command(self, cmd, data=[]):
        assert len(data) <= 12
        data += [0,]*(12-len(data))
        checksum = (sum(data)+cmd-2)%256
        ret = "\xaa\xb4" + chr(cmd)
        ret += ''.join(chr(x) for x in data)
        ret += "\xff\xff" + chr(checksum) + "\xab"
        return bytes( [ ord(p) for p in ret ] )

    def write(self, string):
        print(string)
        self.serialConnection.write( string)

    def sleep(self, sleep):
        if sleep==1:
            print("Turning device to sleep")
        else:
            print("Awakening device")
        self.write(self.construct_command(6, [0x1, 0 if sleep else 1]))
        self.read_response()

    def read_response(self):
        byte = 0
        while byte != b"\xaa":
            byte = self.serialConnection.read(size=1)

        d = self.serialConnection.read(size=9)
        #print("RESPONSE" )
        #print(d)
        return byte + d

    def cmd_set_mode(self,mode=1):
        self.write(self.construct_command(2, [0x1, mode]))
        self.read_response()

    def cmd_set_id(self,id):
        id_h = (id>>8) % 256
        id_l = id % 256
        self.serialConnection.write(self.construct_command(5, [0]*10+[id_l, id_h]))
        self.read_response()

    def get_measurement(self):
        self.serialConnection.write(self.construct_command(4))
        d = self.read_response()
        r = struct.unpack('<HHxxBB', d[2:])
        pm25 = r[0]/10.0
        pm10 = r[1]/10.0
        checksum = sum(v for v in d[2:8])%256

        if not (checksum==r[2] and r[3]==0xab):
            raise ValueError('Returned checksum invalid')
        return({'PM10':pm10, 'PM2':pm25})

    def get_averaged_measurement(self, n=25):
        self.cmd_set_mode(1);
        time.sleep(3)
        P10 = []
        P25 = []
        # Toss the first measurement
        r = self.get_measurement()
        while len(P10)<n:
            try:
                r = self.get_measurement()
                P10.append(r['P10'])
                P25.append(r['P2.5'])
            except Exception as e:
                print(e)
                pass
            time.sleep(2)
        self.sleep(1)
        return({
        'P10':{
            'AVG':np.mean(P10),
            'STD':np.std(P10),
            'MED':np.median(P10)
            },
        'P2.5':{'MED':np.median(P25),'AVG':np.mean(P25), 'STD':np.std(P25)}})


def grouper(iterable, n, fillvalue=None):
    "Collect data into fixed-length chunks or blocks"
    # grouper('ABCDEFG', 3, 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * n
    return zip(*args)

class GAUGE():
    def __init__(self,serial,gauge_index):
        self.serial = serial
        self.gauge_index = gauge_index

    def _goto(self,value):
        warr = [134]+[self.gauge_index]+[
            int(''.join(byte),2)
            for byte in grouper( '{0:016b}'.format(value), 8)]
        self.serial.write(
             bytes(warr)
        )


class LINEAR_GAUGE(GAUGE):
    def __init__(self,serial,gauge_index, range_start,range_end,angle_start,angle_end):
        GAUGE.__init__(self,serial,gauge_index)
        self.range_start=range_start
        self.range_end=range_end
        self.angle_start = angle_start
        self.angle_end = angle_end


    def goto(self,value):
        tv =np.interp(value,
                             [self.range_start,self.range_end],
                             [self.angle_start,self.angle_end])
        self._goto( int(tv) )



class LOG_GAUGE(GAUGE):
    def __init__(self,serial,gauge_index, range_start,range_end,angle_start,angle_end):
        GAUGE.__init__(self,serial,gauge_index)
        self.range_start=range_start
        self.range_end=range_end
        self.angle_start = angle_start
        self.angle_end = angle_end


    def goto(self,value):
        tv =np.interp(np.log10(value),
                             [self.range_start,self.range_end],
                             [self.angle_start,self.angle_end])
        self._goto( int(tv) )

gps_port = '/dev/serial0'
gauge_port = '/dev/ttyUSB0'
gauge_serial = serial.Serial(gauge_port, 9600, timeout=1)
printerr("Opening SDS..")
sds = SDS011('/dev/ttyUSB1')
sds.cmd_set_mode(1)

print( sds.get_measurement() )
printerr("ok")

ser = gauge_serial

fan_pwm = GAUGE(ser,99)
fan_speed_obs = GAUGE(ser,98)

def read_fan_speed():
    while ser.in_waiting>0:
        ser.read(1)

    fan_speed_obs._goto(0)
    line = ser.readline().strip()
    if line=="None":
        return None
    else:
        try:
            fan_gauge.goto(int(line)*60)
            return int(line)*60 # convert hertz to rpm
        except Exception as e:
            print(e)
            return None



pm2_gauge = LINEAR_GAUGE(ser, 7,
                   range_start=0,
                   range_end=20,
                   angle_start=0,
                   angle_end=270)

bat_gauge = LINEAR_GAUGE(ser, 5,
                   range_start=0,
                   range_end=100,
                   angle_start=0,
                   angle_end=140)

fan_gauge = LINEAR_GAUGE(ser, 6,
                   range_start=0,
                   range_end=20000,
                   angle_start=0,
                   angle_end=140)


nox_gauge = LOG_GAUGE(ser, 1,
                   range_start=-2,
                   range_end=1,
                   angle_start=0,
                   angle_end=270)

nox_gauge.goto(10)
bat_gauge.goto(100)
time.sleep(30) # Wait for gauge_port to init
nox_gauge.goto(10)
bat_gauge.goto(100)
time.sleep(4) # Wait for gauge_port to init doesnt work?

def handler_stop_signals(signum, frame):
    pm2_gauge.goto(0)
    fan_gauge.goto(0)
    nox_gauge = goto(0.01)
    log_file.write( 'TERMINATION:1\n')
    log_file.close()


signal.signal(signal.SIGINT, handler_stop_signals)
signal.signal(signal.SIGTERM, handler_stop_signals)

def select_I2C_channel(channel):
    TCA9548A.write8(0, 1<<channel)

def change_serial_channel(serial_mcp, channel=0):
    serial_mcp.output(0, (channel&0b0001) > 0)
    serial_mcp.output(1, (channel&0b0010) > 0)
    serial_mcp.output(2, (channel&0b0100) > 0)
    serial_mcp.output(3, (channel&0b1000) > 0)

# 3.3V, on channel 2
adcs3V = [
    Adafruit_ADS1x15.ADS1115(0x48),
    Adafruit_ADS1x15.ADS1115(0x49),
    Adafruit_ADS1x15.ADS1115(0x4A),
    Adafruit_ADS1x15.ADS1115(0x4B)
]
# 5V on channel 3
adcs5V = [
    Adafruit_ADS1x15.ADS1115(0x48),
    Adafruit_ADS1x15.ADS1115(0x49),
    Adafruit_ADS1x15.ADS1115(0x4A),
    Adafruit_ADS1x15.ADS1115(0x4B)
]

printerr(f'{colorama.Style.DIM}Initialising TCA9548A{colorama.Style.RESET_ALL}',end="\t")

passed = False
for tried in range(10):
    try:
        TCA9548A = I2C.get_i2c_device(0x70)
        select_I2C_channel(0)
        break
    except Exception as e:
        if tried>8:
            printerr(f'{colorama.Fore.RED}[FAIL]{colorama.Style.RESET_ALL}')
            raise
printerr(f'{colorama.Fore.GREEN}[OK]{colorama.Style.RESET_ALL}')

printerr(f'{colorama.Style.DIM}Initialising SHT31{colorama.Style.RESET_ALL}',end="\t")
sht = SHT31(0x44)
printerr(f'{colorama.Fore.GREEN}[OK]{colorama.Style.RESET_ALL}')

mics = MICS(adcs5V[0], 0, 1,2)
mics2 = MICS(adcs5V[1], 0)


gps_serial = serial.Serial(gps_port, 9600, 8, 'N', 1, timeout=1)

time.sleep(1)

if False:
    printerr(f'{colorama.Style.DIM}Initialising MCP23017{colorama.Style.RESET_ALL}',end="\t")
    try:
        mcp = MCP230XX('MCP23017', 0x20, '16bit')
        # Setup outputs
        #for i in range(4):
        #    mcp.set_mode(i, 'output')

    except Exception as e:
        printerr(f'{colorama.Fore.RED}[FAIL]{colorama.Style.RESET_ALL}')
        raise
    printerr(f'{colorama.Fore.GREEN}[OK]{colorama.Style.RESET_ALL}')



nox_window = collections.deque(maxlen=10)
p2_window = collections.deque(maxlen=10)
batt_window = collections.deque(maxlen=20)

try:
    while True:
        # Make new file every 5 minutes
        if (datetime.datetime.now() - log_created).total_seconds() > 5*60:
            new_log_file()

        current_data = {}
        try:
            while gps_serial.in_waiting>0:
                sentence = str(gps_serial.readline(), 'ascii')

                if sentence.startswith('$GPGGA'):
                    printerr(f'{colorama.Fore.GREEN}{sentence}{colorama.Style.RESET_ALL}')
                    data = pynmea2.parse(sentence)
                    print(f'Location: {data.latitude} {data.longitude} {data.age_gps_data}')
                    current_data['latitude'] = data.latitude
                    current_data['longitude'] = data.longitude
        except Exception as e:
            printerr(f'{colorama.Fore.RED}{e}{colorama.Style.RESET_ALL}')


        r = sds.get_measurement()

        current_data.update(r)

        p2_window.append(r['PM2'])
        pm2_gauge.goto( np.mean(p2_window) )
        read_fan_speed()
        success=False
        for t in range(5):
            try:
                select_I2C_channel(3); #5V channel
                success=True
                break
            except OSError:
                pass
            time.sleep(0.01)
        read_fan_speed()
        tries=10
        if not success:
            printerr(f'{colorama.Fore.RED}I2C is having issues on channel 3 {colorama.Style.RESET_ALL}')
        else:
            # read battery level

            if True:
                for adc_index in range(4):
                    success=False
                    for t in range(tries):
                        read_fan_speed()
                        try:
                            v = mics2[adc_index]
                            current_data[f'5V2_ADC_{adc_index}']  = v
                            printerr(f'{colorama.Fore.GREEN}[2][{adc_index}]{v}{colorama.Style.RESET_ALL}')
                            success=True
                            break
                        except OSError:
                            pass

                for adc_index in range(4):
                    success=False
                    for t in range(tries):
                        read_fan_speed()
                        try:
                            v = mics[adc_index]
                            current_data[f'5V1_ADC_{adc_index}']  = v
                            printerr(f'{colorama.Fore.GREEN}[1][{adc_index}]{v}{colorama.Style.RESET_ALL}')
                            success=True
                            break
                        except OSError:
                            pass

            success=False
            for t in range(tries):
                try:
                    read_fan_speed()
                    current_data['BATT']= mics2[2]
                    batt_window.append(current_data['BATT'])
                    printerr(f'{colorama.Fore.GREEN}BATT {current_data["BATT"]}{colorama.Style.RESET_ALL}')

                    corrected_voltage = np.mean(batt_window) - 568
                    bpos = np.interp(corrected_voltage,
                                         [3000,4200], # readl: 3.772= 4340 readout, #3.880 V= 4500 readout
                                         [0,100])
                    current_data['BATT_PCT']  = bpos
                    bat_gauge.goto(bpos)
                    success=True
                    break
                except OSError:
                    pass



            if not success:
                printerr(f'{colorama.Fore.RED}I2C is having issues on channel 3, ADC 1 {colorama.Style.RESET_ALL}')

            success=False
            for t in range(5):
                try:
                    read_fan_speed()
                    values = mics.aquire_mv()
                    #print( '\t'.join( [str(value) for key,value in values.items()] ),end='\t')

                    for key,value in values.items():
                        current_data[f'MICS1_{key}'] = value

                    values2 = mics2.aquire_mv()
                    #print( '\t'.join( [str(value) for key,value in values2.items()] ),end='\t')

                    for key,value in values2.items():
                        current_data[f'MICS2_{key}'] = value

                    nox_window.append( values2['red'] / 5.0)
                    nox_gauge.goto( np.mean(nox_window) )
                    success=True
                except OSError:
                    pass

            if not success:
                printerr(f'{colorama.Fore.RED}I2C is having issues on channel 3, MICS1/2 {colorama.Style.RESET_ALL}')




        try:
            select_I2C_channel(1);
            time.sleep(0.1)
            #print("\t".join([str(x) for x in sht.read_temperature_humidity() ]))
            th = sht.read_temperature_humidity()
            current_data['SHT1_TEMP'] = th[0]
            current_data['SHT1_HUM'] = th[1]
            print("SHT:")
            print(th)
        except OSError:
            printerr(f'{colorama.Fore.RED}I2C is having issues on channel 1{colorama.Style.RESET_ALL}')


        fan_speed = read_fan_speed()
        if fan_speed is not None:
            printerr(f'{colorama.Fore.WHITE}FAN {fan_speed}{colorama.Style.RESET_ALL}')
            current_data['FAN_SPEED'] = fan_speed


        n = datetime.datetime.now()
        current_data.update(
        {
        'year':n.year,
        'minute':n.minute,a
        'second':n.second,
        'hour':n.hour,
        'microsecond':n.microsecond,
        'month':n.month,
        'day':n.day
        }

        )
        log_file.write(','.join(f'{key}:{value}' for key,value in current_data.items()) + '\n')

        fan_pwm._goto(45)
        for x in range(5):
            read_fan_speed()
            time.sleep(0.03)
        if ser.in_waiting:
            print(ser.readline())
except Exception as e:
    # Getting killed...
    pm2_gauge.goto(0)
    fan_gauge.goto(0)
    nox_gauge.goto(0.01)
    log_file.write( 'TERMINATION:1\n')
    log_file.close()
    print(e)

    traceback.print_exc()
