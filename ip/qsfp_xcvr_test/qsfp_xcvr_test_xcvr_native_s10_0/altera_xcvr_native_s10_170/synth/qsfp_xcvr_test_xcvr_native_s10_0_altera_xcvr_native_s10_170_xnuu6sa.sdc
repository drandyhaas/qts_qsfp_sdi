# (C) 2001-2016 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# ---------------------------------------------------------------- #
# -                                                              - #
# --- THIS IS AN AUTO-GENERATED FILE!                          --- #
# --- Do not change the contents of this file.                 --- # 
# --- Your changes will be lost once the IP is regenerated!    --- #
# ---                                                          --- #
# --- This file contains the timing constraints for Native PHY --- #
# ---    * The helper functions are defined in                 --- #
# ---      alt_xcvr_native_helper_functions_xnuu6sa.tcl  --- #
# -                                                              - # 
# ---------------------------------------------------------------- #

set script_dir [file dirname [info script]] 
source "${script_dir}/qsfp_xcvr_test_xcvr_native_s10_0_altera_xcvr_native_s10_170_xnuu6sa_ip_parameters_xnuu6sa.tcl"
source "${script_dir}/alt_xcvr_native_helper_functions_xnuu6sa.tcl"

# Debug switch. Change to 1 in alt_xcvr_native_helper_functions_xnuu6sa.tcl to get more run-time debug information
if {![info exists native_debug]} {
  global ::native_debug
}

# ---------------------------------------------------------------- #
# -                                                              - #
# --- Build cache for all pins and registers required to apply --- #
# --- timing constraints                                       --- #
# -                                                              - #
# ---------------------------------------------------------------- #
if { ! [ info exists native_sdc_cache_xnuu6sa ] && !$native_debug } {
   native_initialize_db_xnuu6sa nativedb_xnuu6sa
   set native_sdc_cache_xnuu6sa 1
} else {
  if { $native_debug } {
    native_initialize_db_xnuu6sa nativedb_xnuu6sa
    post_message -type info "IP SDC: reusing cached Native PHY DB"
  }
}

# ---------------------------------------------------------------- #
# --- Set all the instances of this core                       --- #
# ---------------------------------------------------------------- #
set alt_xcvr_native_s10_instances [ dict keys $nativedb_xnuu6sa ]

if {[info exists alt_xcvr_native_s10_pins]} {
   unset alt_xcvr_native_s10_pins
}
set alt_xcvr_native_s10_pins [dict create]

# ---------------------------------------------------------------- #
# -                                                              - #
# --- Iterate through each instance and apply the necessary    --- #
# --- timing constraints                                       --- #
# -                                                              - #
# ---------------------------------------------------------------- #
foreach inst $alt_xcvr_native_s10_instances {

  if { [ dict exists $alt_xcvr_native_s10_pins $inst ] } {
    dict unset alt_xcvr_native_s10_pins $inst
    
    if { $native_debug == 1} {
      post_message -type info "IP SDC: Array pins for instance $inst existed before, unsetting them"
    }

  } 
  dict set alt_xcvr_native_s10_pins $inst [dict get $nativedb_xnuu6sa $inst]

  # Delete the clock names array if it exists 
  if [info exists all_profile_clocks_names] {
    unset all_profile_clocks_names
  }
  set all_profile_clocks_names [dict create]

  if [info exists all_pdn_clock_names] {
    unset all_pdn_clock_names
  }
  set all_pdn_clock_names [dict create]

  # -------------------------------------------------------------- #
  # --- Iterate over the profiles                              --- #
  # -------------------------------------------------------------- #
  set profile_cnt [dict get $native_phy_ip_params profile_cnt]
  for {set i 0} {$i < $profile_cnt} {incr i} {

    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: PROFILE $i"
    }

    # ------------------------------------------------------------------------------- # 
    # --- Determine the FIFO operation mode (phase-compensation or register mode) --- #
    # ------------------------------------------------------------------------------- #
    if {[dict get $native_phy_ip_params tx_fifo_mode_profile$i] == "Register"} {
      set tx_fifo_mode "register"
    } else {
      set tx_fifo_mode "pc_fifo"
    }

    if {[dict get $native_phy_ip_params rx_fifo_mode_profile$i] == "Register" || [dict get $native_phy_ip_params rx_fifo_mode_profile$i] == "Phase compensation-Register" } {
      set rx_fifo_mode "register"
    } else {
      set rx_fifo_mode "pc_fifo"
    }

    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: TX mode inferred in SDC is $tx_fifo_mode"
      post_message -type info "IP SDC: RX mode inferred in SDC is $rx_fifo_mode"
      post_message -type info "IP SDC: The procotol mode is [dict get $native_phy_ip_params protocol_mode_profile$i]"
      post_message -type info "IP SDC: The standard PCS-PMA interface width is [dict get $native_phy_ip_params std_pcs_pma_width_profile$i]"
      post_message -type info "IP SDC: The enhanced PCS-PMA interface width is [dict get $native_phy_ip_params enh_pcs_pma_width_profile$i]"
      post_message -type info "IP SDC: The data rate is [dict get $native_phy_ip_params set_data_rate_profile$i] Mbps."
    }

    set tx_fifo_transfer_mode [dict get $native_phy_ip_params l_tx_fifo_transfer_mode_profile$i]
    set rx_fifo_transfer_mode [dict get $native_phy_ip_params l_rx_fifo_transfer_mode_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Set the selected clock from mux for tx/rx_clkout and tx/rx_clkout2    --- #
    # ----------------------------------------------------------------------------- #
    set tx_clkout_sel [dict get $native_phy_ip_params tx_clkout_sel_profile$i]
    set tx_clkout2_sel [dict get $native_phy_ip_params tx_clkout2_sel_profile$i]

    set rx_clkout_sel [dict get $native_phy_ip_params rx_clkout_sel_profile$i]
    set rx_clkout2_sel [dict get $native_phy_ip_params rx_clkout2_sel_profile$i]

    set tx_transfer_clk_freq [expr double([dict get $native_phy_ip_params l_tx_transfer_clk_hz_profile$i]) / 1000000]
    set rx_transfer_clk_freq [expr double([dict get $native_phy_ip_params l_rx_transfer_clk_hz_profile$i]) / 1000000]

    if {$native_debug == 1} {
      post_message -type info "IP SDC: Clock output of tx_clkout is $tx_clkout_sel"
      post_message -type info "IP SDC: Clock output of tx_clkout2 is $tx_clkout2_sel"
      post_message -type info "IP SDC: Clock output of TX transfer clock is $tx_transfer_clk_freq MHz"
      post_message -type info "IP SDC: Clock output of rx_clkout is $rx_clkout_sel"
      post_message -type info "IP SDC: Clock output of rx_clkout2 is $rx_clkout2_sel"
      post_message -type info "IP SDC: Clock output of RX transfer clock is $rx_transfer_clk_freq MHz"
    }

    # ------------------------------------------------------------------------------ #
    # --- Determine the datapath based on the selected protocol mode             --- #
    # ------------------------------------------------------------------------------ #
    set datapath_select [dict get $native_phy_ip_params datapath_select_profile$i]
    set protocol_mode   [dict get $native_phy_ip_params protocol_mode_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Determine the PCS-PMA width based on which datapath was selected      --- #
    # ----------------------------------------------------------------------------- #
    if {$datapath_select == "Enhanced"} {
      set pcs_pma_width [dict get $native_phy_ip_params enh_pcs_pma_width_profile$i]
    } elseif {$datapath_select == "Standard"} {
      set pcs_pma_width [dict get $native_phy_ip_params std_pcs_pma_width_profile$i]
    } elseif {$datapath_select == "PCS Direct"} {
      set pcs_pma_width [dict get $native_phy_ip_params pcs_direct_width_profile$i]
    } else {
      post_message -type error "IP SDC: Datapath did not match any of the valid options (Standard, Enhanced, PCS Direct)."
    }
    
    # ----------------------------------------------------------------------------- #
    # --- Determine the pma_div_clkout factor                                   --- #
    # ----------------------------------------------------------------------------- #
    set tx_pma_div_clkout_divider [dict get $native_phy_ip_params tx_pma_div_clkout_divider_profile$i]
    set rx_pma_div_clkout_divider [dict get $native_phy_ip_params rx_pma_div_clkout_divider_profile$i]

    if {$tx_pma_div_clkout_divider == 0} {
      set tx_pma_div_clkout_divider 1
    }
    if {$rx_pma_div_clkout_divider == 0} {
      set rx_pma_div_clkout_divider 1
    }

    # ----------------------------------------------------------------------------- #
    # --- Byte serializer and byte deserializer                                 --- #
    # ----------------------------------------------------------------------------- #
    set std_tx_byte_ser_mode [dict get $native_phy_ip_params std_tx_byte_ser_mode_profile$i]
    if {$std_tx_byte_ser_mode == "Serialize x2" && $datapath_select == "Standard"} {
      set byte_ser 2
    } elseif {$std_tx_byte_ser_mode == "Serialize x4" && $datapath_select == "Standard"} {
      set byte_ser 4
    } else {
      set byte_ser 1
    }

    set std_rx_byte_deser_mode [dict get $native_phy_ip_params std_rx_byte_deser_mode_profile$i]
    if {$std_rx_byte_deser_mode == "Deserialize x2" && $datapath_select == "Standard"} {
      set byte_deser 2
    } elseif {$std_rx_byte_deser_mode == "Deserialize x4" && $datapath_select == "Standard"} {
      set byte_deser 4
    } else {
      set byte_deser 1
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: Byte serializer is $byte_ser"
      post_message -type info "IP SDC: Byte deserializer is $byte_deser"
    }

    # ----------------------------------------------------------------------------- #
    # --- Calculate the parallel PCS clock frequency                            --- #
    # ----------------------------------------------------------------------------- #
    set data_rate [expr double([dict get $native_phy_ip_params set_data_rate_profile$i])]
    set parallel_pcs_clk [ expr $data_rate / $pcs_pma_width ]

    if { $native_debug ==1 } {
      post_message -type info "IP SDC: Parallel PCS CLK is $parallel_pcs_clk MHz" 
    }

    # ----------------------------------------------------------------------------- #
    # --- Unset the profile_clocks dictionary if it exists                      --- #
    # ----------------------------------------------------------------------------- #
    if [info exists profile_clocks] {
      unset profile_clocks
    }
    set profile_clocks [dict create]

    if {[info exists freq] } {
      unset freq
    }
    set freq [dict create]

    # ----------------------------------------------------------------------------- #
    # --- Create TX mode clocks and clock frequencies                           --- #
    # ----------------------------------------------------------------------------- #
    # For each TX clock output (tx_clkout and tx_clkout2), the selected clock from
    # main adapter clock mux is checked.
    #
    # 1. PCS_CLKOUT     : frequency is PCS parallel clock (with serialization factor)
    #
    # 2. PCS_x2_CLKOUT  :
    #     - If transfer mode is x2 (full-rate) or x1x2 (double-rate): x2 parallel clock
    #           > Unless Standard PCS, PCS-PMA width == 20, and byte serializer is
    #             disabled: parallel clock
    #     - If parallel clock if transfer mode is x1 (half-rate): parallel clock
    #     - **NOTE** Native PHY parameter tx_transfer_clk_freq already accounts for 
    #                byte serializer and provides correct frequency based on transfer
    #                mode (except in case of Standard PCS, PMA-PLD = 20)
    #
    # 3. PMA_DIV_CLKOUT :
    #     - If tx_pma_div_clkout == 33, 40, 66: data rate / (pma_div * 2)
    #     - If tx_pma_div_clkout == 1, 2: parallel clock / pma_div
    #
    # **NOTE** Both FIFO (Phase-Compensation) and Register mode have the same nodes
    #          because TX Register mode is fed from the core (core_clkin)
    #
    if {[dict get $native_phy_ip_params tx_enable_profile$i]} {

      # TX_CLKOUT
      if {$tx_clkout_sel == "pcs_clkout" } {
        dict set profile_clocks tx_mode_clks tx_clkout
        dict set freq tx_clkout [expr {$parallel_pcs_clk / $byte_ser}]

      } elseif {$tx_clkout_sel == "pcs_x2_clkout" } {
        dict set profile_clocks tx_mode_clks tx_clkout
      
        if {(($tx_fifo_transfer_mode == "x2" || $tx_fifo_transfer_mode == "x1x2") &&
              $datapath_select == "Standard" && $pcs_pma_width == 20 && $std_tx_byte_ser_mode == "Disabled") ||
              ($datapath_select == "PCS Direct" && $pcs_pma_width == 20)} {
          dict set freq tx_clkout $parallel_pcs_clk
        } else {
          dict set freq tx_clkout $tx_transfer_clk_freq
        }

      } elseif {$tx_clkout_sel == "pma_div_clkout" } {
        dict set profile_clocks tx_mode_clks tx_clkout

        if {$tx_pma_div_clkout_divider == 33 || $tx_pma_div_clkout_divider == 40 || $tx_pma_div_clkout_divider == 66 } {
          dict set freq tx_clkout [expr {$data_rate / [expr $tx_pma_div_clkout_divider * 2] }]
        } else {
          dict set freq tx_clkout [expr {$parallel_pcs_clk / $tx_pma_div_clkout_divider}]
        }
      } else {
        post_message -type error "IP SDC: TX CLKOUT did not match any of the valid clock options. Check the TX Clock Options."
      }

      # TX_CLKOUT2
      if {[dict get $native_phy_ip_params enable_port_tx_clkout2_profile$i] == 1} {
        if {$tx_clkout2_sel == "pcs_clkout" } {
          dict lappend profile_clocks tx_mode_clks tx_clkout2
          dict set freq tx_clkout2 [expr {$parallel_pcs_clk / $byte_ser}]

        } elseif {$tx_clkout2_sel == "pcs_x2_clkout" } {
          dict lappend profile_clocks tx_mode_clks tx_clkout2
      
          if {(($tx_fifo_transfer_mode == "x2" || $tx_fifo_transfer_mode == "x1x2") &&
                $datapath_select == "Standard" && $pcs_pma_width == 20 && $std_tx_byte_ser_mode == "Disabled") ||
               ($datapath_select == "PCS Direct" && $pcs_pma_width == 20)} {
            dict set freq tx_clkout2 $parallel_pcs_clk
          } else {
            dict set freq tx_clkout2 $tx_transfer_clk_freq
           }
           
        } elseif {$tx_clkout2_sel == "pma_div_clkout" } {
         dict lappend profile_clocks tx_mode_clks tx_clkout2

          if {$tx_pma_div_clkout_divider == 33 || $tx_pma_div_clkout_divider == 40 || $tx_pma_div_clkout_divider == 66 } {
            dict set freq tx_clkout2 [expr {$data_rate / [expr $tx_pma_div_clkout_divider * 2] }]
          } else {
            dict set freq tx_clkout2 [expr {$parallel_pcs_clk / $tx_pma_div_clkout_divider}]
          }

        } else {
          post_message -type error "IP SDC: TX CLKOUT2 did not match any of the valid clock options. Check the TX Clock Options."
        }
      } else {
        if {$native_debug == 1} {
          post_message -type info "IP SDC: TX CLKOUT2 port is not enabled"
        }
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- Create RX mode clocks and clock frequencies                           --- #
    # ----------------------------------------------------------------------------- #
    # For each RX clock output (rx_clkout and rx_clkout2), the selected clock from
    # main adapter clock mux is checked.
    #
    # 1. PCS_CLKOUT     : frequency is PCS parallel clock (with deserialization factor)
    #
    # 2. PCS_x2_CLKOUT  :
    #     - If transfer mode is x2 (full-rate) or x1x2 (double-rate): x2 parallel clock
    #     - If parallel clock if transfer mode is x1 (half-rate): parallel clock
    #     - **NOTE** Native PHY parameter rx_transfer_clk_freq already accounts for 
    #                byte deserializer and provides correct frequency based on transfer
    #                mode
    #
    # 3. PMA_DIV_CLKOUT :
    #     - If rx_pma_div_clkout == 33, 40, 66: data rate / (pma_div * 2)
    #     - If rx_pma_div_clkout == 1, 2: parallel clock / pma_div
    #
    # **NOTE** FIFO (Phase-Compensation) and Register mode have the different nodes
    #          when selected clock is pcs_x2_clock because RX transfer clock is fed to
    #          main adapter FIFO ead and write in register mode
    #
    if {[dict get $native_phy_ip_params rx_enable_profile$i]} {

      # RX_ CLKOUT
      if {$rx_fifo_mode == "pc_fifo"} {
        if {$rx_clkout_sel == "pcs_clkout" } {
          dict set profile_clocks rx_mode_clks rx_clkout
          dict set freq rx_clkout [expr {$parallel_pcs_clk / $byte_deser}]

        } elseif {$rx_clkout_sel == "pcs_x2_clkout" } {
          dict set profile_clocks rx_mode_clks rx_clkout
          dict set freq rx_clkout $rx_transfer_clk_freq
 
        } elseif {$rx_clkout_sel == "pma_div_clkout" } {
          dict set profile_clocks rx_mode_clks rx_clkout

          if {$rx_pma_div_clkout_divider == 33 || $rx_pma_div_clkout_divider == 40 || $rx_pma_div_clkout_divider == 66 } {
            dict set freq rx_clkout [expr {$data_rate / [expr $rx_pma_div_clkout_divider * 2] }]
          } else {
            dict set freq rx_clkout [expr {$parallel_pcs_clk / $rx_pma_div_clkout_divider}]
          }

        } else {
          post_message -type error "IP SDC: RX CLKOUT did not match any of the valid clock options. Check the RX Clock Options."
        }
      } else { # RX FIFO is in register mode
        if {$rx_clkout_sel == "pcs_x2_clkout" } {
          dict set profile_clocks rx_mode_clks rx_transfer_clk
          dict set freq rx_transfer_clk $rx_transfer_clk_freq

        } else {
          post_message -type error "IP SDC: RX CLKOUT did not match any of the valid clock options. Check the RX Clock Options."
        }
      }

      # RX_CLKOUT2
      if {[dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i] == 1 && $rx_fifo_mode == "pc_fifo"} {
        if {$rx_clkout2_sel == "pcs_clkout" } {
          dict lappend profile_clocks rx_mode_clks rx_clkout2
          dict set freq rx_clkout2 [expr {$parallel_pcs_clk / $byte_deser}]

        } elseif {$rx_clkout2_sel == "pcs_x2_clkout" } {
          dict lappend profile_clocks rx_mode_clks rx_clkout2
          dict set freq rx_clkout2 $rx_transfer_clk_freq

        } elseif {$rx_clkout2_sel == "pma_div_clkout" } {
          dict lappend profile_clocks rx_mode_clks rx_clkout2

          if {$rx_pma_div_clkout_divider == 33 || $rx_pma_div_clkout_divider == 40 || $rx_pma_div_clkout_divider == 66 } {
            dict set freq rx_clkout2 [expr {$data_rate / [expr $rx_pma_div_clkout_divider * 2] }]
          } else {
            dict set freq rx_clkout2 [expr {$parallel_pcs_clk / $rx_pma_div_clkout_divider}]
          }

        } else {
          post_message -type error "IP SDC: RX CLKOUT2 did not match any of the valid clock options. Check the RX Clock Options"
        }

      } elseif {[dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i] == 1 && $rx_fifo_mode == "register"} { # RX FIFO is in register mode
        if {$rx_clkout_sel == "pcs_x2_clkout" } {
          dict lappend profile_clocks rx_mode_clks rx_transfer_clk2      
          dict set freq rx_transfer_clk2 $rx_transfer_clk_freq

        } else {
          post_message -type error "IP SDC: RX CLKOUT2 did not match any of the valid clock options. Check the RX Clock Options"
        }
      } else {
        if {$native_debug == 1} {
          post_message -type info "IP SDC: RX CLKOUT2 port is not enabled"
        }
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- Create PIPE clocks and clock frequencies                              --- #
    # ----------------------------------------------------------------------------- #

    # -------------------------------------------------------------------------------
    # HCLK
    # If we are in Gen 3 and we have hip... we have a 1Gig clock (might need to change for hip... as it comes out to the core...)
    #--------------------------------------------------------------------------------
    if {$protocol_mode == "pipe_g3" && [dict get $native_phy_ip_params enable_hip_profile$i] == 1} {
      dict set profile_clocks hclk hclk
      dict set freq hclk 1000
    } elseif {$protocol_mode == "pipe_g1" ||
              $protocol_mode == "pipe_g2" ||
              $protocol_mode == "pipe_g3"} {
      dict set profile_clocks hclk hclk
      dict set freq hclk 500
    }

    # -------------------------------------------------------------------------------
    # PIPE Gen2
    # Create Gen2 and Gen1 clocks for PIPE Gen2 and PIPE Gen3
    # -------------------------------------------------------------------------------
    if {$protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3"} {

      # TX PIPE Gen2
      dict lappend profile_clocks tx_mode_clks tx_clkout_pipe_g2
      dict set freq tx_clkout_pipe_g2 [dict get $freq tx_clkout]
      # TX PIPE Gen1
      dict lappend profile_clocks tx_mode_clks tx_clkout_pipe_g1
      dict set freq tx_clkout_pipe_g1 [expr {[dict get $freq tx_clkout_pipe_g2] / 2}]

      # Remove original tx_clkout from profile_clocks and freq dictionaries
      set list_of_tx_clkouts [dict get $profile_clocks tx_mode_clks]
      set tx_clkout_index [lsearch $list_of_tx_clkouts tx_clkout]
      if {$tx_clkout_index < 0} {
        if {$native_debug == 1} {
          post_message -type warning "IP SDC: Cannot find key tx_clkout while creating PIPE clocks in list $list_of_tx_clkouts"
        }
      } else {
        dict set profile_clocks tx_mode_clks [lreplace $list_of_tx_clkouts $tx_clkout_index $tx_clkout_index]
      }
      set freq [dict remove $freq tx_clkout]

      # TX_CLKOUT2
      if {[dict get $native_phy_ip_params enable_port_tx_clkout2_profile$i] == 1} { 
        # TX PIPE Gen2
        dict lappend profile_clocks tx_mode_clks tx_clkout2_pipe_g2
        dict set freq tx_clkout2_pipe_g2 [dict get $freq tx_clkout2]
        # TX PIPE Gen1
        dict lappend profile_clocks tx_mode_clks tx_clkout2_pipe_g1
        dict set freq tx_clkout2_pipe_g1 [expr {[dict get $freq tx_clkout2_pipe_g2] / 2}]

        # Remove original tx_clkout2 from profile_clocks and freq dictionaries
        set list_of_tx_clkouts [dict get $profile_clocks tx_mode_clks]
        set tx_clkout2_index [lsearch $list_of_tx_clkouts tx_clkout2]
        if {$tx_clkout2_index < 0} {
          if {$native_debug == 1} {
            post_message -type warning "IP SDC: Cannot find key tx_clkout2 while creating PIPE clocks in list $list_of_tx_clkouts"
          }
        } else {
          dict set profile_clocks tx_mode_clks [lreplace $list_of_tx_clkouts $tx_clkout2_index $tx_clkout2_index]
        }
        set freq [dict remove $freq tx_clkout2] 
      }

      if {$native_debug == 1} {
        post_message -type info "IP SDC: TX mode clocks - [dict get $profile_clocks tx_mode_clks]"
      }

      # RX PIPE
      if {[dict exists $profile_clocks rx_transfer_clk]} {
        # RX PIPE Gen2
        dict lappend profile_clocks rx_mode_clks rx_transfer_clk_pipe_g2
        dict set freq rx_transfer_clk_pipe_g2 [dict get $freq rx_transfer_clk]
        # RX PIPE Gen1
        dict lappend profile_clocks rx_mode_clks rx_transfer_clk_pipe_g1
        dict set freq rx_transfer_clk_pipe_g1 [expr {[dict get $freq rx_transfer_clk_pipe_g2] / 2}]

        # Remove original rx_transfer_clk from profile_clocks and freq dictionaries
        set list_of_rx_clkouts [dict get $profile_clocks rx_mode_clks]
        set rx_clkout_index [lsearch $list_of_rx_clkouts rx_transfer_clk]
        if {$rx_clkout_index < 0} {
          if {$native_debug == 1} {
            post_message -type warning "IP SDC: Cannot find key rx_transfer_clk while creating PIPE clocks in list $list_of_rx_clkouts"
          }
        } else {
          dict set profile_clocks rx_mode_clks [lreplace $list_of_rx_clkouts $rx_clkout_index $rx_clkout_index]
        }
        set freq [dict remove $freq rx_transfer_clk]

      } else {
        # RX PIPE Gen2
        dict lappend profile_clocks rx_mode_clks rx_clkout_pipe_g2
        dict set freq rx_clkout_pipe_g2 [dict get $freq rx_clkout]
        # RX PIPE Gen1
        dict lappend profile_clocks rx_mode_clks rx_clkout_pipe_g1
        dict set freq rx_clkout_pipe_g1 [expr {[dict get $freq rx_clkout_pipe_g2] / 2}]

        # Remove original rx_clkout from profile_clocks and freq dictionaries
        set list_of_rx_clkouts [dict get $profile_clocks rx_mode_clks]
        set rx_clkout_index [lsearch $list_of_rx_clkouts rx_clkout]
        if {$rx_clkout_index < 0} {
          if {$native_debug == 1} {
            post_message -type warning "IP SDC: Cannot find key rx_clkout while creating PIPE clocks in list $list_of_rx_clkouts"
          }
        } else {
          dict set profile_clocks rx_mode_clks [lreplace $list_of_rx_clkouts $rx_clkout_index $rx_clkout_index]
        }
        set freq [dict remove $freq rx_clkout]
      }

      # RX_CLKOUT2
      if {[dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i] == 1} {
        if {[dict exists $profile_clocks rx_transfer_clk2]} {
          # RX PIPE Gen2
          dict lappend profile_clocks rx_mode_clks rx_transfer_clk2_pipe_g2
          dict set freq rx_transfer_clk2_pipe_g2 [dict get $freq rx_transfer_clk2]
          # RX PIPE Gen1
          dict lappend profile_clocks rx_mode_clks rx_transfer_clk2_pipe_g1
          dict set freq rx_transfer_clk2_pipe_g1 [expr {[dict get $freq rx_transfer_clk2] / 2}]

          # Remove original rx_transfer_clk2 from profile_clocks and freq dictionaries
          set list_of_rx_clkouts [dict get $profile_clocks rx_mode_clks]
          set rx_clkout2_index [lsearch $list_of_rx_clkouts rx_transfer_clk2]
          if {$rx_clkout2_index < 0} {
            if {$native_debug == 1} {
              post_message -type warning "IP SDC: Cannot find key rx_transfer_clk2 while creating PIPE clocks in list $list_of_rx_clkouts"
            }
          } else {
            dict set profile_clocks rx_mode_clks [lreplace $list_of_rx_clkouts $rx_clkout_index $rx_clkout_index]
          }
          set freq [dict remove $freq rx_transfer_clk2]

        } else {
          # RX PIPE Gen2
          dict lappend profile_clocks rx_mode_clks rx_clkout2_pipe_g2
          dict set freq rx_clkout2_pipe_g2 [dict get $freq rx_clkout2]
          # RX PIPE Gen1
          dict lappend profile_clocks rx_mode_clks rx_clkout2_pipe_g1
          dict set freq rx_clkout2_pipe_g1 [expr {[dict get $freq rx_clkout2_pipe_g2] / 2}]

          # Remove original rx_clkout from profile_clocks and freq dictionaries
          set list_of_rx_clkouts [dict get $profile_clocks rx_mode_clks]
          set rx_clkout2_index [lsearch $list_of_rx_clkouts rx_clkout2]
          if {$rx_clkout2_index < 0} {
            if {$native_debug == 1} {
              post_message -type warning "IP SDC: Cannot find key rx_clkout2 while creating PIPE clocks in list $list_of_rx_clkouts"
            }
          } else {
            dict set profile_clocks rx_mode_clks [lreplace $list_of_rx_clkouts $rx_clkout2_index $rx_clkout2_index]
          }
          set freq [dict remove $freq rx_clkout2]
        }
      }

      if {$native_debug == 1} {
        post_message -type info "IP SDC: RX mode clocks - [dict get $profile_clocks rx_mode_clks]"
      }

    } ; # if pipe_gen2 || pipe_gen3

    # -------------------------------------------------------------------------------
    # PIPE Gen3 clock
    # -------------------------------------------------------------------------------
    if {$protocol_mode == "pipe_g3"} {

      dict lappend profile_clocks tx_mode_clks tx_clkout_pipe_g3
      dict set freq tx_clkout_pipe_g3 [expr {[dict get $freq tx_clkout_pipe_g2] * 2}]

      if {[dict get $native_phy_ip_params enable_port_tx_clkout2_profile$i] == 1} {
        dict lappend profile_clocks tx_mode_clks tx_clkout2_pipe_g3
        dict set freq tx_clkout2_pipe_g3 [expr {[dict get $freq tx_clkout2_pipe_g2] * 2}]
      }

      if {[dict exists $profile_clocks rx_transfer_clk]} {
        dict lappend profile_clocks rx_mode_clks rx_transfer_clk_pipe_g3
        dict set freq rx_transfer_clk_pipe_g3 [expr {[dict get $freq rx_transfer_clk_pipe_g2] * 2}]
      } else {
        dict lappend profile_clocks rx_mode_clks rx_clkout_pipe_g3
        dict set freq rx_clkout_pipe_g3 [expr {[dict get $freq rx_clkout_pipe_g2] * 2}]
      }

      if {[dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i] == 1} {
        if {[dict exists $profile_clocks rx_transfer_clk2]} {
          dict lappend profile_clocks rx_mode_clks rx_transfer_clk2_pipe_g3
          dict set freq rx_transfer_clk2_pipe_g3 [expr {[dict get $freq rx_transfer_clk2_pipe_g2] * 2}]  
        } else {
          dict lappend profile_clocks rx_mode_clks rx_clkout2_pipe_g3
          dict set freq rx_clkout2_pipe_g3 [expr {[dict get $freq rx_clkout2_pipe_g2] * 2}]
        }
      }
    }

    if { $native_debug == 1 } {
      dict for {key clocks} $profile_clocks {
        post_message -type info "IP SDC: Profile Clocks are $key:$clocks"
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- Round the clock frequencies to 6 decimal places or less               --- #
    # ----------------------------------------------------------------------------- #
    dict for {clk freq_clk} $freq {
      set freq_nums [split $freq_clk "."]
      if {[string length [lindex $freq_nums end]] > 6} {
        dict set freq $clk [format %.6f $freq_clk]
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- Create clocks for each mode                                           --- #
    # ----------------------------------------------------------------------------- #
    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: Creating HSSI clocks for each channel"
    }

    dict for {mode mode_clks} $profile_clocks {
      set list_of_clk_names [list]

      foreach clk_group $mode_clks { # Each mode can have multiple clocks; iterate over them
        if { $native_debug } {
          post_message -type info "IP SDC: Clock group in mode_clks is: $clk_group"
        }

        if {[dict exists $alt_xcvr_native_s10_pins $inst $clk_group]} {

          set clk_pins [dict get $alt_xcvr_native_s10_pins $inst $clk_group]

          if { $native_debug } {
            post_message -type info "IP SDC: Pins for $clk_group: $clk_pins"
          }

          if { [llength $clk_pins] > 0 } { # Check to see if the corresponding pins exists 
            set channel_number 0 
            set clk_freq [dict get $freq $clk_group]

            # Remap any backward slashes '' in the pins
            set clk_pins [string map {\\ \\\\} $clk_pins]

            # Create clks for all channels for a clk group in mode clk
            lappend list_of_clk_names [native_create_clocks_all_ch_xnuu6sa $inst $clk_group $channel_number $clk_freq $clk_pins $profile_cnt $i]
          } else {
            if {$native_debug == 1} {
              post_message -type warning "IP SDC Warning: No pins for $clk_group"
            }
          }
          dict lappend all_profile_clocks_names $i $mode $list_of_clk_names

          if {$native_debug == 1} {
            post_message -type info "IP SDC: All Profile clocks $i, $mode: [dict get $all_profile_clocks_names $i $mode]"
          }
        } else {
          if {$native_debug == 1} {
            post_message -type warning "IP SDC Warning: $clk_group key does not exist in pins dictionary"
          }
        }
      }
    }


    # ----------------------------------------------------------------------------- #
    # --- Set async clock group for PIPE clocks                                 --- #
    # ----------------------------------------------------------------------------- #
    if {$protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3"} {
      if { $native_debug } {
        post_message -type info "========================================================================================"
        post_message -type info "IP SDC: Setting async clock groups for PIPE clocks"
      }

      set arg ""
      set curr_profile_clock_names [dict get $all_profile_clocks_names $i] 

      # Construct the arguments for set_clock_groups 
      # Template: set_clock_groups -asynchronous -group {<profile0 clks>} -group {<profile1 clks>} ... 
      for {set j 1} {$j < 3} {incr j} {
        set list_pipe_clk_names ""

        dict for {mode clk_mode_names} $curr_profile_clock_names {
          if {$mode != "hclk"} {

            set pipe_regexp "*_pipe_g$j*"
            set pipe_clk_names [lsearch -all -inline $clk_mode_names $pipe_regexp]

            if {$pipe_clk_names != ""} {
              set list_pipe_clk_names [concat $list_pipe_clk_names $pipe_clk_names]
            } else {
              if { $native_debug } {
                post_message -type warning "IP SDC: Cannot match regexp $pipe_regexp with clock names in list $clk_mode_names"
              }
            }
          }
        }
        set group "-group "
        set arg [concat $arg $group] 
        set arg [concat $arg "{$list_pipe_clk_names}"]
      }

      if {$protocol_mode == "pipe_g3"} {
        set list_pipe_clk_names ""

        dict for {mode clk_mode_names} $curr_profile_clock_names {
          if {$mode != "hclk"} {

            set pipe_regexp "*_pipe_g3*"
            set pipe_clk_names [lsearch -all -inline $clk_mode_names $pipe_regexp]

            if {$pipe_clk_names != ""} {
              set list_pipe_clk_names [concat $list_pipe_clk_names $pipe_clk_names]
            } else {
              if { $native_debug } {
                post_message -type warning "IP SDC: Cannot match regexp $pipe_regexp with clock names in list $clk_mode_names"
              }
            }
          }
        }
        set group "-group "
        set arg [concat $arg $group] 
        set arg [concat $arg "{$list_pipe_clk_names}"]
      }

      set cmd ""
      set cmd [concat $cmd "set_clock_groups -asynchronous "]
      set cmd [concat $cmd $arg]
      eval $cmd

      if { $native_debug } {
        post_message -type info "IP SDC: Setting async clock groups for PIPE clocks with command $cmd"
      }
    }

    #--------------------------------------------- #
    #---                                       --- #
    #--- MAX_SKEW_CONSTRAINT FOR BONDED MODE   --- #
    #---                                       --- #
    #--------------------------------------------- #
    if {[dict get $native_phy_ip_params bonded_mode_profile$i] == "pma_pcs"} {
      if { $native_debug } {
        post_message -type info "========================================================================================"
        post_message -type info "IP SDC: Setting max skew constraints for TX digital resets in PMA-PCS bonded mode"
      }

      set max_skew_value [expr ((1/($parallel_pcs_clk / $byte_ser)) * 1000) / 2]

      # Round the clock frequencies to 6 decimal places or less 
      set max_skew_nums [split $max_skew_value "."]
      if {[string length [lindex $max_skew_nums end]] > 3} {
        set max_skew_value [format %.3f $max_skew_value]
      }

      # Set max skew constraint for TX digital resets when bonded 
      set_max_skew -exclude to_clock -from [get_registers -nowarn $inst*alt_xcvr_native_reset_seq*g_trs.tx_dig_reset_seq*aib_reset_out_stage*] -to [get_pins -nowarn -compat $inst*inst_ct1_hssi_pldadapt_tx*pld_pcs_tx_pld_rst_n]     $max_skew_value 
      set_max_skew -exclude to_clock -from [get_registers -nowarn $inst*alt_xcvr_native_reset_seq*g_trs.tx_dig_reset_seq*pcs_reset_out_stage*] -to [get_pins -nowarn -compat $inst*inst_ct1_hssi_pldadapt_tx*pld_adapter_tx_pld_rst_n] $max_skew_value
      set_max_skew -exclude to_clock -from [get_registers -nowarn $inst*alt_xcvr_native_reset_seq*g_trs.tx_dig_reset_seq*pcs_reset_out_stage*] -to [get_pins -nowarn -compat $inst*inst_ct1_hssi_pldadapt_tx*pld_tx_dll_lock_req]      $max_skew_value

    }

    #--------------------------------------------- #
    #---                                       --- #
    #--- GENERATED CLOCKS FOR PDN UNCERTAINTY  --- #
    #---                                       --- #
    #--------------------------------------------- #

    # Delete native_phy_pdn_clocks if existed before 
    if [info exists native_phy_pdn_clocks] {
  	  unset native_phy_pdn_clocks 
    }
    set native_phy_pdn_clocks [dict create]
  
    # TX PDN clocks - treat both FIFO and register mode the same
    if {[dict get $native_phy_ip_params tx_enable_profile$i]} {
      if {[dict get $native_phy_ip_params tx_coreclkin_clock_network_profile$i] == "dedicated"} {
        dict set native_phy_pdn_clocks tx_mode_clks tx_coreclkin_dcm
      } elseif {[dict get $native_phy_ip_params tx_coreclkin_clock_network_profile$i] == "rowclk"} {
        dict set native_phy_pdn_clocks tx_mode_clks tx_coreclkin_rowclk
      } else {
        post_message -type error "IP SDC: Clock network for tx_coreclkin was not recognized. Check the TX Clock Options"
      }
    }

    # RX PDN clocks
    if {[dict get $native_phy_ip_params rx_enable_profile$i]} {
      if { $rx_fifo_mode == "pc_fifo" } {

        if {[dict get $native_phy_ip_params rx_coreclkin_clock_network_profile$i] == "dedicated"} {
          dict set native_phy_pdn_clocks rx_mode_clks rx_coreclkin_dcm
        } elseif {[dict get $native_phy_ip_params rx_coreclkin_clock_network_profile$i] == "rowclk"} {
          dict set native_phy_pdn_clocks rx_mode_clks rx_coreclkin_rowclk
        } else {
          post_message -type error "IP SDC: Clock network for rx_coreclkin was not recognized. Check the RX Clock Options"
        }
 
      } elseif { $rx_fifo_mode == "register" } {
        dict set native_phy_pdn_clocks rx_mode_clks rx_clkout

        if {[dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i] == 1} {
          dict lappend native_phy_pdn_clocks rx_mode_clks rx_clkout2
        }
      }
    }
    
    dict for {mode mode_clks} $native_phy_pdn_clocks {
      if { $native_debug } {
        post_message -type info "========================================================================================"
        post_message -type info "IP SDC: Creating additional generated clocks for PDN uncertainty"
      }

      set list_of_clk_names [list]
  
      foreach clk_group $mode_clks {
        if { $native_debug } {
          post_message -type info "IP SDC: PDN clock group in $mode is: $clk_group"
        }
  
        if {[dict exists $alt_xcvr_native_s10_pins $inst $clk_group]} {
  
          set clk_pins [dict get $alt_xcvr_native_s10_pins $inst $clk_group]
  
          if { $native_debug } {
            post_message -type info "IP SDC: Pins for $clk_group: $clk_pins"
          }
  
          if {[llength $clk_pins] > 0} {
            set channel_number 0

            # Remap any backward slashes '' in the pins
            set clk_pins [string map {\\ \\\\} $clk_pins]

            lappend list_of_clk_names [native_create_pdn_clocks_all_ch_xnuu6sa $inst $clk_group $channel_number $clk_pins $profile_cnt $i]
          } else  {
            if {$native_debug == 1} {
              post_message -type warning "IP SDC Warning: No pins for $clk_group"
            }
          }

          dict lappend all_pdn_clock_names $mode $list_of_clk_names

          if {[dict exists $all_profile_clocks_names $i $mode]} {
            set native_profile_clock_list [dict get $all_profile_clocks_names $i $mode]
            set combined_profile_pdn_clock_list [concat $native_profile_clock_list $list_of_clk_names]
            set combined_profile_pdn_clock_list [join $combined_profile_pdn_clock_list]
            dict lappend all_profile_clocks_names $i $mode $combined_profile_pdn_clock_list
          }
  
        } else {
          if {$native_debug == 1} {
            post_message -type warning "IP SDC Warning: PDN $clk_group key does not exist in pins dictionary"
          }
        }
      }
      
      if {$native_debug == 1 && [dict exists $all_pdn_clock_names $mode]} {
        post_message -type info "All PDN clocks $mode: [dict get $all_pdn_clock_names $mode]"
      }
    }
  
    #--------------------------------------------- #
    #-                                         --- #
    #---  SET_CLOCK_UNCERTAINTY for PDN        --- #
    #-                                         --- #
    #--------------------------------------------- #
    if { $native_debug == 1 } {
      post_message -type info "----------------------------------------------------------------------------------------"
      post_message -type info "IP SDC: Setting HSSI PDN uncertainties"
    }
 
    # ----------------------------------------------------------------------------- #
    # --- TX MODE UNCERTAINTIES                                                 --- #
    # ----------------------------------------------------------------------------- #
    if {[dict get $native_phy_ip_params tx_enable_profile$i]} {
      if {[dict exists $all_pdn_clock_names tx_mode_clks]} {
        foreach tx_coreclkin_name [dict get $all_pdn_clock_names tx_mode_clks] {
          # C2P 
          #set_clock_uncertainty -to $tx_coreclkin_name -setup [ get_clock_uncertainty_for_hssi C2P TX_FIFO setup ]ps
          #set_clock_uncertainty -to $tx_coreclkin_name -hold  [ get_clock_uncertainty_for_hssi C2P TX_FIFO hold ]ps
    
          # P2C
          #set_clock_uncertainty -from $tx_coreclkin_name -setup [ get_clock_uncertainty_for_hssi P2C TX_FIFO setup ]ps
          #set_clock_uncertainty -from $tx_coreclkin_name -hold  [ get_clock_uncertainty_for_hssi P2C TX_FIFO hold ]ps  
        }
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- RX MODE UNCERTAINTIES                                                 --- #
    # ----------------------------------------------------------------------------- #
    if {[dict get $native_phy_ip_params rx_enable_profile$i]} {
      if { $rx_fifo_mode == "pc_fifo" } {

        if {[dict exists $all_pdn_clock_names rx_mode_clks]} {
          foreach rx_coreclkin_name [dict get $all_pdn_clock_names rx_mode_clks] {
            # C2P 
            #set_clock_uncertainty -to $rx_coreclkin_name -setup [ get_clock_uncertainty_for_hssi C2P RX_FIFO setup ]ps
            #set_clock_uncertainty -to $rx_coreclkin_name -hold  [ get_clock_uncertainty_for_hssi C2P RX_FIFO hold  ]ps
  
            # P2C
            #set_clock_uncertainty -from $rx_coreclkin_name -setup [ get_clock_uncertainty_for_hssi P2C RX_FIFO setup ]ps
            #set_clock_uncertainty -from $rx_coreclkin_name -hold  [ get_clock_uncertainty_for_hssi P2C RX_FIFO hold  ]ps  
          }
        }
      } elseif { $rx_fifo_mode == "register" } {

        if {[dict exists $all_profile_clocks_names $i rx_mode_clks]} {
          set list_rx_transfer_clocks [list]
          set list_rx_transfer_clocks [dict get $all_profile_clocks_names $i rx_mode_clks]  
          
          foreach rx_transfer_clk_name list_rx_transfer_clocks {
            # P2C 
            #set_clock_uncertainty -from $rx_transfer_clk_name -setup [ get_clock_uncertainty_for_hssi P2C RX_REGISTER_8G_PCLK setup ]ps
            #set_clock_uncertainty -from $rx_transfer_clk_name -hold  [ get_clock_uncertainty_for_hssi P2C RX_REGISTER_8G_PCLK hold  ]ps

            # C2P 
            #set_clock_uncertainty -to $rx_transfer_clk_name -setup [ get_clock_uncertainty_for_hssi C2P RX_REGISTER_8G_PCLK setup ]ps
            #set_clock_uncertainty -to $rx_transfer_clk_name -hold  [ get_clock_uncertainty_for_hssi C2P RX_REGISTER_8G_PCLK hold  ]ps
          }
        }
      } else {
          post_message -type error "IP SDC: RX FIFO mode does not match a valid mode. Check RX Clock Options"
      }
    }
     
  } ; # foreach profile


  #--------------------------------------------- #
  #---                                       --- #
  #--- ASYNC CLOCK GROUP FOR RECONFIGURATION --- #
  #---                                       --- #
  #--------------------------------------------- #
  if {$profile_cnt > 1 } {
    if { $native_debug == 1 } {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: Setting async clock groups for multi-profile"
    }

    set arg ""

    for {set i 0} {$i < $profile_cnt} {incr i} {
      set profile_clk_names ""

      dict for {mode clk_name} $profile_clocks {
        # Construct the arguments for set_clock_groups 
        # Template: set_clock_groups -asynchronous -group {<profile0 clks>} -group {<profile1 clks>} ...
        if {[dict exists $all_profile_clocks_names $i $mode]} {
          set profile_clk_names [concat $profile_clk_names [dict get $all_profile_clocks_names $i $mode]]
        }
      }

      set profile_clk_names [join $profile_clk_names]
      set group "-group "
      set arg [concat $arg $group] 
      set arg [concat $arg "{$profile_clk_names}"]

      if { $native_debug } {
        post_message -type info "IP SDC: Profile $i clocks: $profile_clk_names"
      }
    }

    set cmd ""
    set cmd [concat $cmd "set_clock_groups -asynchronous "]
    set cmd [concat $cmd $arg]
    eval $cmd

    if { $native_debug } {
      post_message -type info "IP SDC: Setting async clock groups for reconfiguration: $cmd"
    }

  }

  #--------------------------------------------- #
  #---                                       --- #
  #--- SET_FALSE_PATH to reset synchronizers --- #
  #---                                       --- #
  #--------------------------------------------- #
  
  # TX and RX analog reset synchronizers
  set tx_analog_reset_resync_reg [get_keepers -nowarn $inst*g_trs.tx_anlg_reset_seq|g_anlg_trs_inst*reset_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set rx_analog_reset_resync_reg [get_keepers -nowarn $inst*g_trs.rx_anlg_reset_seq|g_anlg_trs_inst*reset_synchronizers|resync_chains*.synchronizer_nocut|din_s1]

  # TX and RX digital reset synchronizers
  set tx_digital_reset_resync_reg             [get_keepers -nowarn $inst*g_trs.tx_dig_reset_seq|reset_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set tx_digital_transfer_ready_resync_reg    [get_keepers -nowarn $inst*g_trs.tx_dig_reset_seq|transfer_ready_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set tx_digital_release_aib_first_resync_reg [get_keepers -nowarn $inst*g_trs.tx_dig_reset_seq|release_aib_first_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set rx_digital_reset_resync_reg             [get_keepers -nowarn $inst*g_trs.rx_dig_reset_seq|reset_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set rx_digital_transfer_ready_resync_reg    [get_keepers -nowarn $inst*g_trs.rx_dig_reset_seq|transfer_ready_synchronizers|resync_chains*.synchronizer_nocut|din_s1]
  set rx_digital_release_aib_first_resync_reg [get_keepers -nowarn $inst*g_trs.rx_dig_reset_seq|release_aib_first_synchronizers|resync_chains*.synchronizer_nocut|din_s1]

    
  # TX reset synchronizers
  if {[dict get $native_phy_ip_params tx_enable_profile0]} {

    # TX analog resets
    if {[get_collection_size $tx_analog_reset_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_analog_reset_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    # TX digital resets
    if {[get_collection_size $tx_digital_reset_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_digital_reset_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    if {[get_collection_size $tx_digital_transfer_ready_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_digital_transfer_ready_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    if {[get_collection_size $tx_digital_release_aib_first_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_digital_release_aib_first_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }
  }

  # RX reset synchronizers
  if {[dict get $native_phy_ip_params rx_enable_profile0]} {

    # RX analog resets
     if {[get_collection_size $rx_analog_reset_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_analog_reset_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    # RX digital resets
    if {[get_collection_size $rx_digital_reset_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_digital_reset_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    if {[get_collection_size $rx_digital_transfer_ready_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_digital_transfer_ready_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg] 
      }
    }

    if {[get_collection_size $rx_digital_release_aib_first_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_digital_release_aib_first_resync_reg {
        set_false_path -to [get_node_info -name $resync_reg]
      }
    }
  }


  #--------------------------------------------- #
  #---                                       --- #
  #--- MIN & MAX DELAYS FOR RESETS           --- #
  #---                                       --- #
  #--------------------------------------------- #

  if {[dict get $native_phy_ip_params tx_enable_profile0]} {

    # TX PMA resets
    set tx_analog_reset_reg   [get_registers -nowarn *$inst*g_trs.tx_anlg_reset_seq|reset_out_stage*]
    set tx_pld_pma_reset_atom [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb]
    set tx_pld_pma_reset_pins [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb*]
    
    if {[get_collection_size $tx_analog_reset_reg] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find registers for TX analog resets"
      }

    } elseif {[get_collection_size $tx_pld_pma_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX PMA reset atom"
      }

    } elseif {[get_collection_size $tx_pld_pma_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX PMA reset atom"
      }

    } else {
      set_max_delay -from $tx_analog_reset_reg -through $tx_pld_pma_reset_atom -to $tx_pld_pma_reset_pins 15
      set_min_delay -from $tx_analog_reset_reg -through $tx_pld_pma_reset_atom -to $tx_pld_pma_reset_pins -5
    }

    # TX PCS resets
    set tx_digital_pcs_reset_reg [get_registers -nowarn *$inst*g_trs.tx_dig_reset_seq|pcs_reset_out_stage*]
    set tx_pld_pcs_reset_atom    [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_pld_rst_n]
    set tx_pld_pcs_reset_pins    [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_pld_rst_n*]
    
    if {[get_collection_size $tx_digital_pcs_reset_reg] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX digital PCS resets"
      }

    } elseif {[get_collection_size $tx_pld_pcs_reset_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX PCS reset atom"
      }

    } elseif {[get_collection_size $tx_pld_pcs_reset_pins] == 0} {
        if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX PCS reset atom"
      }

   } else {
      set_max_delay -from $tx_digital_pcs_reset_reg -through $tx_pld_pcs_reset_atom -to $tx_pld_pcs_reset_pins 15
      set_min_delay -from $tx_digital_pcs_reset_reg -through $tx_pld_pcs_reset_atom -to $tx_pld_pcs_reset_pins -5
    }

    # TX AIB/adapter resets
    set tx_digital_aib_reset_reg   [get_registers -nowarn *$inst*g_trs.tx_dig_reset_seq|aib_reset_out_stage*]
    set tx_pld_adapter_reset_atom  [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n]
    set tx_pld_adapter_reset_pins  [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n*]
    set tx_pld_dll_lock_req_atom   [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_tx_dll_lock_req]
    set tx_pld_dll_lock_req_pins   [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_tx|pld_tx_dll_lock_req*]

    if {[get_collection_size $tx_digital_aib_reset_reg] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX digital AIB/adapter resets"
      }

    } elseif {[get_collection_size $tx_pld_adapter_reset_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $tx_pld_adapter_reset_pins] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $tx_pld_dll_lock_req_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX DLL lock request atom"
      }

    } elseif {[get_collection_size $tx_pld_dll_lock_req_pins] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX DLL lock request atom"
      }

    } else {
      set_max_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom -to $tx_pld_adapter_reset_pins 15
      set_min_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom -to $tx_pld_adapter_reset_pins -5

      set_max_delay -from $tx_digital_aib_reset_reg -through $tx_pld_dll_lock_req_atom -to $tx_pld_dll_lock_req_pins 15
      set_min_delay -from $tx_digital_aib_reset_reg -through $tx_pld_dll_lock_req_atom -to $tx_pld_dll_lock_req_pins -5

    }

  }

  if {[dict get $native_phy_ip_params rx_enable_profile0]} {
  
    # RX PMA resets
    set rx_analog_reset_reg   [get_registers -nowarn *$inst*g_trs.rx_anlg_reset_seq|reset_out_stage*]
    set rx_pld_pma_reset_atom [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb]
    set rx_pld_pma_reset_pins [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb*]
    
    if {[get_collection_size $rx_analog_reset_reg] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find registers for RX analog resets"
      }

    } elseif {[get_collection_size $rx_pld_pma_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX PMA reset atom"
      }

    } elseif {[get_collection_size $rx_pld_pma_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX PMA reset atom"
      }

    } else {
      set_max_delay -from $rx_analog_reset_reg -through $rx_pld_pma_reset_atom -to $rx_pld_pma_reset_pins 15
      set_min_delay -from $rx_analog_reset_reg -through $rx_pld_pma_reset_atom -to $rx_pld_pma_reset_pins -5
    }

    # RX PCS resets
    set rx_digital_pcs_reset_reg [get_registers -nowarn *$inst*g_trs.rx_dig_reset_seq|pcs_reset_out_stage*]
    set rx_pld_pcs_reset_atom    [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_pld_rst_n]
    set rx_pld_pcs_reset_pins    [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_pld_rst_n*]
    
    if {[get_collection_size $rx_digital_pcs_reset_reg] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX digital PCS resets"
      }

    } elseif {[get_collection_size $rx_pld_pcs_reset_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX PCS reset atom"
      }

    } elseif {[get_collection_size $rx_pld_pcs_reset_pins] == 0} {
        if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX PCS reset atom"
      }

   } else {
      set_max_delay -from $rx_digital_pcs_reset_reg -through $rx_pld_pcs_reset_atom -to $rx_pld_pcs_reset_pins 15
      set_min_delay -from $rx_digital_pcs_reset_reg -through $rx_pld_pcs_reset_atom -to $rx_pld_pcs_reset_pins -5
    }

    # RX AIB/adapter resets
    set rx_digital_aib_reset_reg   [get_registers -nowarn *$inst*g_trs.rx_dig_reset_seq|aib_reset_out_stage*]
    set rx_pld_adapter_reset_atom  [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n]
    set rx_pld_adapter_reset_pins  [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n*]
    set rx_pld_dll_lock_req_atom   [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_rx_dll_lock_req]
    set rx_pld_dll_lock_req_pins   [get_pins -compat -nowarn *$inst*inst_ct1_hssi_pldadapt_rx|pld_rx_dll_lock_req*]

    if {[get_collection_size $rx_digital_aib_reset_reg] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX digital AIB/adapter resets"
      }

    } elseif {[get_collection_size $rx_pld_adapter_reset_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $rx_pld_adapter_reset_pins] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $rx_pld_dll_lock_req_atom] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX DLL lock request atom"
      }

    } elseif {[get_collection_size $rx_pld_dll_lock_req_pins] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX DLL lock request atom"
      }

    } else {
      set_max_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom -to $rx_pld_adapter_reset_pins 15
      set_min_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom -to $rx_pld_adapter_reset_pins -5

      set_max_delay -from $rx_digital_aib_reset_reg -through $rx_pld_dll_lock_req_atom -to $rx_pld_dll_lock_req_pins 15
      set_min_delay -from $rx_digital_aib_reset_reg -through $rx_pld_dll_lock_req_atom -to $rx_pld_dll_lock_req_pins -5

    }
  }

  #--------------------------------------------- #
  #---                                       --- #
  #--- PRBS constraints                      --- #
  #---                                       --- #
  #--------------------------------------------- #
  
  # Check that reconfiguration is enabled and soft logic for doing prbs bit and error accumulation when using the hard prbs generator and checker is enabled
  if {[dict get $native_phy_ip_params rcfg_enable_profile0] && [dict get $native_phy_ip_params set_prbs_soft_logic_enable_profile0]} {

    if { [get_collection_size [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_prbs_err_snapshot*]] > 0 } {
      
      # When using the PRBS Error Accumulation logic, set multicycle constraints to reduce routing effor and congestion.  
      set_max_delay -from [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_prbs_err_snapshot*] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|avmm_prbs_err_count*] 15
      set_min_delay -from [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_prbs_err_snapshot*] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|avmm_prbs_err_count*] -8
  
      # Set false paths for the asynchronous resets no-cut synchronizers
      set_false_path -through [get_pins -nowarn -compat  $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_reset_sync*resync_chains*.synchronizer_nocut|din_s1|clrn] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_reset_sync*resync_chains*.synchronizer_nocut|din_s1]
      set_false_path -through [get_pins -nowarn -compat  $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_reset_sync*resync_chains*.synchronizer_nocut|dreg*|clrn]  -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_reset_sync*resync_chains*.synchronizer_nocut|dreg[?]]
      
      set_false_path -from    [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*avmm_csr_enabled*embedded_debug_soft_csr*prbs_reg*] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_reset_sync*resync_chains*.synchronizer_nocut|din_s1]
      set_false_path -from    [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*avmm_csr_enabled*embedded_debug_soft_csr*prbs_reg*] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_reset_sync*resync_chains*.synchronizer_nocut|dreg[?]]
      
      set_false_path -through [get_pins -nowarn -compat $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_err_sync*resync_chains*.synchronizer_nocut|din_s1|clrn] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_err_sync*resync_chains*.synchronizer_nocut|din_s1]
      set_false_path -through [get_pins -nowarn -compat $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_err_sync*resync_chains*.synchronizer_nocut|dreg*|clrn] -to  [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_err_sync*resync_chains*.synchronizer_nocut|dreg[?]]
      
      set_false_path -through [get_pins -nowarn -compat $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_done_sync*resync_chains*.synchronizer_nocut|din_s1|clrn] -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_done_sync*resync_chains*.synchronizer_nocut|din_s1]
      set_false_path -through [get_pins -nowarn -compat $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_done_sync*resync_chains*.synchronizer_nocut|dreg*|clrn]  -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|rx_clk_prbs_done_sync*resync_chains*.synchronizer_nocut|dreg[?]]
      
      # Set false paths for data no-cut synchronizers
      set_false_path -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|avmm_clk_prbs_done_sync*resync_chains*.synchronizer_nocut|din_s1]
      set_false_path -to [get_registers -nowarn $inst*xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators|avmm_clk_bit_count_edge*resync_chains*.synchronizer_nocut|din_s1]

    } else {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Reconfiguration and PRBS soft accumulators are enabled, but IP SDC is unable to find any matching registers for PRBS soft accumulators"
      }
    }
  }

  #-------------------------------------------------- #
  #---                                            --- #
  #--- AVMM wrapper constraints                   --- #
  #---                                            --- #
  #-------------------------------------------------- #
  # Check that reconfiguration is enabled
  if {[dict get $native_phy_ip_params rcfg_enable_profile0]} {
    if { [get_collection_size [get_keepers -nowarn *ct1_xcvr_avmm*ct1_xcvr_avmm_soft_logic*ct1_xcvr_avmm_soft_logic_inst*]] > 0 } {

      # Set false path to avmm_reset synchronizier
      set_false_path -through [get_pins -nowarn -compat *ct1_xcvr_avmm*ct1_xcvr_avmm_soft_logic*ct1_xcvr_avmm_soft_logic_inst*sync_r[?]|clrn] -to [get_registers -nowarn *ct1_xcvr_avmm*ct1_xcvr_avmm_soft_logic*ct1_xcvr_avmm_soft_logic_inst*sync_r[?]]
    } else {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Reconfiguration is enabled, but IP SDC is unable to find any matching nodes for AVMM soft logic"
      }

    }
  }
}

post_message -type info "IP SDC: End of IP SDC file!"


