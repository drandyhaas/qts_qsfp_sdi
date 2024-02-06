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


source "c2_driver_package.tcl"
source "c2_autosweep_package.tcl"
source "c2_eye_package.tcl"
source "c2_utilities.tcl"

# Module properties
set_toolkit_property INITIALIZATION_CALLBACK init_c2_toolkit
set_toolkit_property FINALIZATION_CALLBACK finalize_c2_toolkit
set_toolkit_property ELABORATION_CALLBACK push_to_hardware
set_toolkit_property AUTOSWEEP_INITIALIZATION_CALLBACK sweep_init_callback
set_toolkit_property AUTOSWEEP_QUALITY_METRIC_CALLBACK quality_metric_callback
set_toolkit_property AUTOSWEEP_CASE_VALIDITY_CALLBACK case_validity_callback
set_toolkit_property AUTOSWEEP_FINALIZATION_CALLBACK sweep_finalization_callback
set_toolkit_property EYE_VIEWER_CALLBACK eye_view_callback
set_toolkit_property CHANNEL_CALLBACK channel_callback
set_toolkit_property CHART_CALLBACK chart_callback


namespace eval c2_messages {
    variable GXT_reverse_warning 0
    variable background_cal_warning_msg "The H-Tile Transceiver Native PHY Toolkit is designed to be the sole master in charge of enabling / disabling background calibration (0x542).  Ensure no other masters attempt to enable or disable background calibration of this PHY instance until the associated Toolkit instance has been closed."
}

# Global constants
set NUM_DFE_TAPS 15
set MAX_SUPPORTED_CHANNELS 24
set ANALOG_DISPLAY_GROUP "Analog"
set LOOPBACK_MODE_GROUP "Loopback mode"
set COMBINED_ADAP_MODE_GROUP "Combined Adaptation mode"
set PRBS_PATTERN_GROUP "PRBS pattern"

set HARD_PRBS_DISPLAY_GROUP "Hard PRBS"
set UNDEFINED "N/A"

# ADME Slave service handle
set slave {}

# Build up channels
set num_chan {}
set TX_CHAN_NAMES {}
set RX_CHAN_NAMES {}
set CHANNEL_NUMBER_LIST {}
set DUPLEX_MODE "duplex"

proc setup_channel_maps {} {
    global MAX_SUPPORTED_CHANNELS
    global TX_CHAN_NAMES
    global RX_CHAN_NAMES
    global CHANNEL_NUMBER_LIST
    
    for {set chan 0} {$chan < $MAX_SUPPORTED_CHANNELS} {incr chan} {
        set tx_channel_name "TX Channel $chan"
        set rx_channel_name "RX Channel $chan"
        lappend TX_CHAN_NAMES $tx_channel_name
        lappend RX_CHAN_NAMES $rx_channel_name
        
        # Key
        lappend CHANNEL_NUMBER_LIST $tx_channel_name
        
        # Value
        lappend CHANNEL_NUMBER_LIST $chan
        
        # Key
        lappend CHANNEL_NUMBER_LIST $rx_channel_name
        
        # Value
        lappend CHANNEL_NUMBER_LIST $chan
    }
    uplevel {array set CHANNEL_NUMBER_MAP $CHANNEL_NUMBER_LIST}
}

setup_channel_maps

# Map of currently running BER callbacks
set RX_TIMED_CALLBACK_STATUS_LIST {}
for {set chan 0} {$chan < $MAX_SUPPORTED_CHANNELS} {incr chan} {
    # Key
    lappend RX_TIMED_CALLBACK_STATUS_LIST $chan
    
    # Value
    lappend RX_TIMED_CALLBACK_STATUS_LIST 0
}
array set RX_TIMED_CALLBACK_STATUS_MAP $RX_TIMED_CALLBACK_STATUS_LIST

proc declare_read_only_parameter {name display_name parent default} {
    global UNDEFINED
    add_parameter $name STRING $default
    add_display_item $parent $name TEXT
    set_parameter_property $name DISPLAY_NAME $display_name
    set_parameter_property $name ALLOWS_AUTOSWEEP false
    set_parameter_property $name ALLOWS_CHARTING false
    set_display_hint $name READ_ONLY_TEXT true
}

proc declare_shortcut_menu_item_group {group chan param_name param_values disp_group} {
    set num_values [llength $param_values]
    for {set i 0} {$i < $num_values} {incr i} {
        set curr_val [lindex $param_values $i]
        set curr_val_sanitized [regsub -all {\s} $curr_val "_"]
        set name "action_menu_shortcut__${param_name}__${curr_val_sanitized}"
        add_display_item $group $name ACTION "set_parameter_value $param_name \"$curr_val\""
        set_display_item_property $name DISPLAY_NAME $curr_val
        set_display_item_property $name DISPLAY_GROUP $disp_group
        set_display_item_property $name VISIBLE false
        set_display_hint $name SHOW_IN_MENU TRUE
    }
}

proc add_loopback_menu {chan} {
    global LOOPBACK_MODE_GROUP    
    set values [get_parameter_property loopback_mode_$chan ALLOWED_RANGES]
    declare_shortcut_menu_item_group Receiver_$chan $chan loopback_mode_$chan $values $LOOPBACK_MODE_GROUP
}

proc add_tx_prbs_menu {chan} {
    global PRBS_PATTERN_GROUP
    set values [get_parameter_property tx_test_pattern_$chan ALLOWED_RANGES]
    declare_shortcut_menu_item_group Transmitter_$chan $chan tx_test_pattern_$chan $values $PRBS_PATTERN_GROUP
}

proc add_rx_prbs_menu {chan} {
    global PRBS_PATTERN_GROUP
    set values [get_parameter_property rx_test_pattern_$chan ALLOWED_RANGES]
    declare_shortcut_menu_item_group Receiver_$chan $chan rx_test_pattern_$chan $values $PRBS_PATTERN_GROUP
}

proc add_combined_adaptation_menu {chan} {
    global COMBINED_ADAP_MODE_GROUP   
    set values [get_parameter_property rx_combined_adaptation_$chan ALLOWED_RANGES]
    declare_shortcut_menu_item_group Receiver_$chan $chan rx_combined_adaptation_$chan $values $COMBINED_ADAP_MODE_GROUP
}

proc declare_tx_channel {chan} {
    global TX_CHAN_NAMES
    global ANALOG_DISPLAY_GROUP
    global HARD_PRBS_DISPLAY_GROUP
   
    # Transmitter group
    set top_level_tx_channel_group [get_channel_display_group [lindex $TX_CHAN_NAMES $chan]]
    set TX_DISPLAY_GROUP "Transmitter"
    add_display_item $top_level_tx_channel_group Transmitter_$chan GROUP
    set_display_item_property Transmitter_$chan DISPLAY_NAME $TX_DISPLAY_GROUP
    
    # Refresh TX channel button
    add_display_item Transmitter_$chan refresh_tx_button_$chan ACTION [list refresh_tx_channel $chan]
    set_display_item_property refresh_tx_button_$chan DISPLAY_NAME "Refresh" 
    set_display_hint refresh_tx_button_$chan SHOW_IN_MENU TRUE
    
    # Auto refresh checkbox
    add_parameter live_update_checkbox_tx_$chan BOOLEAN "false"
    set_parameter_property live_update_checkbox_tx_$chan AFFECTS_ELABORATION FALSE
    set_parameter_property live_update_checkbox_tx_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property live_update_checkbox_tx_$chan ALLOWS_CHARTING "false"
    add_display_item Transmitter_$chan live_update_checkbox_tx_$chan PARAMETER
    set_display_item_property live_update_checkbox_tx_$chan DISPLAY_NAME "Auto refresh"
    set_parameter_update_callback live_update_checkbox_tx_$chan [list tx_live_update_callback $chan]

    # Transceiver label
    add_display_item Transmitter_$chan tx_xcvr_label_$chan TEXT
    set_display_item_property tx_xcvr_label_$chan TEXT [c2_utilities::gui::get_blue_label_text "Transceiver"]

    # TX Channel Address
    declare_read_only_parameter "tx_channel_addr_$chan" "TX Channel address" "Transmitter_$chan" "$chan"

    # Data rate
    declare_read_only_parameter "tx_data_rate_$chan" "TX Data rate (Mbps)" "Transmitter_$chan" "25800.0"
    
    # Hard PRBS Generator label
    set HARD_PRBS_GENERATOR_DISPLAY_GROUP "Hard PRBS Generator"
    add_display_item Transmitter_$chan tx_hard_gen_label_$chan TEXT
    set_display_item_property tx_hard_gen_label_$chan TEXT [c2_utilities::gui::get_blue_label_text $HARD_PRBS_GENERATOR_DISPLAY_GROUP]
    
    # Generator PRBS pattern
    add_parameter tx_test_pattern_$chan STRING "PRBS7"
    set_parameter_property tx_test_pattern_$chan DISPLAY_NAME "PRBS pattern"
    set_parameter_property tx_test_pattern_$chan ALLOWED_RANGES [list "PRBS_OFF" "PRBS7" "PRBS9" "PRBS15" "PRBS23" "PRBS31"]
    set_parameter_property tx_test_pattern_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property tx_test_pattern_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property tx_test_pattern_$chan TABLE_COLUMN_ORDER 1
    set_parameter_property tx_test_pattern_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    add_display_item Transmitter_$chan tx_test_pattern_$chan PARAMETER
    
    # Add prbs pattern action menu
    add_tx_prbs_menu $chan
    
    # Generator running indicator
    add_display_item Transmitter_$chan tx_is_generating_led_$chan LED
    set_display_item_property tx_is_generating_led_$chan DISPLAY_NAME "Hard PRBS Generator Running"
    set_display_hint tx_is_generating_led_$chan BACKGROUND_COLOR_LIST "Black"
    set_display_hint tx_is_generating_led_$chan FOREGROUND_COLOR_LIST "Red"
    
    # Generator start button
    add_display_item Transmitter_$chan tx_start_button_$chan ACTION [list tx_start_button_callback $chan]
    set_display_item_property tx_start_button_$chan DISPLAY_NAME "Start"
    set_display_item_property tx_start_button_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    set_display_item_property tx_start_button_$chan ACTION_PRIORITY FIRST
    set_display_hint tx_start_button_$chan SHOW_IN_MENU TRUE

    # Generator stop button
    add_display_item Transmitter_$chan tx_stop_button_$chan ACTION [list tx_stop_button_callback $chan]
    set_display_item_property tx_stop_button_$chan DISPLAY_NAME "Stop"
    set_display_item_property tx_stop_button_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    set_display_hint tx_stop_button_$chan SHOW_IN_MENU TRUE
    
    # PMA Settings label
    add_display_item Transmitter_$chan tx_rcfg_label_$chan TEXT
    set_display_item_property tx_rcfg_label_$chan TEXT [c2_utilities::gui::get_blue_label_text "PMA Settings"]
    
    # Static polarity invert
    add_parameter tx_static_inv_$chan BOOLEAN "false"
    set_parameter_property tx_static_inv_$chan DISPLAY_NAME "Invert polarity"
    set_parameter_property tx_static_inv_$chan ALLOWS_AUTOSWEEP "true"    
    add_display_item Transmitter_$chan tx_static_inv_$chan PARAMETER

    # VOD control
    add_parameter tx_vod_$chan INTEGER "0"
    set_parameter_property tx_vod_$chan DISPLAY_NAME "Vod"
    set_parameter_property tx_vod_$chan ALLOWED_RANGES [c2_utilities::get_int_list 0 31]
    set_parameter_property tx_vod_$chan ALLOWS_AUTOSWEEP "true"
    set_parameter_property tx_vod_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property tx_vod_$chan TABLE_COLUMN_ORDER 8
    set_parameter_property tx_vod_$chan DISPLAY_GROUP [join [list $TX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Transmitter_$chan tx_vod_$chan PARAMETER

    # Pre-emphasis 1st post tap
    add_parameter tx_post1_$chan INTEGER "0"
    set_parameter_property tx_post1_$chan DISPLAY_NAME "Pre-emphasis 1st post-tap"
    set_parameter_property tx_post1_$chan ALLOWED_RANGES [c2_utilities::get_int_list -24 24]
    set_parameter_property tx_post1_$chan ALLOWS_AUTOSWEEP "true"
    set_parameter_property tx_post1_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property tx_post1_$chan TABLE_COLUMN_ORDER 9
    set_parameter_property tx_post1_$chan DISPLAY_GROUP [join [list $TX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Transmitter_$chan tx_post1_$chan PARAMETER

    # Pre-emphasis 1st pre tap
    add_parameter tx_pre1_$chan INTEGER "0"
    set_parameter_property tx_pre1_$chan DISPLAY_NAME "Pre-emphasis 1st pre-tap"
    set_parameter_property tx_pre1_$chan ALLOWED_RANGES [c2_utilities::get_int_list -15 15]
    set_parameter_property tx_pre1_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property tx_pre1_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property tx_pre1_$chan TABLE_COLUMN_ORDER 10
    set_parameter_property tx_pre1_$chan DISPLAY_GROUP [join [list $TX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Transmitter_$chan tx_pre1_$chan PARAMETER
}

proc declare_rx_channel {chan} {
    global RX_CHAN_NAMES
    global ANALOG_DISPLAY_GROUP
    global LOOPBACK_MODE_GROUP
    global HARD_PRBS_DISPLAY_GROUP
    global NUM_DFE_TAPS

    # Receiver group
    set top_level_rx_channel_group [get_channel_display_group [lindex $RX_CHAN_NAMES $chan]]
    set RX_DISPLAY_GROUP "Receiver"
    add_display_item $top_level_rx_channel_group Receiver_$chan GROUP
    set_display_item_property Receiver_$chan DISPLAY_NAME $RX_DISPLAY_GROUP
    
    # Loopback mode
    add_parameter loopback_mode_$chan STRING "Off"
    set_parameter_property loopback_mode_$chan DISPLAY_NAME "Loopback Mode"
    set_parameter_property loopback_mode_$chan ALLOWED_RANGES [list "Serial Loopback" "Reverse Serial Loopback Pre-CDR" "Reverse Serial Loopback Post-CDR" "Off"]
    set_parameter_property loopback_mode_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property loopback_mode_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property loopback_mode_$chan TABLE_COLUMN_ORDER 0
    set_parameter_property loopback_mode_$chan DISPLAY_GROUP $RX_DISPLAY_GROUP
    add_display_item Receiver_$chan loopback_mode_$chan PARAMETER
    set_parameter_property loopback_mode_$chan DISPLAY_GROUP "GXB"
    
    # Refresh RX channel button
    add_display_item Receiver_$chan refresh_rx_button_$chan ACTION [list refresh_rx_channel $chan]
    set_display_item_property refresh_rx_button_$chan DISPLAY_NAME "Refresh" 
    set_display_hint refresh_rx_button_$chan SHOW_IN_MENU TRUE
    
    # Add Loopback mode action menu
    add_loopback_menu $chan
    
    # Auto refresh checkbox
    add_parameter live_update_checkbox_rx_$chan BOOLEAN "false"
    set_parameter_property live_update_checkbox_rx_$chan AFFECTS_ELABORATION FALSE
    set_parameter_property live_update_checkbox_rx_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property live_update_checkbox_rx_$chan ALLOWS_CHARTING "false"
    add_display_item Receiver_$chan live_update_checkbox_rx_$chan PARAMETER
    set_display_item_property live_update_checkbox_rx_$chan DISPLAY_NAME "Auto refresh"
    set_parameter_update_callback live_update_checkbox_rx_$chan [list rx_live_update_callback $chan]
    
    # LTD Status
    add_display_item Receiver_$chan ltd_led_$chan LED
    set_display_item_property ltd_led_$chan DISPLAY_NAME "Locked to data"
    set_display_hint ltd_led_$chan BACKGROUND_COLOR_LIST "Black"
    set_display_hint ltd_led_$chan FOREGROUND_COLOR_LIST "Red"
    
    # LTR Status
    add_display_item Receiver_$chan ltr_led_$chan LED
    set_display_item_property ltr_led_$chan DISPLAY_NAME "Locked to ref"
    set_display_hint ltr_led_$chan BACKGROUND_COLOR_LIST "Black"
    set_display_hint ltr_led_$chan FOREGROUND_COLOR_LIST "Red"

    # Transceiver label
    add_display_item Receiver_$chan rx_xcvr_label_$chan TEXT
    set_display_item_property rx_xcvr_label_$chan TEXT [c2_utilities::gui::get_blue_label_text "Transceiver"]

    # RX Channel address label
    declare_read_only_parameter "rx_channel_addr_$chan" "RX Channel address" "Receiver_$chan" "$chan"
    
    # Data rate label
    declare_read_only_parameter "rx_data_rate_$chan" "RX Data rate (Mbps)" "Receiver_$chan" "25800.0"

    # Hard PRBS Checker label
    set HARD_PRBS_CHECKER_DISPLAY_GROUP "Hard PRBS Checker"
    add_display_item Receiver_$chan rx_checker_label_$chan TEXT
    set_display_item_property rx_checker_label_$chan TEXT [c2_utilities::gui::get_blue_label_text $HARD_PRBS_CHECKER_DISPLAY_GROUP]

    # Total bits
    add_parameter rx_total_bits_$chan FLOAT "0"
    set_parameter_property rx_total_bits_$chan DISPLAY_NAME "Number of bits tested"
    add_display_item Receiver_$chan rx_total_bits_$chan PARAMETER
    set_parameter_property rx_total_bits_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_total_bits_$chan TABLE_COLUMN_ORDER 3
    set_parameter_property rx_total_bits_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property rx_total_bits_$chan AFFECTS_ELABORATION "false"
    set_display_hint rx_total_bits_$chan READ_ONLY_TEXT true

    # Error bits
    add_parameter rx_error_bits_$chan FLOAT "0"
    set_parameter_property rx_error_bits_$chan DISPLAY_NAME "Number of error bits"
    add_display_item Receiver_$chan rx_error_bits_$chan PARAMETER
    set_parameter_property rx_error_bits_$chan AFFECTS_ELABORATION "false"
    set_parameter_property rx_error_bits_$chan ALLOWS_AUTOSWEEP "false"
    set_display_hint rx_error_bits_$chan READ_ONLY_TEXT true    

    # Bit error rate
    add_parameter rx_ber_$chan FLOAT "0.0"
    set_parameter_property rx_ber_$chan DISPLAY_NAME "Bit error rate (BER)"
    add_display_item Receiver_$chan rx_ber_$chan PARAMETER
    set_parameter_property rx_ber_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_ber_$chan TABLE_COLUMN_ORDER 2
    set_parameter_property rx_ber_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property rx_ber_$chan AFFECTS_ELABORATION FALSE
    #set_parameter_property rx_ber_$chan QUALITY_COMPARISON_CALLBACK ber_comparison_callback
    set_parameter_property rx_ber_$chan QUALITY_COMPARISON_CALLBACK builtins::numeric_smaller_better_double
    set_display_hint rx_ber_$chan READ_ONLY_TEXT true
    
    # Checker PRBS pattern
    add_parameter rx_test_pattern_$chan STRING "PRBS7"
    set_parameter_property rx_test_pattern_$chan DISPLAY_NAME "PRBS pattern"
    set_parameter_property rx_test_pattern_$chan ALLOWED_RANGES [list "PRBS_OFF" "PRBS7" "PRBS9" "PRBS15" "PRBS23" "PRBS31"]
    set_parameter_property rx_test_pattern_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property rx_test_pattern_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_test_pattern_$chan TABLE_COLUMN_ORDER 1
    set_parameter_property rx_test_pattern_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    add_display_item Receiver_$chan rx_test_pattern_$chan PARAMETER
    
    # Add prbs pattern action menu
    add_rx_prbs_menu $chan
    
    # Checker running indicator
    add_display_item Receiver_$chan rx_is_checking_led_$chan LED
    set_display_item_property rx_is_checking_led_$chan DISPLAY_NAME "Hard PRBS Checker Running"
    set_display_hint rx_is_checking_led_$chan BACKGROUND_COLOR_LIST "Black"
    set_display_hint rx_is_checking_led_$chan FOREGROUND_COLOR_LIST "Red"
    
    # Checker start button
    add_display_item Receiver_$chan rx_start_button_$chan ACTION [list rx_start_button_callback $chan]
    set_display_item_property rx_start_button_$chan DISPLAY_NAME "Start"
    set_display_item_property rx_start_button_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    set_display_hint rx_start_button_$chan SHOW_IN_MENU TRUE

    # Checker stop button
    add_display_item Receiver_$chan rx_stop_button_$chan ACTION [list rx_stop_button_callback $chan]
    set_display_item_property rx_stop_button_$chan DISPLAY_NAME "Stop"
    set_display_item_property rx_stop_button_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    set_display_item_property rx_stop_button_$chan ACTION_PRIORITY FIRST
    set_display_hint rx_stop_button_$chan SHOW_IN_MENU TRUE

    # Checker reset button
    add_display_item Receiver_$chan rx_reset_button_$chan ACTION [list rx_reset_button_callback $chan]
    set_display_item_property rx_reset_button_$chan DISPLAY_NAME "Reset"
    set_display_item_property rx_reset_button_$chan DISPLAY_GROUP [list $HARD_PRBS_DISPLAY_GROUP]
    set_display_hint rx_reset_button_$chan SHOW_IN_MENU TRUE

    # PMA Settings label
    add_display_item Receiver_$chan rx_rcfg_label_$chan TEXT
    set_display_item_property rx_rcfg_label_$chan TEXT [c2_utilities::gui::get_blue_label_text "PMA Settings"]
    
    # Static polarity invert
    add_parameter rx_static_inv_$chan BOOLEAN "false"
    set_parameter_property rx_static_inv_$chan DISPLAY_NAME "Invert polarity"
    set_parameter_property rx_static_inv_$chan ALLOWS_AUTOSWEEP "true"
    add_display_item Receiver_$chan rx_static_inv_$chan PARAMETER
    
    # VGA DC Gain
    add_parameter rx_vga_dc_gain_$chan INTEGER "0"
    set_parameter_property rx_vga_dc_gain_$chan ALLOWED_RANGES [c2_utilities::get_int_list 0 31]
    set_parameter_property rx_vga_dc_gain_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property rx_vga_dc_gain_$chan DISPLAY_NAME "VGA DC Gain"
    set_parameter_property rx_vga_dc_gain_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_vga_dc_gain_$chan TABLE_COLUMN_ORDER 4
    set_parameter_property rx_vga_dc_gain_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Receiver_$chan rx_vga_dc_gain_$chan PARAMETER
    
    # CTLE EQ Gain
    add_parameter rx_ctle_eq_gain_$chan INTEGER "0"
    set_parameter_property rx_ctle_eq_gain_$chan ALLOWED_RANGES [c2_utilities::get_int_list 0 47]
    set_parameter_property rx_ctle_eq_gain_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property rx_ctle_eq_gain_$chan DISPLAY_NAME "CTLE EQ Gain"
    set_parameter_property rx_ctle_eq_gain_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_ctle_eq_gain_$chan TABLE_COLUMN_ORDER 5
    set_parameter_property rx_ctle_eq_gain_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Receiver_$chan rx_ctle_eq_gain_$chan PARAMETER
    
    # CTLE AC Gain
    add_parameter rx_ctle_ac_gain_$chan INTEGER "0"
    set_parameter_property rx_ctle_ac_gain_$chan ALLOWED_RANGES [c2_utilities::get_int_list 0 15]
    set_parameter_property rx_ctle_ac_gain_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property rx_ctle_ac_gain_$chan DISPLAY_NAME "CTLE AC Gain"
    set_parameter_property rx_ctle_ac_gain_$chan TABLE_COLUMN_ORDER 6
    set_parameter_property rx_ctle_ac_gain_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_ctle_ac_gain_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Receiver_$chan rx_ctle_ac_gain_$chan PARAMETER
    
    # Restart Adaptation button
    add_display_item Receiver_$chan rx_restart_adaptation_button_$chan ACTION [list restart_adaptation_callback $chan]
    set_display_item_property rx_restart_adaptation_button_$chan DISPLAY_NAME "Restart Adaptation"
    set_display_hint rx_restart_adaptation_button_$chan SHOW_IN_MENU FALSE; # Hide for now, not sure this is needed and just clutters things
    
    # Combined Adaptation mode
    add_parameter rx_combined_adaptation_$chan STRING "Adaptive CTLE, Adaptive VGA, All-Tap Adaptive DFE"
    set_parameter_property rx_combined_adaptation_$chan ALLOWED_RANGES [list "Manual CTLE, Manual VGA, DFE off" "Adaptive CTLE, Adaptive VGA, DFE off" "Adaptive CTLE, Adaptive VGA, 1-Tap Adaptive DFE" "Adaptive CTLE, Adaptive VGA, All-Tap Adaptive DFE"]
    set_parameter_property rx_combined_adaptation_$chan ALLOWS_AUTOSWEEP "true"    
    set_parameter_property rx_combined_adaptation_$chan DISPLAY_NAME "Combined Adaptation mode"
    set_parameter_property rx_combined_adaptation_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
    add_display_item Receiver_$chan rx_combined_adaptation_$chan PARAMETER
    set_parameter_update_callback rx_combined_adaptation_$chan [list rx_combined_adaptation_update_callback $chan]
    
    # Add combined adaptation action menu
    add_combined_adaptation_menu $chan

    # DFE taps
    for {set tap_num 1} {$tap_num <= $NUM_DFE_TAPS} {incr tap_num} {
        add_parameter rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} INTEGER 0
        set_parameter_property rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} DISPLAY_NAME "DFE Tap adapted value $tap_num"
        set_display_hint rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} READ_ONLY_TEXT "true"
        set_parameter_property rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} AFFECTS_ELABORATION FALSE
        set_parameter_property rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} ALLOWS_AUTOSWEEP FALSE
        set_parameter_property rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $ANALOG_DISPLAY_GROUP] "/"]
        add_display_item Receiver_$chan rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} PARAMETER
    }
    
    # DFE tap combined display item
    add_parameter rx_combined_dfe_display_$chan STRING
    set_parameter_property rx_combined_dfe_display_$chan DISPLAY_NAME "DFE"
    set_parameter_property rx_combined_dfe_display_$chan AFFECTS_ELABORATION false
    set_parameter_property rx_combined_dfe_display_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property rx_combined_dfe_display_$chan ALLOWS_CHARTING "false"
    set_parameter_property rx_combined_dfe_display_$chan VISIBLE false
    set_parameter_property rx_combined_dfe_display_$chan ENABLED false
    set_parameter_property rx_combined_dfe_display_$chan TABLE_COLUMN_VISIBILITY true
    set_parameter_property rx_combined_dfe_display_$chan TABLE_COLUMN_ORDER 7
    add_display_item Receiver_$chan rx_combined_dfe_display_$chan PARAMETER
    
    # Eye Viewer controls
    set top_level_eye_group [get_eye_viewer_display_group [lindex $RX_CHAN_NAMES $chan]]
    set EYE_CONTROL_GROUP Eye_View_controls_$chan
    set EYE_CONTROLS_DISPLAY_GROUP "Eye Sweep Controls"
    add_display_item $top_level_eye_group $EYE_CONTROL_GROUP GROUP
    set_display_item_property $EYE_CONTROL_GROUP DISPLAY_NAME $EYE_CONTROLS_DISPLAY_GROUP
    
    add_parameter eye_horizontal_step_$chan INTEGER "4"
    set_parameter_property eye_horizontal_step_$chan DISPLAY_NAME "Horizontal step"
    set_parameter_property eye_horizontal_step_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_horizontal_step_$chan ALLOWED_RANGES [list 1 2 4 8]
    set_parameter_property eye_horizontal_step_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_horizontal_step_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_CONTROLS_DISPLAY_GROUP] "/"]
    set_parameter_property eye_horizontal_step_$chan DESCRIPTION "This parameter controls the size of the steps on the horizontal axis"
    add_display_item $EYE_CONTROL_GROUP eye_horizontal_step_$chan PARAMETER
    
    add_parameter eye_vertical_step_$chan INTEGER "4"
    set_parameter_property eye_vertical_step_$chan DISPLAY_NAME "Vertical step"
    set_parameter_property eye_vertical_step_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_vertical_step_$chan ALLOWED_RANGES [list 1 2 4 8]
    set_parameter_property eye_vertical_step_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_vertical_step_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_CONTROLS_DISPLAY_GROUP] "/"]
    set_parameter_property eye_vertical_step_$chan DESCRIPTION "This parameter controls the size of the steps on the vertical axis"
    add_display_item $EYE_CONTROL_GROUP eye_vertical_step_$chan PARAMETER

    add_parameter eye_interpolate_$chan BOOLEAN "true"
    set_parameter_property eye_interpolate_$chan DISPLAY_NAME "Interpolate data"
    set_parameter_property eye_interpolate_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_interpolate_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_interpolate_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_CONTROLS_DISPLAY_GROUP] "/"]
    set_parameter_property eye_interpolate_$chan DESCRIPTION "This parameter controls whether the data of the eye diagram is interpolated"
    add_display_item $EYE_CONTROL_GROUP eye_interpolate_$chan PARAMETER

    set EYE_RLC_GROUP "Eye_RLC_controls_$chan"
    set EYE_RLC_DISPLAY_GROUP "Eye Dwell Controls"
    add_display_item $top_level_eye_group $EYE_RLC_GROUP GROUP
    set_display_item_property $EYE_RLC_GROUP DISPLAY_NAME $EYE_RLC_DISPLAY_GROUP
    
    add_parameter eye_rlc_test_at_least_$chan FLOAT "1e8"
    set_parameter_property eye_rlc_test_at_least_$chan DISPLAY_NAME "Test at least"
    set_parameter_property eye_rlc_test_at_least_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_rlc_test_at_least_$chan ALLOWED_RANGES "1:"
    set_parameter_property eye_rlc_test_at_least_$chan UNITS bits
    set_parameter_property eye_rlc_test_at_least_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_rlc_test_at_least_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_RLC_DISPLAY_GROUP] "/"]
    set_parameter_property eye_rlc_test_at_least_$chan DESCRIPTION "This parameter controls the minimum number of bits test on the edges of the eye diagram"
    add_display_item $EYE_RLC_GROUP eye_rlc_test_at_least_$chan PARAMETER
    
    add_parameter eye_rlc_stop_if_ber_below_$chan FLOAT "1e-12"
    set_parameter_property eye_rlc_stop_if_ber_below_$chan DISPLAY_NAME "Stop if BER below"
    set_parameter_property eye_rlc_stop_if_ber_below_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_rlc_stop_if_ber_below_$chan ALLOWED_RANGES "1e-15:0.1"
    set_parameter_property eye_rlc_stop_if_ber_below_$chan UNITS bits
    set_parameter_property eye_rlc_stop_if_ber_below_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_rlc_stop_if_ber_below_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_RLC_DISPLAY_GROUP] "/"]
    set_parameter_property eye_rlc_stop_if_ber_below_$chan DESCRIPTION "This parameter controls the minimum BER value that the eye diagram will stop testing"
    add_display_item $EYE_RLC_GROUP eye_rlc_stop_if_ber_below_$chan PARAMETER
    
    add_parameter eye_rlc_stop_if_ber_above_$chan FLOAT "1e-3"
    set_parameter_property eye_rlc_stop_if_ber_above_$chan DISPLAY_NAME "Stop if BER above"
    set_parameter_property eye_rlc_stop_if_ber_above_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_rlc_stop_if_ber_above_$chan ALLOWED_RANGES "0:1"
    set_parameter_property eye_rlc_stop_if_ber_above_$chan UNITS bits
    set_parameter_property eye_rlc_stop_if_ber_above_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_rlc_stop_if_ber_above_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_RLC_DISPLAY_GROUP] "/"]
    set_parameter_property eye_rlc_stop_if_ber_above_$chan DESCRIPTION "This parameter controls the maximum BER value that the eye diagram will stop testing"
    add_display_item $EYE_RLC_GROUP eye_rlc_stop_if_ber_above_$chan PARAMETER

    add_parameter eye_use_minimum_timeout_$chan BOOLEAN "false"
    set_parameter_property eye_use_minimum_timeout_$chan DISPLAY_NAME "Use minimum timeout"
    set_parameter_property eye_use_minimum_timeout_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_use_minimum_timeout_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_use_minimum_timeout_$chan DISPLAY_GROUP [join [list $RX_DISPLAY_GROUP $EYE_RLC_DISPLAY_GROUP] "/"]
    set_parameter_property eye_use_minimum_timeout_$chan DESCRIPTION "Use minimum timeout. Will restrict the amount of bits that will be tested"
    add_display_item $EYE_RLC_GROUP eye_use_minimum_timeout_$chan PARAMETER
    
    # Eye Viewer statistics
    add_parameter eye_width_$chan INTEGER "-1"
    set_parameter_property eye_width_$chan DISPLAY_NAME "Eye Width"
    set_parameter_property eye_width_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_width_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property eye_width_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_width_$chan EYE_STATISTIC TRUE
    set_parameter_property eye_width_$chan VISIBLE false
    set_parameter_property eye_width_$chan QUALITY_COMPARISON_CALLBACK builtins::numeric_bigger_better_integer
    add_display_item $EYE_CONTROL_GROUP eye_width_$chan PARAMETER
    
    add_parameter eye_height_$chan INTEGER "-1"
    set_parameter_property eye_height_$chan DISPLAY_NAME "Eye Height"
    set_parameter_property eye_height_$chan AFFECTS_ELABORATION false
    set_parameter_property eye_height_$chan ALLOWS_AUTOSWEEP "false"
    set_parameter_property eye_height_$chan ALLOWS_CHARTING "false"
    set_parameter_property eye_height_$chan EYE_STATISTIC TRUE
    set_parameter_property eye_height_$chan VISIBLE false
    set_parameter_property eye_height_$chan QUALITY_COMPARISON_CALLBACK builtins::numeric_bigger_better_integer
    add_display_item $EYE_CONTROL_GROUP eye_height_$chan PARAMETER
}

proc declare_global_channel {} {
    global UNDEFINED

    # PHY Info
    set GXB_INFO_GROUP "gxb_info"
    add_display_item "" $GXB_INFO_GROUP GROUP
    set_display_item_property $GXB_INFO_GROUP DISPLAY_NAME "H-Tile Transceiver Native PHY Parameterizations"
    
    add_display_item $GXB_INFO_GROUP background_cal_warning_text_item TEXT
    set_display_item_property background_cal_warning_text_item TEXT [c2_utilities::gui::get_label_text $c2_messages::background_cal_warning_msg "orange"]

    # Device OPN sopcinfo parameter
    declare_read_only_parameter "device_name" "Device OPN" $GXB_INFO_GROUP $UNDEFINED
    
    # Device revision sopcinfo parameter
    declare_read_only_parameter "device_revision" "Device Revison" $GXB_INFO_GROUP $UNDEFINED

    # Number of channels soft register
    declare_read_only_parameter "num_channels_soft_register" "Number of Channels soft register" $GXB_INFO_GROUP $UNDEFINED
    
    # Duplex mode soft register
    declare_read_only_parameter "duplex_mode_soft_register" "Duplex Mode soft register" $GXB_INFO_GROUP $UNDEFINED
    
    # Channel type sopcinfo parameter
    declare_read_only_parameter "channel_type" "Channel Type" $GXB_INFO_GROUP $UNDEFINED
    
    # Background Cal enabled sopcinfo parameter
    declare_read_only_parameter "background_cal_enabled" "Background Calibration Enabled" $GXB_INFO_GROUP $UNDEFINED
    
    # PMA Mode sopcinfo parameter
    declare_read_only_parameter "pma_mode" "PMA Mode" $GXB_INFO_GROUP $UNDEFINED
    
    # Protocol Mode sopcinfo parameter
    declare_read_only_parameter "prot_mode" "Protocol Mode" $GXB_INFO_GROUP $UNDEFINED
    
    set GXB_CONTROL_GROUP "gxb_controls"
    add_display_item "" $GXB_CONTROL_GROUP GROUP
    set_display_item_property $GXB_CONTROL_GROUP DISPLAY_NAME "Toolkit Settings"

    # Digital reset all channels button
    add_display_item $GXB_CONTROL_GROUP reset_phy ACTION reset_phy_callback
    set_display_item_property reset_phy DISPLAY_NAME "Digital Reset All Channels"

    # Refresh all channels button
    add_display_item $GXB_CONTROL_GROUP refresh_all_channels ACTION refresh_all_channels
    set_display_item_property refresh_all_channels DISPLAY_NAME "Refresh All Channels"

    # Auto refresh rate
    add_parameter auto_refresh_rate_seconds INTEGER 1
    set_parameter_property auto_refresh_rate_seconds DISPLAY_NAME "Auto refresh period (seconds)"
    set_parameter_property auto_refresh_rate_seconds ALLOWED_RANGES "1:60"
    set_parameter_property auto_refresh_rate_seconds AFFECTS_ELABORATION false
    set_parameter_property auto_refresh_rate_seconds ALLOWS_AUTOSWEEP "false"
    add_display_item $GXB_CONTROL_GROUP auto_refresh_rate_seconds PARAMETER

    # Global AutoSweep controls
    set AUTOSWEEP_CONTROL_GROUP "autosweep_settings"
    add_display_item "" $AUTOSWEEP_CONTROL_GROUP GROUP
    set_display_item_property $AUTOSWEEP_CONTROL_GROUP DISPLAY_NAME "Autosweep Settings"

    # Case length ms
    add_parameter autosweep_case_length_seconds INTEGER 2
    set_parameter_property autosweep_case_length_seconds DISPLAY_NAME "BER test duration per case (seconds)"
    set_parameter_property autosweep_case_length_seconds ALLOWED_RANGES "0:1000"
    set_parameter_property autosweep_case_length_seconds ALLOWS_AUTOSWEEP "true"        
    set_parameter_property autosweep_case_length_seconds AFFECTS_ELABORATION false
    add_display_item $AUTOSWEEP_CONTROL_GROUP autosweep_case_length_seconds PARAMETER
}

# Declare per-channel parameters & display items.
for {set chan 0} {$chan < $MAX_SUPPORTED_CHANNELS} {incr chan} {    
    declare_tx_channel $chan
    declare_rx_channel $chan
}

declare_global_channel

proc has_rx_channels {duplex_mode} {
    return [expr {[string equal $duplex_mode "rx"] || [string equal $duplex_mode "duplex"]}]
}

proc has_tx_channels {duplex_mode} {
    return [expr {[string equal $duplex_mode "tx"] || [string equal $duplex_mode "duplex"]}]
}

# Callbacks
proc channel_callback {} {
    global num_chan
    global TX_CHAN_NAMES
    global RX_CHAN_NAMES
    
    # Determine the number of channels used by a given instance
    set num_chan [c2_utilities::sopcinfo::get_num_channels_used]
    
    # Does this PHY support RX, TX, or both?
    set duplex_mode [c2_utilities::sopcinfo::get_duplex_mode]
    
    if {[has_rx_channels $duplex_mode]} {
        for {set chan 0} {$chan < $num_chan} {incr chan} {
            set chan_name [lindex $RX_CHAN_NAMES $chan]
            add_channel $chan_name Receiver
            set_channel_property $chan_name SUPPORTS_EYE true
        }
    }

    if {[has_tx_channels $duplex_mode]} {
        for {set chan 0} {$chan < $num_chan} {incr chan} {
            set chan_name [lindex $TX_CHAN_NAMES $chan]
            add_channel $chan_name Transmitter
            set_channel_property $chan_name SUPPORTS_EYE false
        }
    }
}

proc init_c2_toolkit {} {
    set DEFAULT_PRBS_PATTERN "PRBS31"
    global num_chan
    global slave

    retreive_sopc_params
    
    send_message warning $c2_messages::background_cal_warning_msg
    
    # Claim the Transceiver Channel RX service for eye sweep
    setup_transceiver_channel_rx_services
    send_message warning "setup_transceiver_channel_rx_services done"
    
    # Claim the slave
    set slave [c2_driver_pkg::get_adme_slave_service]
    
    for {set i 0} {$i < $num_chan} {incr i} {
        c2_driver_pkg::get_arbitration $slave $i
        
        # Set an interesting PRBS pattern, not "OFF"
        if {[string equal -nocase [c2_driver_pkg::get_generator_prbs_pattern $slave $i] "PRBS_OFF"]} {
            c2_driver_pkg::set_generator_prbs_pattern $slave $i $DEFAULT_PRBS_PATTERN
        }
        if {[string equal -nocase [c2_driver_pkg::get_checker_prbs_pattern $slave $i] "PRBS_OFF"]} {
            c2_driver_pkg::set_checker_prbs_pattern $slave $i $DEFAULT_PRBS_PATTERN
        }
        
        # Update the GUI
        refresh_tx_channel $i
        refresh_rx_channel $i
    }
    
    set_parameter_value duplex_mode_soft_register [c2_driver_pkg::get_duplex_mode $slave]
    set_parameter_value num_channels_soft_register [c2_driver_pkg::get_num_channels $slave]
}

proc finalize_c2_toolkit {} {
    send_message info "Finalizing C2 toolkit..."
    global num_chan
    global slave
    
    for {set i 0} {$i < $num_chan} {incr i} {     
        if [catch {c2_driver_pkg::release_arbitration $slave $i}] {send_message warning "Failed to release arbitration while finalizing channel $i";}
    }
    
    close_service slave $slave
    close_transceiver_channel_rx_services
}

proc reset_phy_callback {} {
    global num_chan
    global slave
    for {set i 0} {$i < $num_chan} {incr i} {
        c2_driver_pkg::reset_phy $slave $i
    }
}

proc refresh_all_channels {} {
    global num_chan
    for {set i 0} {$i < $num_chan} {incr i} {
        refresh_tx_channel $i
        refresh_rx_channel $i
    }
}

proc update_bit_error_rate {chan} {
    global slave
    set combined_result [c2_driver_pkg::get_total_bits_and_error_bits $slave $chan]
    set total_bits [lindex $combined_result 0]
    set error_bits [lindex $combined_result 1]
    if {$total_bits > 0} {
        set ber [expr {double($error_bits) / double($total_bits)}]
    } else {
        set ber 0.0
    }
    set_parameter_value rx_total_bits_$chan $total_bits
    set_parameter_value rx_error_bits_$chan $error_bits
    set_parameter_value rx_ber_$chan $ber
}

proc tx_start_button_callback {chan} {
    global slave
    c2_driver_pkg::start_prbs_generator $slave $chan
    tx_update_gui_callback $chan
}

proc tx_stop_button_callback {chan} {
    global slave
    c2_driver_pkg::stop_prbs_generator $slave $chan
    tx_update_gui_callback $chan
}

proc rx_start_button_callback {chan} {
    global slave
    global RX_TIMED_CALLBACK_STATUS_MAP
    if {![c2_driver_pkg::is_prbs_checker_running $slave $chan]} {
        c2_driver_pkg::start_prbs_checker $slave $chan
    }
    if {!$RX_TIMED_CALLBACK_STATUS_MAP($chan)} {
        add_timed_callback "update_bit_error_rate $chan" 500
    }
    set RX_TIMED_CALLBACK_STATUS_MAP($chan) 1
    update_rx_checker_status $chan
}

proc rx_stop_button_callback {chan} {
    global slave
    global RX_TIMED_CALLBACK_STATUS_MAP
    c2_driver_pkg::stop_prbs_checker $slave $chan
    if {$RX_TIMED_CALLBACK_STATUS_MAP($chan)} {
        remove_timed_callback "update_bit_error_rate $chan"
        set RX_TIMED_CALLBACK_STATUS_MAP($chan) 0
    }
    update_rx_checker_status $chan
}

proc update_rx_checker_status {chan} {
    global slave
    if {[c2_driver_pkg::is_prbs_checker_running $slave $chan]} {
        set_display_hint rx_is_checking_led_$chan FOREGROUND_COLOR_LIST "Green"
    } else {
        set_display_hint rx_is_checking_led_$chan FOREGROUND_COLOR_LIST "Red"
    }
}

proc rx_reset_button_callback {chan} {
    global slave
    c2_driver_pkg::reset_checker_error_and_total_bits $slave $chan
    update_bit_error_rate $chan
}

proc show_dashboard_view_callback {} {
    show_dashboard_view
}

proc rx_live_update_all_callback {} {
    global num_chan
    set val [get_parameter_value rx_live_update_all_checkbox]
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        set_parameter_value live_update_checkbox_rx_$chan $val
    }
}

proc rx_live_update_callback {chan} {
    if {[get_parameter_value live_update_checkbox_rx_$chan]} {
        add_timed_callback [list rx_update_gui_callback $chan] [expr [get_parameter_value auto_refresh_rate_seconds]*1000]
    } else {
        remove_timed_callback [list rx_update_gui_callback $chan]
    }
}

proc tx_live_update_callback {chan} {
    if {[get_parameter_value live_update_checkbox_tx_$chan]} {
        add_timed_callback [list tx_update_gui_callback $chan] [expr [get_parameter_value auto_refresh_rate_seconds]*1000]
    } else {
        remove_timed_callback [list tx_update_gui_callback $chan]
    }
}

# Update "Auto refresh" fields in the RX GUI. From the TTK era we have:
# adaptive DFE tap values, adapted RX gain values, and CDR LTD / LTR signals.
proc rx_update_gui_callback {chan} {
    update_dfe_adaptive_taps $chan
    update_rx_gain_parameters $chan
    update_ltr_ltd $chan
    update_rx_checker_status $chan
    update_bit_error_rate $chan
}

proc tx_update_gui_callback {chan} {
    global slave
    if {[c2_driver_pkg::is_prbs_generator_running $slave $chan]} {
        set_display_hint tx_is_generating_led_$chan FOREGROUND_COLOR_LIST "Green"
    } else {
        set_display_hint tx_is_generating_led_$chan FOREGROUND_COLOR_LIST "Red"
    }
}

proc set_data_rate {} {
    global num_chan
    global DUPLEX_MODE
    
    set datarate [c2_utilities::sopcinfo::get_datarate]
    set dataratembps [expr {$datarate / 1000000.0}]
    
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        if {[has_rx_channels $DUPLEX_MODE]} {
            set_parameter_value rx_data_rate_$chan $dataratembps
        }
        if {[has_tx_channels $DUPLEX_MODE]} {
            set_parameter_value tx_data_rate_$chan $dataratembps
        }
    }
}

proc retreive_sopc_params {} {
    global DUPLEX_MODE
    set DUPLEX_MODE [c2_utilities::sopcinfo::get_duplex_mode]
    set_parameter_value background_cal_enabled [c2_utilities::sopcinfo::get_background_cal_enabled]
    set_parameter_value pma_mode [c2_utilities::sopcinfo::get_pma_mode]
    set_parameter_value prot_mode [c2_utilities::sopcinfo::get_protocol_mode]
    set_parameter_value device_revision [c2_utilities::sopcinfo::get_device_revision]
    set_parameter_value device_name [c2_utilities::sopcinfo::get_device_opn]
    set_parameter_value channel_type [c2_utilities::sopcinfo::get_channel_type]
    set_data_rate
}

# Update the adapted DFE tap values
proc update_dfe_adaptive_taps {chan} {
    global slave
    global NUM_DFE_TAPS
    set combined_str ""
    set num_taps_to_show [get_number_of_dfe_taps_to_show [get_parameter_value rx_combined_adaptation_$chan]]
    for {set tap_num 1} {$tap_num <= $num_taps_to_show} {incr tap_num} {
        set adap_val [c2_driver_pkg::get_dfe_adaptive_tap_value $slave $chan $tap_num]
        set_parameter_value rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} $adap_val
        if {[string length $combined_str] > 0} {
            set combined_str "$combined_str/$adap_val"
        } else {
            set combined_str $adap_val
        }
    }
    
    for {set tap_num 1} {$tap_num <= $NUM_DFE_TAPS} {incr tap_num} {
        if {$tap_num <= $num_taps_to_show} {
            set show "true"
        } else {
            set show "false"
        }
        set_parameter_property rx_dfe_tap_adapted_value_${tap_num}_chan_${chan} VISIBLE $show
    }
    
    if {[string length $combined_str] == 0} {
        set combined_str "Off"
    }
    
    set_parameter_value rx_combined_dfe_display_$chan $combined_str
}

# Update the locked to data, locked to ref 
proc update_ltr_ltd {chan} {
    global slave
    set ltd_ltr_list [c2_driver_pkg::get_ltd_ltr_list $slave $chan]
    set ltd [lindex $ltd_ltr_list 0]
    set ltr [lindex $ltd_ltr_list 1]
    
    if {$ltd} {
        set_display_hint ltd_led_$chan FOREGROUND_COLOR_LIST "Green"
    } else {
        set_display_hint ltd_led_$chan FOREGROUND_COLOR_LIST "Red"
    }
    
    if {$ltr} {
        set_display_hint ltr_led_$chan FOREGROUND_COLOR_LIST "Green"
    } else {
        set_display_hint ltr_led_$chan FOREGROUND_COLOR_LIST "Red"
    }
}

proc is_manual_rx_mode {mode} {
    if {[string equal -nocase $mode "Manual CTLE, Manual VGA, DFE off"]} {
        return "true"
    } else {
        return "false"
    }
}

proc get_number_of_dfe_taps_to_show {mode} {
    global NUM_DFE_TAPS
    switch -nocase $mode {
        "Manual CTLE, Manual VGA, DFE off" {
            return 0
        } 
        "Adaptive CTLE, Adaptive VGA, DFE off" {
            return 0
        }
        "Adaptive CTLE, Adaptive VGA, 1-Tap Adaptive DFE" {
            return 1
        }
        "Adaptive CTLE, Adaptive VGA, All-Tap Adaptive DFE" {
            return $NUM_DFE_TAPS
        }
    }
}

proc is_adaptive_rx_mode {mode} {
    return [expr {![is_manual_rx_mode $mode]}]
}

# Update the GUI with the current HW state of CTLE EQ Gain, CTLE AC Gain, VGA DC Gain
proc update_rx_gain_parameters {chan} {
    set manual_adaptation_mode [is_manual_rx_mode [get_parameter_value rx_combined_adaptation_$chan]]
    set_parameter_property rx_ctle_ac_gain_$chan ENABLED $manual_adaptation_mode
    set_parameter_property rx_ctle_eq_gain_$chan ENABLED $manual_adaptation_mode
    set_parameter_property rx_vga_dc_gain_$chan ENABLED $manual_adaptation_mode
    
    refresh_parameter rx_ctle_ac_gain_$chan
    refresh_parameter rx_ctle_eq_gain_$chan
    refresh_parameter rx_vga_dc_gain_$chan
}

proc restart_adaptation_callback {chan} {
    global slave
    c2_driver_pkg::restart_adaptation $slave $chan
}

proc rx_combined_adaptation_update_callback {chan} {
    update_rx_gain_parameters $chan
    update_dfe_adaptive_taps $chan
}

# Read all TX settings in the hardware and sync them to the GUI
proc refresh_tx_channel {chan} {
    global DUPLEX_MODE
    if {[has_tx_channels $DUPLEX_MODE]} {
        refresh_parameter tx_vod_$chan
        refresh_parameter tx_pre1_$chan
        refresh_parameter tx_post1_$chan
        refresh_parameter tx_static_inv_$chan
        refresh_parameter tx_test_pattern_$chan
        tx_update_gui_callback $chan
    }
}

# Read all RX settings in the hardware and sync them to the GUI
proc refresh_rx_channel {chan} {
    global DUPLEX_MODE
    if {[has_rx_channels $DUPLEX_MODE]} {
        refresh_parameter loopback_mode_$chan
        refresh_parameter rx_static_inv_$chan
        refresh_parameter rx_test_pattern_$chan
        refresh_parameter rx_combined_adaptation_$chan
        rx_update_gui_callback $chan
    }
}

# Read any changes in 'param' and sync them to the GUI
proc refresh_parameter {param} {
    set hw_val [pull_from_hardware $param]
    if {[string length $hw_val] > 0} {
        set_parameter_value $param $hw_val
    }
}

# This method is used to read the value in hardware of a given parameter so it can be used by
# 'refresh_parameter' to update the GUI with changes that may have occurred in the hardware.
# This method is expected to be used once during initialization, periodically via a timed callback,
# or by a "Refresh" button press.
proc pull_from_hardware {param} {
    global slave
    global CHANNEL_NUMBER_MAP
    set channel $CHANNEL_NUMBER_MAP([get_parameter_property $param CHANNEL])
    set manual_adaptation_mode [is_manual_rx_mode [get_parameter_value rx_combined_adaptation_$channel]]
    set ber_needs_update 0
    set adapted_dfe_values_need_update 0
    
    set hw_val ""
    switch -nocase -regexp -matchvar regexp_group $param {
        loopback_mode_([0-9]+) {
            set hw_val [c2_driver_pkg::get_loopback_mode $slave $channel]
        }
        rx_combined_adaptation_([0-9]+) {
            set hw_val [c2_driver_pkg::get_combined_adaptive_mode $slave $channel]
        }
        rx_test_pattern_([0-9]+) {
            set hw_val [c2_driver_pkg::get_checker_prbs_pattern $slave $channel]
        }
        rx_static_inv_([0-9]+) {
            set hw_val [c2_driver_pkg::get_rx_static_polarity_invert $slave $channel]
        }
        rx_vga_dc_gain_([0-9]+) {
            if {$manual_adaptation_mode} {
                set hw_val [c2_driver_pkg::get_vga_dc_gain_manual_value $slave $channel]
            } else {
                set hw_val [c2_driver_pkg::get_vga_dc_gain_adapted_value $slave $channel]            
            }
        }
        rx_ctle_eq_gain_([0-9]+) {
            if {$manual_adaptation_mode} {
                set hw_val [c2_driver_pkg::get_ctle_eq_gain_manual_value $slave $channel]
            } else {
                set hw_val [c2_driver_pkg::get_ctle_eq_gain_adapted_value $slave $channel]            
            }        
        }
        rx_ctle_ac_gain_([0-9]+) {
            if {$manual_adaptation_mode} {
                set hw_val [c2_driver_pkg::get_ctle_ac_gain_manual_value $slave $channel]
            } else {
                set hw_val [c2_driver_pkg::get_ctle_ac_gain_adapted_value $slave $channel]            
            }        
        }
        tx_test_pattern_([0-9]+) {
            set hw_val [c2_driver_pkg::get_generator_prbs_pattern $slave $channel]
        }
        tx_static_inv_([0-9]+) {
            set hw_val [c2_driver_pkg::get_tx_static_polarity_invert $slave $channel]
        }
        tx_vod_([0-9]+) {
            set hw_val [c2_driver_pkg::get_vod_value $slave $channel]
        }
        tx_pre1_([0-9]+) {
            set hw_val [c2_driver_pkg::get_preemph_tap_pre_1 $slave $channel]
        }
        tx_post1_([0-9]+) {
            set hw_val [c2_driver_pkg::get_preemph_tap_post_1 $slave $channel]
        }
        rx_ber_([0-9]+) {
            set ber_needs_update 1
        }
        rx_total_bits_([0-9]+) {
            set ber_needs_update 1
        }
        rx_error_bits_([0-9]+) {
            set ber_needs_update 1
        }
        rx_dfe_tap_adapted_value_([0-9]+)_chan_([0-9]+) {
            set adapted_dfe_values_need_update 1
        }
        default {
            send_message warning "No refresh behavior defined for parameter: $param"
        }
    }
    
    if {$ber_needs_update} {
        update_bit_error_rate $channel
    }
    if {$adapted_dfe_values_need_update} {
        update_dfe_adaptive_taps $channel
    }
    
    return $hw_val
}

# This is the elaborate callback which takes in a map of parameter names to their new values.
# We are using this callback to sync GUI changes to the HW.
proc push_to_hardware {param_map} {
    global slave
    global CHANNEL_NUMBER_MAP
    variable ::c2_messages::GXT_reverse_warning
    set len [llength $param_map]
    for {set i 0} {$i < $len} {set i [expr {$i + 2}]} {
        set param [lindex $param_map $i]
        set param_val [lindex $param_map [expr {$i + 1}]]
        if [catch {set channel $CHANNEL_NUMBER_MAP([get_parameter_property $param CHANNEL])}] {return}
        set manual_adaptation_mode [is_manual_rx_mode [get_parameter_value rx_combined_adaptation_$channel]]
        switch -nocase -regexp -matchvar regexp_group $param {
            loopback_mode_([0-9]+) {
                if {[string match "Reverse*" $param_val]} {
                    if {$GXT_reverse_warning == 0} {
                        if {[string equal -nocase [get_parameter_value channel_type] "GXT"]} {
                            send_message warning "Reverse Serial Loopback is not suggested for GXT channels. Refer to the userguide for details. This feature is added for flexibility."
                            set GXT_reverse_warning 1
                        }
                    }
                }
                c2_driver_pkg::set_loopback_mode $slave $channel $param_val
            }
            rx_combined_adaptation_([0-9]+) {
                c2_driver_pkg::set_combined_adaptive_mode $slave $channel $param_val
                update_dfe_adaptive_taps $channel
            }
            rx_vga_dc_gain_([0-9]+) {
                if {$manual_adaptation_mode} {
                    c2_driver_pkg::set_vga_dc_gain_manual_value $slave $channel $param_val
                }
            }
            rx_ctle_ac_gain_([0-9]+) {
                if {$manual_adaptation_mode} {
                    c2_driver_pkg::set_ctle_ac_gain_manual_value $slave $channel $param_val
                }
            }
            rx_ctle_eq_gain_([0-9]+) {
                if {$manual_adaptation_mode} {
                    c2_driver_pkg::set_ctle_eq_gain_manual_value $slave $channel $param_val
                }
            }
            rx_test_pattern_([0-9]+) {
                c2_driver_pkg::set_checker_prbs_pattern $slave $channel $param_val
            }
            rx_static_inv_([0-9]+) {
                c2_driver_pkg::set_rx_static_polarity_invert $slave $channel $param_val
            }
            tx_test_pattern_([0-9]+) {
                c2_driver_pkg::set_generator_prbs_pattern $slave $channel $param_val
            }
            tx_static_inv_([0-9]+) {
                c2_driver_pkg::set_tx_static_polarity_invert $slave $channel $param_val
            }
            tx_vod_([0-9]+) {
                c2_driver_pkg::set_vod_value $slave $channel $param_val
            }
            tx_pre1_([0-9]+) {
                c2_driver_pkg::set_preemph_tap_pre_1 $slave $channel $param_val
            }
            tx_post1_([0-9]+) {
                c2_driver_pkg::set_preemph_tap_post_1 $slave $channel $param_val
            }
            default {
                send_message warning "No elaboration behavior defined for parameter: $param"
            }
        }
    }
}

proc chart_callback {param_list} {
    global slave
    global CHANNEL_NUMBER_MAP
    
    set dfe_tap_channel_list [list]
    set len [llength $param_list]
    for {set i 0} {$i < $len} {incr i} {
        set param [lindex $param_list $i]
        if [catch {set channel $CHANNEL_NUMBER_MAP([get_parameter_property $param CHANNEL])}] {return}
        switch -nocase -regexp -matchvar regexp_group $param {
            rx_dfe_tap_adapted_value_([0-9]+)_chan_([0-9]+) {
                if {[lsearch $dfe_tap_channel_list $channel] < 0} {
                    lappend dfe_tap_channel_list $channel
                }
            }
            default {
                refresh_parameter $param
            }
        }
    }
    for {set i 0} {$i < [llength $dfe_tap_channel_list]} {incr i} {
        update_dfe_adaptive_taps [lindex $dfe_tap_channel_list $i]
    }
}
