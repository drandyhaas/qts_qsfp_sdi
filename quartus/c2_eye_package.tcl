# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# File containing callbacks associated with Eye View
set TCRX_LIST {}
proc setup_transceiver_channel_rx_services {} {
    global TCRX_LIST
    set services [get_accessible_services phy_req]
    set num_serv [llength $services]
    
    for {set i 0} {$i < $num_serv} {incr i} {
        set service_path [lindex $services $i]
        if {[is_service_path transceiver_channel_rx $service_path]} {
            set tcrx_serv [claim_service transceiver_channel_rx $service_path ""]
            set channel [transceiver_channel_rx_get_logical_channel_number $tcrx_serv]

            if {[catch {
                transceiver_channel_rx_override_arbitration_crete2 $tcrx_serv
            } result]} {
                # Handle the error
                send_message warning "skipping transceiver_channel_rx_override_arbitration_crete2 for"
                send_message warning $tcrx_serv
            } else {
                # Key
                lappend TCRX_LIST $channel
            
                # Value
                lappend TCRX_LIST $tcrx_serv
            }
            
            
        }
    }
    
    # Uplevel of 2 since this is called by init callback,
    # and aims to declare the map in the global space
    uplevel 2 {array set TCRX_MAP $TCRX_LIST}
}

proc close_transceiver_channel_rx_services {} {
    global num_chan
    global TCRX_MAP
    for {set i 0} {$i < $num_chan} {incr i} {
        set tcrx $TCRX_MAP($i)
        transceiver_channel_rx_clear_arbitration_override_crete2 $tcrx      
        close_service transceiver_channel_rx $tcrx
    }
}

proc get_transceiver_channel_rx_service {channel} {
    global TCRX_MAP
    return $TCRX_MAP($channel)
}

proc eye_view_callback {channel} {
    global CHANNEL_NUMBER_MAP
    if [catch {set channelIdx $CHANNEL_NUMBER_MAP($channel)}] {return}
    
    set hstep [get_parameter_value eye_horizontal_step_$channelIdx]
    set vstep [get_parameter_value eye_vertical_step_$channelIdx]
    set trx [get_transceiver_channel_rx_service $channelIdx]
    
    set minBitsToTest [get_parameter_value eye_rlc_test_at_least_$channelIdx]
    set stopIfBelow [get_parameter_value eye_rlc_stop_if_ber_below_$channelIdx]
    set stopIfAbove [get_parameter_value eye_rlc_stop_if_ber_above_$channelIdx]
    set useMinimumTimeout [get_parameter_value eye_use_minimum_timeout_$channelIdx]
    
    if [catch {
        transceiver_channel_rx_run_unified_toolkit_eye_sweep $trx $hstep $vstep [list $minBitsToTest $stopIfBelow $stopIfAbove $useMinimumTimeout]
        
        set update_interval 500
        set cancel_request 0
        while {![transceiver_channel_rx_is_unified_toolkit_eye_sweep_complete $trx]} {
            after $update_interval;
            if {[stop_requested] && !$cancel_request} {
                transceiver_channel_rx_cancel_unified_toolkit_eye_sweep $trx
                set cancel_request 1
                send_message warning "Eye View stop requested."
            } else {
                set prog_max [transceiver_channel_rx_get_unified_toolkit_eye_sweep_progress_max $trx]
                set prog_curr [transceiver_channel_rx_get_unified_toolkit_eye_sweep_progress_current $trx]
                set prog_scaled [expr {int(double($prog_curr * 100) / $prog_max)}]
                if {$prog_scaled > 100} {
                    set prog_scaled 100
                }
                set_current_progress $prog_scaled
            }
        }
        set interpolate [get_parameter_value eye_interpolate_$channelIdx]
        set result_str [transceiver_channel_rx_get_unified_toolkit_eye_sweep_result $trx $interpolate]
    } errmsg] {
        # Handle any exception that may arise
        send_message error "An error occurred capturing the eye: $errmsg"
        transceiver_channel_rx_cancel_unified_toolkit_eye_sweep $trx
        set result_str [list]
    }
    
    if {[llength $result_str] < 4} {
        # Something went wrong
        set_parameter_value eye_height_$channelIdx -1
        set_parameter_value eye_width_$channelIdx -1
    } else {
         # Parse results from TTK driver
        set eye_height_str [lindex $result_str 0]
        set eye_width_str [lindex $result_str 1]
        set eye_center_str [lindex $result_str 2]
        set eye_data_str [lindex $result_str 3]
       
        # Set eye statistics
        set_parameter_value eye_height_$channelIdx $eye_height_str
        set_parameter_value eye_width_$channelIdx $eye_width_str

        # Set eye properties
        set_eye_property x_step $hstep
        set_eye_property y_step $vstep
        set_eye_property y_axis_offset [expr {(63 - (63 % $vstep)) * -1}];
        set_eye_property z_unit {"Bit Error Rate (BER)" "Total Bits Tested"}

        set_eye_data $eye_data_str; # This must go last -- it is this command that draws the HeatMap
    }
}
