# qts_qsfp_sdi

PRBS tester for Stratix 10 GX dev board QSFP port

Quartus Pro 23.3.0

<pre>
import serial
s=serial.Serial("COM3")
s.write(b"haasoscope on")
s.write(b"haasoscope off")
</pre>

source ttk_helper_s10.tcl

run System Debugging Toolkits from Tools menu

qsfp_xcvr_test_xcvr_native_s10_htile_1
q_sys_xcvr_atx_pll_s10_htile_1
q_sys_xcvr_atx_pll_s10_htile_2
reconfiguration profile 0: 10312.5 Gbps (set pll at 644.53125 MHz, default)
reconfiguration profile 1: 25650.6 (was 25781.25) Gbps (set pll at 644.53125 MHz, default)
reconfiguration profile 2: 9618.96 Gbps (set pll at 601.185 MHz)

see quartus subdirectory for preventing the dreaded transceiver_channel_rx_override_arbitration_crete2 error

