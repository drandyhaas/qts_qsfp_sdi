# qts_qsfp_sdi

PRBS tester for Stratix 10 GX dev board QSFP port

Quartus Pro 23.3.0

<pre>
import serial
s=serial.Serial("COM3")
s.write(b"haasoscope on") # for Stratix dev kit power
s.write(b"haasoscope off")
s.write(b"arduino_12 on") # for 2-slot ATCA crate power
s.write(b"arduino_12 off")
</pre>

run System Debugging Toolkits from Tools menu

qsfp_xcvr_test_xcvr_native_s10_htile_1
q_sys_xcvr_atx_pll_s10_htile_1
q_sys_xcvr_atx_pll_s10_htile_2
reconfiguration profile 0: 10.3125 Gbps (set pll at 644.53125 MHz, default)
reconfiguration profile 1: 25.6506 (was 25781.25) Gbps (set pll at 641.265 MHz)
reconfiguration profile 2: 9.61896 Gbps (set pll at 601.185 MHz)

see quartus subdirectory for preventing the dreaded transceiver_channel_rx_override_arbitration_crete2 error

