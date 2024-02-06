# qts_qsfp_sdi

PRBS tester for Stratix 10 GX dev board QSFP port


import serial
s=serial.Serial("COM3")
s.write(b"haasoscope on")
s.write(b"haasoscope off")
