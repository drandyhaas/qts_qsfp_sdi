derive_pll_clocks
derive_clock_uncertainty

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]
create_clock -name {clk_50}        -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_50}]
create_clock -name {clk_fpga_100m} -period 10.000 -waveform { 0.000 5.000 }  [get_ports {clk_fpga_100m}]
	
create_clock -period "644.53125MHz"   [get_ports { refclk_qsfp_p }]
create_clock -period "148.5MHz"       [get_ports { refclk_sdi_p  }]   

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name slow_clk -source [get_ports clk_50] -divide_by 2 {*|freq_counter:freq_counter_0|slow_clk}

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tms]

set_input_delay -clock { clk_50 } 5 [get_ports {lt_io_sda}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tdo]

set_output_delay -clock { clk_50 } 2.5 [get_ports {lt_io_sda}]

#**************************************************************
# Set Clock Group
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks { altera_reserved_tck }]
set_clock_groups -asynchronous -group [get_clocks { clk_50 }]
set_clock_groups -asynchronous -group [get_clocks { clk_fpga_100m }]

set_clock_groups -asynchronous -group [get_clocks { refclk_qsfp_p }]
set_clock_groups -asynchronous -group [get_clocks { refclk_sdi_p }]

set_clock_groups -asynchronous -group [get_clocks { slow_clk }]

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {altera_reserved_ntrst}]

set_false_path -from [get_ports {cpu_resetn}]
set_false_path -from [get_ports {user_dipsw[*]}]
set_false_path -from [get_keepers {user_pb[*]}] 
set_false_path -to [get_ports {user_led_g[*]}]
set_false_path -to [get_ports {user_led_r[*]}]

set_false_path -from * -to qsfp_mod_prsn
set_false_path -from qsfp_rstn -to *

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


