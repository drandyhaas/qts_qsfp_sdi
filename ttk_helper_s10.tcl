# ttk_helper.tcl
# Tcl procedures for Stratix10 H-TIle ES1 and beyond

puts {==============================================================================================================}
puts {This tcl file contains a number of procedures to do additional configuration and status updates for Stratix 10} 
puts {This version of the script is only for H-Tile/L-Tile ES2/ES3/Prod (not all functions work for L-Tile ES1)}
puts {This script supports also background calibration (available only on H-tile Production}
puts {Revision 4.0}
puts {Date : 08 May 2019}
puts {Author : Peter Schepers}
puts {==============================================================================================================}
puts ""



###############################################################################
# show_phys : list the native phy's in the design
# Once identified they can be addressed using the index
###############################################################################

proc show_phys {} {
set phy_list {}
set i 0 
foreach m [get_service_paths slave] {
     
     if {[string last slave $m] != -1 } {
           puts ""
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
           if {[string last xcvr_native_s10 $marker_info] != -1  } {
                     set slave_addr [dict get $marker_info BASE_ADDRESS]
													
							
							#check if background calibration is enabled
							set bg_cal [rd $m 0x0 0x542]
							

							
                     #set identifier [rd $m 0x0 0x200]
                     puts -nonewline "Phy $i  :"
                     puts -nonewline "Slave: [format 0x%x $slave_addr]  "
							if {$bg_cal != 0} {
								puts -nonewline "Background calibration Enabled"
								} else {
									puts -nonewline "Background calibration Disabled"
								}
                     #puts -nonewline "Identifier: $identifier  "
                     puts ""
                     puts "Marker info (unique identifier): $marker_info  "
           incr i
           lappend phy_list $marker_info
           }
}
}
close_service slave $m
if {$i == 0} {
puts "no Native PHY found in the design"
}
return $phy_list
}

###############################################################################
# show_atx_plls : list the plls in the design
# Once identified they can be addressed using the index
###############################################################################

proc show_atx_plls {} {
set atx_pll_list {}
set i 0 
foreach m [get_service_paths slave] {
     
     if {[string last slave $m] != -1 } {
           puts ""
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
           if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {
                     set slave_addr [dict get $marker_info BASE_ADDRESS]
                     set identifier [rd $m 0x0 0x200]
                     puts -nonewline "ATX PLL $i  :"
                     puts -nonewline "Slave: [format 0x%x $slave_addr]  "
                     puts -nonewline "Identifier: $identifier  "
                     puts ""
                     puts "Marker info (unique identifier): $marker_info  "
           incr i
           lappend atx_pll_list $marker_info
           }
}
}
close_service slave $m
if {$i == 0} {
puts "no ATX PLL found in the design"
}
return $atx_pll_list
}


###############################################################################
# show_fplls : list the fplls in the design
# Once identified they can be addressed using the index
###############################################################################

proc show_fplls {} {
set fpll_list {}
set i 0 
foreach m [get_service_paths slave] {
     
     if {[string last slave $m] != -1 } {
           puts ""
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
           if {[string last xcvr_fpll_s10 $marker_info] != -1  } {
                     set slave_addr [dict get $marker_info BASE_ADDRESS]
                     set identifier [rd $m 0x0 0x200]
                     puts -nonewline "FPLL $i  :"
                     puts -nonewline "Slave: [format 0x%x $slave_addr]  "
                     puts -nonewline "Identifier: $identifier  "
                     puts ""
                     puts "Marker info (unique identifier): $marker_info  "
           incr i
           lappend fpll_list $marker_info
           }
}
}
close_service slave $m
if {$i == 0} {
puts "no fPLL found in the design"
}
return $fpll_list
}	


###############################################################################
# read register
###############################################################################
proc rd {m base_addr offset } {
  set value [master_read_8 $m [expr $base_addr + $offset * 4] 1]

}
#puts {rd m base_addr offset }
#puts {example usage: rd $m $base_addr 0x138}
#puts ""

proc rd_mask_dec {m base_addr offset bitmask } {
  set value [master_read_8 $m [expr $base_addr + $offset * 4] 1]
  puts -nonewline [format %d [expr $value & $bitmask]]
}

proc rd_mask_hex {m base_addr offset bitmask } {
  set value [master_read_8 $m [expr $base_addr + $offset * 4] 1]
  puts -nonewline [format 0x%x [expr $value & $bitmask]]
}


###############################################################################
# read modify write register
###############################################################################

proc rmw {m base_addr offset bitmask newval} {
  # mask out the newval so that un-masked bits do not change
  set newval_masked [expr $newval & $bitmask]

  # read from data register
  set value [master_read_8 $m [expr $base_addr + $offset * 4] 1]
  
  # bitwise-AND with the negative of bitmask to clear out only the bitmask bits
  set value [expr $value & [expr 0xff & ~$bitmask]] 

  # bitwise-OR this data with the newval_masked so that only the masked bits get changed
  set value [expr $value | $newval_masked] 

  # write the new data back
  master_write_8 $m [expr $base_addr + $offset * 4] $value


}
#puts {rmw {m base_addr offset bitmask newval} }
#puts {example usage: rmw $m $base_addr 0x160 0xE 0x4}
#puts ""

	
###############################################################################		
#Do rmw for all channels
###############################################################################
proc rmw_all {offset mask newval verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
			
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]
		
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				
				rmw $m $base_addr $offset $mask $newval

				
				
				# Print info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				if {$verbose == 1} {						
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] "
			   }	
				set read_back [rd $m $base_addr $offset]
				set read_back_mask [expr [expr $read_back & $mask ]]
				if {$verbose == 1} {		
				puts -nonewline "	Newval : [format 0x%x $read_back_mask] " 
				puts ""
				}
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $i, please disable it first"
				}				
}}}}
close_service slave $m
}

puts {rmw_all {offset mask newval verbose}}
puts {example useage rmw_all 0x160 0x0E 0x03 1}
puts ""

###############################################################################		
#Do rmw for specific channel within a phy
###############################################################################
proc rmw_channel {phy index channel offset mask newval verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
         # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we're going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
			
		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

				set base_addr [expr 0x2000 * $channel]
				
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {				
		
				rmw $m $base_addr $offset $mask $newval

				
				
				# Print info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				if {$verbose == 1} {				
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] " 
				}
				set read_back [rd $m $base_addr $offset]
				set read_back_mask [expr [expr $read_back & $mask ]]
				if {$verbose == 1} {						
				puts -nonewline "	Newval : [format 0x%x $read_back_mask] " 
				puts ""
				}
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}

}}}}
close_service slave $m
}

puts {rmw_channel {phy index channel offset mask newval verbose}}
puts {example useage rmw_channel $phy 1 3 0x134 0x0F 0x03 1}
puts ""

###############################################################################		
#read a register from a specific channel in a phy
###############################################################################
proc rd_channel {phy index channel offset verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
			
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
			
		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

				set base_addr [expr 0x2000 * $channel]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				# Print info
				set identifier [rd $m 0x0 0x200]
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				if {$verbose == 1} {
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "Offset : [format 0x%x $offset] " 
				}
				set read_back [rd $m $base_addr $offset]
				if {$verbose == 1} {				
				puts -nonewline "	Read : [format 0x%x $read_back] " 
				puts ""
				}
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}
}}}}
close_service slave $m
return $read_back
}
puts {rd_channel {phy index channel offset verbose}}
puts {to read and printout use e.g. rd_channel $phy 0 3 0x134 1}
puts {when only reading without printing use e.g. set d [rd_channel $phy 0 3 0x134 0]}
puts ""

###############################################################################		
#Do read of a register for all channels
###############################################################################
proc rd_all {offset} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
			
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]
		

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				
				
				# Print info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] " 
				set read_back [rd $m $base_addr $offset ]
				puts -nonewline "	ReadValue : [format 0x%x $read_back] " 
				puts ""
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $i, please disable it first"
				}				
}}}}
close_service slave $m
}

puts {rd_all {offset}}
puts {example useage rd_all 0x160}
puts ""

###############################################################################		
#read register from atx pll
###############################################################################

proc rd_atxpll {atx_pll index offset verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {

		# Match the ATX PLL
			if {[string last [lindex $atx_pll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0
			
				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				if {$verbose == 1} {
				puts -nonewline "ATX PLL: $index "
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "Offset : [format 0x%x $offset] " 
			   }	
		
				set read_back [rd $m $base_addr $offset]
				if {$verbose == 1} {						
				puts -nonewline "	Read : [format 0x%x $read_back] " 
				puts ""
				}
			
}}}}
close_service slave $m
return $read_back
}
puts {rd_atxpll {atx_pll index offset verbose}}
puts {to read and printout use e.g. rd_atxpll $atx_pll 0 0x480 1}
puts {when only reading without printing use e.g. set d [rd_atxpll $atx_pll 0 0x480 0]}
puts ""


###############################################################################		
#RMW register to atx pll
###############################################################################

proc rmw_atxpll {atx_pll index offset mask newval verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {

		# Match the ATX PLL
			if {[string last [lindex $atx_pll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0

			rmw $m $base_addr $offset $mask $newval
			
				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				if {$verbose == 1} {		
				puts -nonewline "ATX PLL: $index "				
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "Offset : [format 0x%x $offset] " 
				}
				
				set read_back [rd $m $base_addr $offset]
				set read_back_mask [expr [expr $read_back & $mask ]]
				if {$verbose == 1} {					
				puts -nonewline "	Newval : [format 0x%x $read_back_mask] " 
				puts ""
				}
			
}}}}
close_service slave $m
}
puts {rmw_atxpll {atx_pll index offset mask newval verbose}}
puts {example rmw_atxpll $atx_pll 0 0x480 0x01 0x01 1}
puts ""



###############################################################################		
#read register from fpll
###############################################################################

proc rd_fpll {fpll index offset verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_fpll_s10 $marker_info] != -1  } {

		# Match the fPLL
			if {[string last [lindex $fpll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0
			
				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				if {$verbose == 1} {		
				puts -nonewline "fPLL: $index "					
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "Offset : [format 0x%x $offset] " 
				}
				set read_back [rd $m $base_addr $offset]
				if {$verbose == 1} {	
				puts -nonewline "	Read : [format 0x%x $read_back] " 
				puts ""
				}				

			
}}}}
close_service slave $m
return $read_back
}
puts {rd_fpll {fpll index offset verbose}}
puts {to read and printout use e.g. rd_fpll $fpll 0 0x480 1}
puts {when only reading without printing use e.g. set d [rd_fpll $fpll 0 0x480 0]}
puts ""


###############################################################################		
#RMW register to fpll
###############################################################################

proc rmw_fpll {fpll index offset mask newval verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_fpll_s10 $marker_info] != -1  } {

		# Match the fPLL
			if {[string last [lindex $fpll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0

			rmw $m $base_addr $offset $mask $newval
			
				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				if {$verbose == 1} {		
				puts -nonewline "fPLL: $index "				
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "Offset : [format 0x%x $offset] " 
				}
				
				set read_back [rd $m $base_addr $offset]
				set read_back_mask [expr [expr $read_back & $mask ]]
				if {$verbose == 1} {					
				puts -nonewline "	Newval : [format 0x%x $read_back_mask] " 
				puts ""
				}

			
}}}}
close_service slave $m
}
puts {rmw_fpll {fpll index offset mask newval verbose}}
puts {example rmw_fpll $fpll 0 0x480 0x01 0x01 1}
puts ""




###############################################################################
#Do polarity inversion on rx for $phy and $channel
###############################################################################
proc rx_polarity_inv_on {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {

		#Set rx_static_polarity_inversion bit 4 of 0xA
		rmw $m $base_addr 0xA 0x10 0x10
		
# Print info

set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	rx_static_polarity  : " 
set read_back [rd $m $base_addr 0xA]
puts -nonewline  [expr [expr $read_back & 0x10] >> 4]
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}
}}}}
close_service slave $m
}

puts {rx_polarity_inv_on {phy index channel}}
puts {example useage rx_polarity_inv_on $phy 0 2}
puts ""

###############################################################################
#Disable polarity inversion on rx  for $phy and $channel
###############################################################################
proc rx_polarity_inv_off {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				
		#Clear rx_static_polarity_inversion bit 4 of 0xA
		rmw $m $base_addr 0xA 0x10 0x00
		
# Print info
set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	rx_static_polarity  : " 
set read_back [rd $m $base_addr 0xA]
puts -nonewline  [expr [expr $read_back & 0x10] >> 4]
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}
}}}}
close_service slave $m
}

puts {rx_polarity_inv_off {phy index channel}}
puts {example useage rx_polarity_inv_off $phy 0 2}
puts ""



###############################################################################
#Do polarity inversion on tx for $phy and $channel
###############################################################################
proc tx_polarity_inv_on {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
		#Set tx_static_polarity_inversion bit 2 of 0x7
		rmw $m $base_addr 0x7 0x04 0x04
		
# Print info

set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	tx_static_polarity  : " 
set read_back [rd $m $base_addr 0x7]
puts -nonewline  [expr [expr $read_back & 0x04] >> 2]
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}
}}}}
close_service slave $m
}

puts {tx_polarity_inv_on {phy index channel}}
puts {example useage tx_polarity_inv_on $phy 0 2}
puts ""

###############################################################################
#Disable polarity inversion on rx  for $phy and $channel
###############################################################################
proc tx_polarity_inv_off {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				
		#Clear tx_static_polarity_inversion  bit 2 of 0x7
		rmw $m $base_addr 0x7 0x04 0x00
		
# Print info
set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	tx_static_polarity  : " 
set read_back [rd $m $base_addr 0x7]
puts -nonewline  [expr [expr $read_back & 0x04] >> 2]
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}
}}}}
close_service slave $m
}

puts {tx_polarity_inv_off {phy index channel}}
puts {example useage tx_polarity_inv_off $phy 0 2}
puts ""

###############################################################################
#Dump all (this can be used to add additional registers to dump the value off)
###############################################################################

proc status_dump_all {} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
		
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {				 

				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts ""

				# Identifier
				puts -nonewline "IP Identifier, 0x200, bit 7:0, " 
				puts [rd $m $base_addr 0x200]


				# Number of Channels
				puts -nonewline "Number of Channels, 0x210, bit 7:0, " 
				puts [rd $m $base_addr 0x210]

				# rx_is_lockedtodata
				puts -nonewline "rx_is_lockedtodata, 0x480, bit 0, " 
				puts [rd $m $base_addr 0x480]

				# rx_is_lockedtoref
				puts -nonewline "rx_is_lockedtoref, 0x480, bit 1, " 
				puts [rd $m $base_addr 0x480]


				# tx_cal_busy
				puts -nonewline "tx_cal_busy, 0x481, bit 0, " 
				puts [rd $m $base_addr 0x481]

				# rx_cal_busy
				puts -nonewline "rx_cal_busy, 0x481, bit 1, " 
				puts [rd $m $base_addr 0x481]


				
				

				# Serial Loopback
				puts -nonewline "Serial loopback, 0x4e1, bit 0, " 
				puts [rd $m $base_addr 0x4e1]

				# Reverse Serial Loopback
				puts -nonewline "Reverse Serial loopback, 0x132, bit 5:4, " 
				puts [rd $m $base_addr 0x132]



				puts ""
				puts ""
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $i, please disable it first"
				}				
}}}}
close_service slave $m
}

puts {status_dump_all{}}
puts {example useage status_dump_all}
puts ""



								 
proc status_dump_phy {phy index } {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
		
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]

				 				
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {	
				# Print info
				set identifier [rd $m $base_addr 0x200]
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
				puts ""

				# Identifier
				puts -nonewline "IP Identifier, 0x200, bit 7:0, " 
				puts [rd $m $base_addr 0x200]


				# Number of Channels
				puts -nonewline "Number of Channels, 0x210, bit 7:0, " 
				puts [rd $m $base_addr 0x210]

				# rx_is_lockedtodata
				puts -nonewline "rx_is_lockedtodata, 0x480, bit 0, " 
				puts [rd $m $base_addr 0x480]

				# rx_is_lockedtoref
				puts -nonewline "rx_is_lockedtoref, 0x480, bit 1, " 
				puts [rd $m $base_addr 0x480]


				# tx_cal_busy
				puts -nonewline "tx_cal_busy, 0x481, bit 0, " 
				puts [rd $m $base_addr 0x481]

				# rx_cal_busy
				puts -nonewline "rx_cal_busy, 0x481, bit 1, " 
				puts [rd $m $base_addr 0x481]


				
				

				# Serial Loopback
				puts -nonewline "Serial loopback, 0x4e1, bit 0, " 
				puts [rd $m $base_addr 0x4e1]

				# Reverse Serial Loopback
				puts -nonewline "Reverse Serial loopback, 0x132, bit 5:4, " 
				puts [rd $m $base_addr 0x132]



				puts ""
				puts ""
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}				
}}}}}
close_service slave $m
}

puts {status_dump_phy{phy index}}
puts {example useage status_dump_phy $phy 1}
puts ""


		

proc status_dump_channel {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]


				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {					 				

				# Print info
set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x [expr $base_addr]]	"
				puts ""

				# Identifier
				puts -nonewline "IP Identifier, 0x200, bit 7:0, " 
				puts [rd $m $base_addr 0x200]


				# Number of Channels
				puts -nonewline "Number of Channels, 0x210, bit 7:0, " 
				puts [rd $m $base_addr 0x210]

				# rx_is_lockedtodata
				puts -nonewline "rx_is_lockedtodata, 0x480, bit 0, " 
				puts [rd $m $base_addr 0x480]

				# rx_is_lockedtoref
				puts -nonewline "rx_is_lockedtoref, 0x480, bit 1, " 
				puts [rd $m $base_addr 0x480]


				# tx_cal_busy
				puts -nonewline "tx_cal_busy, 0x481, bit 0, " 
				puts [rd $m $base_addr 0x481]

				# rx_cal_busy
				puts -nonewline "rx_cal_busy, 0x481, bit 1, " 
				puts [rd $m $base_addr 0x481]


				
				

				# Serial Loopback
				puts -nonewline "Serial loopback, 0x4e1, bit 0, " 
				puts [rd $m $base_addr 0x4e1]

				# Reverse Serial Loopback
				puts -nonewline "Reverse Serial loopback, 0x132, bit 5:4, " 
				puts [rd $m $base_addr 0x132]



				puts ""
				puts ""
				} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}						
}}}}
close_service slave $m
}

puts {status_dump_channel{phy index channel}}
puts {example useage status_dump_channel $phy 1 3}
puts ""

###############################################################################
#raw dump of channel
###############################################################################

proc raw_dump_channel {phy index ch start_addr stop_addr} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
		
	set base_addr [expr [expr 0x2000 * $ch] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {	
				
set addr $start_addr

	for {set i 0} {$i <= [expr {$stop_addr - $start_addr}]} {incr i} {
		set d1 [rd $m $base_addr $addr]
		#puts $d1
		#puts $d2
			puts [format "ADDR: 0x%03x --> ch%d:  0x%02x" $addr $ch $d1 ]  
		incr addr
	}
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $channel of phy $index, please disable it first"
				}		
}}}}
close_service slave $m
}

puts {raw_dump_channel {phy index ch start_addr stop_addr}}
puts {example useage raw_dump_channel $phy 0 0 0x000 0x300}
puts ""

###############################################################################
#Compare differences between channels
###############################################################################

proc compare_xcvr_channels {phy index ch1 ch2 start_addr stop_addr} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
		
	set base_addr1 [expr [expr 0x2000 * $ch1] ]
	set base_addr2 [expr [expr 0x2000 * $ch2] ]
	
				set read_back [rd $m $base_addr1 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {		
	
set addr $start_addr

	for {set i 0} {$i < [expr {$stop_addr - $start_addr}]} {incr i} {
		set d1 [rd $m $base_addr1 $addr]
		set d2 [rd $m $base_addr2 $addr]
		#puts $d1
		#puts $d2
		if {[expr {$d1 ne $d2}] } {
			puts [format "ADDR: 0x%03x --> ch%d:  0x%02x   /   ch%d: 0x%02x" $addr $ch1 $d1 $ch2 $d2]  
			}
		incr addr
	}
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}		
}}}}
close_service slave $m
}

puts {compare_xcvr_channels {phy index ch1 ch2 start_addr stop_addr}}
puts {example useage compare_xcvr_channels $phy 0 3 5 0x100 0x250}
puts ""





###############################################################################
#Control serial loopback for all channels
###############################################################################
proc set_serial_loop_all {loopback} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {
		
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]				
				
				if {$bg_cal == 0} {
				
		#Bit 0 of 0x4E1.
		
		rmw $m $base_addr 0x4E1 0x01 $loopback
		


				# Print info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Loopback  : " 
				set read_back [rd $m $base_addr 0x4E1]
				puts -nonewline  [expr [expr $read_back & 0x01] ]
				puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i, please disable it first"
				}					
}}}}
close_service slave $m
}

puts {set_serial_loop_all {loopback}}
puts {example useage set_serial_loop_all 1}
puts ""


###############################################################################
#Control serial loopback for a specific phy
###############################################################################
proc set_serial_loop_phy {phy index loopback} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
		
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]
		#Bit 0 of 0x4E1.
		
			rmw $m $base_addr 0x4E1 0x01 $loopback
		
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {		

				# Print info			

				set identifier [rd $m $base_addr 0x200]
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
				puts -nonewline "	Loopback  : " 
				set read_back [rd $m $base_addr 0x4E1]
				puts -nonewline  [expr [expr $read_back & 0x01] ]
				puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}				
}}}}}
close_service slave $m
}

puts {set_serial_loop_phy {phy index loopback}}
puts {example useage set_serial_loop_phy $phy 1 1}
puts ""



###############################################################################
#Enable Reverse Serial loopback (post-CDR)to $channel in $phy 
###############################################################################
proc enable_rev_serial_post {phy index channel} {

foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	
				
#-----------------------enable reverse serial loopback (post-CDR)-----------------------#

#register 0x132[5:4] (01 for post-CDR)
rmw $m $base_addr 0x132 0x30 0x10
 
#register 0x137[7] (0 for post-CDR)
rmw $m $base_addr 0x137 0x80 0x00
 
#register 0x144[1] (1 for post-CDR)
rmw $m $base_addr 0x144 0x02 0x02

#register 0x142[4] (0 for post-CDR)
rmw $m $base_addr 0x142 0x10 0x00
 
#register 0x11D[0] (0 for post-CDR)
rmw $m $base_addr 0x11D 0x01 0x00



# Print info
set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "Identifier: $identifier  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	Post CDR loopback enabled  " 
puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}	
}}}}
close_service slave $m
}

puts {enable_rev_serial_post {phy index channel}}
puts {example useage enable_rev_serial_post $phy 0 1}
puts ""

###############################################################################
#Enable Reverse Serial loopback (pre-CDR)to $channel in $phy 
###############################################################################
proc enable_rev_serial_pre {phy index channel} {

foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	
				
# -----------------------enable reverse serial loopback (pre-CDR)-----------------------#
#register 0x132[5:4] (00 for pre-CDR)
rmw $m $base_addr 0x132 0x30 0x00
 
#register 0x137[7] (1 for pre-CDR)
rmw $m $base_addr 0x137 0x80 0x80
 
#register 0x144[1] (0 for pre-CDR)
rmw $m $base_addr 0x144 0x02 0x00

#register 0x142[4] (1 for pre-CDR)
rmw $m $base_addr 0x142 0x10 0x10
 
#register 0x11D[0] (1 for pre-CDR)
rmw $m $base_addr 0x11D 0x01 0x01



# Print info
set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "Identifier: $identifier  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "	Pre CDR loopback enabled  " 
puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}	
}}}}
close_service slave $m
}
puts {enable_rev_serial_pre {phy index channel}}
puts {example useage enable_rev_serial_pre $phy 0 1}
puts ""

###############################################################################
#Disable Reverse Serial loopback (pre or post CDR) to $channel in $phy 
###############################################################################
proc disable_rev_serial {phy index channel} {

foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 

set base_addr [expr [expr 0x2000 * $channel] ]

				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	
				
			
# -----------------------disable reverse serial loopback (pre-CDR or post-cdr)-----------#
#register 0x132[5:4] 
rmw $m $base_addr 0x132 0x30 0x00
 
#register 0x137[7] 
rmw $m $base_addr 0x137 0x80 0x00
 
#register 0x144[1] 
rmw $m $base_addr 0x144 0x02 0x00

#register 0x142[4] 
rmw $m $base_addr 0x142 0x10 0x00
 
#register 0x11D[0] 
rmw $m $base_addr 0x11D 0x01 0x00




# Print info

set identifier [rd $m $base_addr 0x200]
set slave_addr [dict get $marker_info BASE_ADDRESS]
puts -nonewline "Slave: [format 0x%x $slave_addr]  "
puts -nonewline "Identifier: $identifier  "
puts -nonewline "channel  : $channel	"
puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
puts -nonewline "Reverse Serial loopback disabled  " 
puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}	
				
}}}}
close_service slave $m
}

puts {disable_rev_serial {phy index channel}}
puts {example useage disable_rev_serial $phy 0 1}
puts ""




###############################################################################
# Recalibrate channel 
# Note that this only can be used when both Ã¯Â¿Â½Select both the Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE
# and Enable control and status registers optionsÃ¯Â¿Â½ is being done.
###############################################################################

proc recalibrate_channel {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
			
			set num_channels [rd $m 0x0 0x410]

			set base_addr [expr [expr 0x2000 * $channel] ]
			
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	

				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts ""

				# 1. Check if background_calibration is enabled
				
				# 2. Do RMW 0x03 with mask 0x03 to address 0x100 to set the Tx and Rx calibration bit 
				rmw $m $base_addr 0x100 0x03 0x03
				
				# 3. Write 0x01 to address 0x00. This lets Presice perform the calibration
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x01
				
				# 4. Read bits [1] and [0]  of 0x481 to become 0 
				set check_bits 3
				while {$check_bits != 0} { 
				set read_back [rd $m $base_addr 0x481] 
				set check_bits [expr [expr $read_back & 0x03 ] >> 0]
				}				
				# g. When bits[1] and [0] of 0x481 are  0 channel calibration has been completed
				puts "Channel recalibrated"
				puts ""
				puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}					
}}}}
close_service slave $m
}
puts {recalibrate_channel {phy index channel}}
puts {example recalibrate_channel $phy 1 0}
puts ""


###############################################################################
# Recalibrate receiver only (without impacting the transmitter) 
# Note that this only can be used when both Ã¯Â¿Â½Select both the Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE
# and Enable control and status registers optionsÃ¯Â¿Â½ is being done.
###############################################################################

proc recalibrate_rx {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
			
			set num_channels [rd $m 0x0 0x410]

			set base_addr [expr [expr 0x2000 * $channel] ]
			
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	

				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts ""

				# 1. Check if background_calibration is enabled
				
				# 2. Do RMW 0x00 with mask 0x10 to address 0x481 to set bit 4 to zero to mask out tx_cal_busy.
				rmw $m $base_addr 0x481 0x10 0x00
				
				# 3.  Do RMW 0x01 with mask 0x01 to address 0x100 to set the Rx calibration

				rmw $m $base_addr 0x100 0x01 0x01
				

			   # 4. Write 0x01 to address 0x00. This lets Presice perform the calibration
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x01
				
				# 5. Read bit [1] of 0x481 to become 0 
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x481] 
				set check_bit [expr [expr $read_back & 0x02 ] >> 1]
				}				
				# When bit[1] of 0x481 is 0 receiver calibration has been completed
				puts "receiver recalibrated"
				# 6. Do RMW 0x10 with mask 0x10 to address 0x481 to set bit 4 to one again to enable again the tx_cal_busy.
				rmw $m $base_addr 0x481 0x10 0x10				
				puts ""
				puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}					
}}}}
close_service slave $m
}
puts {recalibrate_rx {phy index channel}}
puts {example recalibrate_rx $phy 1 0}
puts ""


###############################################################################
# Recalibrate transmitter only (without impacting the receiver) 
# Note that this only can be used when both Ã¯Â¿Â½Select both the Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE
# and Enable control and status registers optionsÃ¯Â¿Â½ is being done.
###############################################################################

proc recalibrate_tx {phy index channel} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
			
			set num_channels [rd $m 0x0 0x410]

			set base_addr [expr [expr 0x2000 * $channel] ]
			
				set read_back [rd $m $base_addr 0x542]
				set bg_cal  [expr [expr $read_back & 0x01] ]		
				
				if {$bg_cal == 0} {	

				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts ""

				# 1. Check if background_calibration is enabled
				
				# 2. Do RMW 0x00 with mask 0x20 to address 0x481 to set bit 5 to zero to mask out rx_cal_busy.

				rmw $m $base_addr 0x481 0x20 0x00
				
				# 3. Do RMW 0x02 with mask 0x02 to address 0x100 to set the Tx calibration bit 

				rmw $m $base_addr 0x100 0x02 0x02

				# 4. Write 0x01 to address 0x00. This lets Presice perform the calibration
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x01
				
				# 5. Read bit [0] of 0x481 to become 0 
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x481] 
				set check_bit [expr [expr $read_back & 0x01 ] >> 0]
				}				
				#  When bit[0] of 0x481 is 0 transmitter calibration has been completed
				puts "transmitter recalibrated"
				# 6. Do RMW 0x20 with mask 0x20 to address 0x481 to set bit 5 to one again to enable again the rx_cal_busy.

				rmw $m $base_addr 0x481 0x20 0x20
				
				puts ""
				puts ""
					} else {
				puts "Operation aborted since background_calibration is enabled on channel $i of phy $index, please disable it first"
				}					
}}}}
close_service slave $m
}
puts {recalibrate_tx {phy index channel}}
puts {example recalibrate_tx $phy 1 0}
puts ""

###############################################################################
# Recalibrate ATX PLL 
# Note that this only can be used when both Ã¯Â¿Â½Select both the Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE
# and Enable control and status registers optionsÃ¯Â¿Â½ is being done.
###############################################################################

proc recalibrate_atxpll {atx_pll index} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {

		# Match the ATX PLL
			if {[string last [lindex $atx_pll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0
			


				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts ""
			
				# 1. Do direct write of 0x02 to address  0x000 to request access to internal configuration bus (do not use RMW).
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x02				

				# 2. Read bit[2] of 0x480 to check it is zero (user has control)
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x480] 
				set check_bit [expr [expr $read_back & 0x04 ] >> 2]
				}	
				
				# 3. Do RMW 0x01 with mask 0x01 to address 0x100 Ã¯Â¿Â½to enable ATX PLL calibration
				rmw $m $base_addr 0x100 0x01 0x01
				
				# 4. Do write 0x01 to address 0x000 to let the PreSice doing the calibration (No RMW)
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x01
				
				# 5. Read bit[1] of 0x480 to become 0 
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x480] 
				set check_bit [expr [expr $read_back & 0x02 ] >> 1]
				}				
				# f. When bit[1] of 0x480 is 0 ATX PLL calibration has been completed.
				puts "ATX PLL recalibrated"
				puts ""
				puts ""
}}}}
close_service slave $m
}
puts {recalibrate_atxpll {atx_pll index}}
puts {example recalibrate_atxpll $atx_pll 0}
puts ""


###############################################################################
# Recalibrate fPLL 
# Note that this only can be used when both Ã¯Â¿Â½Select both the Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE
# and Enable control and status registers optionsÃ¯Â¿Â½ is being done.
###############################################################################

proc recalibrate_fpll {fpll index} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_fpll_s10 $marker_info] != -1  } {

		# Match the fPLL
			if {[string last [lindex $fpll $index ] $marker_info] != -1 } { 
			

			set base_addr 0x0
			


				# JTAG and channel info
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				set identifier [rd $m $base_addr 0x200]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "Identifier: $identifier  "
				puts ""
			
				# 1. Do direct write of 0x02 to address  0x000 to request access to internal configuration bus (do not use RMW).
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x02			

				# 2. Read bit[2] of 0x480 to check it is zero (user has control)
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x480] 
				set check_bit [expr [expr $read_back & 0x04 ] >> 2]
				}	
				
				# 3. Do RMW 0x02 with mask 0x02 to address 0x100 Ã¯Â¿Â½to enable fPLL calibration

				rmw $m $base_addr 0x100 0x02 0x02
				
				# d. Do write 0x01 to address 0x000 to let the PreSice doing the calibration (No RMW)
				master_write_8 $m [expr $base_addr + 0x000 * 4] 0x01	
				
				# e. Read bit[1] of 0x480 to become 0 
				set check_bit 1
				while {$check_bit != 0} { 
				set read_back [rd $m $base_addr 0x480] 
				set check_bit [expr [expr $read_back & 0x02 ] >> 1]
				}				
				# f. When bit[1] Ã¯Â¿Â½of 0x480 is 0 fPLL calibration has been completed.
				puts "fPLL recalibrated"
				puts ""
				puts ""
}}}}
close_service slave $m
}
puts {recalibrate_fpll {fpll index}}
puts {example recalibrate_fpll $fpll 0}
puts ""




###############################################################################		
#dump registers from atx pll
###############################################################################
# the below is a fast method
#proc dump_atxpll {atx_pll index} {
#foreach m [get_service_paths slave] {
#
#	if {[string last slave $m] != -1 } {
#      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
#      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
#         set marker_info [marker_get_info $m] 
#         set m [claim_service slave $m ""]
#		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {
#
#		# Match the ATX PLL
#			if {[string last [lindex $atx_pll $index ] $marker_info] != -1 } { 
#			
#
#			set base_addr 0x0
#			
#				# JTAG and channel info
#				set slave_addr [dict get $marker_info BASE_ADDRESS]
#				set identifier [rd $m $base_addr 0x200]
#				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
#				puts -nonewline "Identifier: $identifier  "
#				puts ""
#		
#		set start_addr 0x102
#		set stop_addr 0x11F
#		
#		set addr $start_addr
#
#	for {set i 0} {$i < [expr {$stop_addr - $start_addr}]} {incr i} {
#		set d1 [rd $m $base_addr $addr]
#		#puts $d1
#		#if {[expr {$d1 ne $d2}] } {
#			puts [format "ADDR: 0x%03x --> pll%d:  0x%02x" $addr $index $d1]  
#		#	}
#		incr addr
#	}				
#				
#
#			
#}}}}
#close_service slave $m
#}
#puts {dump_atxpll {atx_pll index}}
#puts {example dump_atxpll $atx_pll 0}
#puts ""


proc dump_atxpll {atx_pll index start_addr stop_addr} {


	for {set i $start_addr} {$i <= [expr {$stop_addr}]} {incr i} {
	
	rd_atxpll $atx_pll $index $i 1

	}				
				

}
puts {dump_atxpll {atx_pll index start_addr stop_addr}}
puts {example dump_atxpll $atx_pll 0 0x102 0x11f}
puts ""


###############################################################################		
#compare registers between 2 atx pll's (fast method)
###############################################################################

proc compare_atxplls_fast {atx_pll index1 index2 start_addr stop_addr} {


		
for {set i $start_addr} {$i <= [expr {$stop_addr}]} {incr i} {
# PLL index 1
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {

		# Match the ATX PLL
			if {[string last [lindex $atx_pll $index1 ] $marker_info] != -1 } { 
			

			set base_addr 0x0



		set d1 [rd $m $base_addr $i]
		#puts $d1
		#if {[expr {$d1 ne $d2}] } {
		#	puts [format "ADDR: 0x%03x --> pll%d:  0x%02x" $addr $index1 $d1]  
		#	}
		
	}				
				

			
}}}
close_service slave $m

# PLL index 1
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is an ATX PLL and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_atx_pll_s10 $marker_info] != -1  } {

		# Match the ATX PLL
			if {[string last [lindex $atx_pll $index2 ] $marker_info] != -1 } { 
			

			set base_addr 0x0



		set d2 [rd $m $base_addr $i]
		#puts $d1
		#if {[expr {$d1 ne $d2}] } {
		#	puts [format "ADDR: 0x%03x --> pll%d:  0x%02x" $addr $index2 $d2]  
		#	}
		
	}				
				

			
}}}
close_service slave $m

		if {[expr {$d1 ne $d2}] } {
			puts [format "ADDR: 0x%03x --> pll%d:  0x%02x  pll%d:  0x%02x " $i $index1 $d1 $index2 $d2]  
			}

incr addr

}
}
puts {compare_atxplls_fast {atx_pll index1 index2 start_addr stop_addr}}
puts {example compare_atxplls_fast $atx_pll 0 1 0x102 0x11f}
puts ""

###############################################################################		
#compare registers between 2 atx pll's (slow but straightforward method)
###############################################################################

proc compare_atxplls {atx_pll index1 index2 start_addr stop_addr} {


		
for {set i $start_addr} {$i < [expr {$stop_addr+1}]} {incr i} {
 set d1 [ rd_atxpll $atx_pll $index1 $i 0]
 set d2 [ rd_atxpll $atx_pll $index2 $i 0]



		if {[expr {$d1 ne $d2}] } {
			puts [format "ADDR: 0x%03x --> pll%d:  0x%02x  pll%d:  0x%02x " $i $index1 $d1 $index2 $d2]  
			}


}
}
puts {compare_atxplls {atx_pll index1 index2 start_addr stop_addr} }
puts {example compare_atxplls $atx_pll 0 1 0x102 0x110 }
puts ""



###############################################################################
# Start a PRBS-31 test on all channels and enable serial loopback (TO BE CHECKED)
###############################################################################

proc start_check_serial_loop {} {


# enable serial loopback on all channels
set_serial_loop_all 1


# set prbs31 generator pattern
rmw_all 0x07 0xF0 0x00 0
rmw_all 0x08 0x10 0x10 0

# set prbs31 verifier pattern
rmw_all 0x0B 0xF0 0x00 0
rmw_all 0x0C 0x01 0x01 0


#SET GENERATOR
	#PMA data output is prbs pattern
rmw_all 0x06 0x0F 0x04 0
	#TX PCS PRBS Gen clock enable set to 1
rmw_all 0x06 0x40 0x40 0 
	#set serializer to 64-bit
rmw_all 0x110 0x07 0x03 0 

#Route PRBS to data path:
	# set rx_prbs_mode to 10g mode
rmw_all 0xB 0x02 0x02 0 
	#rx_prbs_force_signal_ok
rmw_all 0xC 0x02 0x02 0 
	#prbs9_dwidth set to prbs9_64b
rmw_all 0xC 0x08 0x00 0
	# Set deser_factor to 64-bit
rmw_all 0x13F 0x0F 0x0E 0

# TX PCS PRBS Gen clock enable set to on
rmw_all 0xA 0x80 0x80 0

# Counter enable (enables both error and bit counters)
#rmw_all 0x300 0x01 0x01 (arria10)
rmw_all 0x500 0x01 0x01 0

}
puts {start_check_serial_loop {}}
puts {example useage start_check_serial_loop }
puts ""

###############################################################################
# Start a PRBS-31 test on all channels (TO BE CHECKED)
###############################################################################


proc start_check_prbs31 {} {

# set prbs31 generator pattern
rmw_all 0x07 0xF0 0x00 0
rmw_all 0x08 0x10 0x10 0

# set prbs31 verifier pattern
rmw_all 0x0B 0xF0 0x00 0
rmw_all 0x0C 0x01 0x01 0


#SET GENERATOR
	#PMA data output is prbs pattern
rmw_all 0x06 0x0F 0x04 0
	#TX PCS PRBS Gen clock enable set to 1
rmw_all 0x06 0x40 0x40 0 
	#set serializer to 64-bit
rmw_all 0x110 0x07 0x03 0 

#Route PRBS to data path:
	# set rx_prbs_mode to 10g mode
rmw_all 0xB 0x02 0x02 0  
	#rx_prbs_force_signal_ok
rmw_all 0xC 0x02 0x02 0 
	#prbs9_dwidth set to prbs9_64b
rmw_all 0xC 0x08 0x00 0
	# Set deser_factor to 64-bit
rmw_all 0x13F 0x0F 0x0E 0

# TX PCS PRBS Gen clock enable set to on
rmw_all 0xA 0x80 0x80 0

# Counter enable (enables both error and bit counters)
#rmw_all 0x300 0x01 0x01 (arria10)
rmw_all 0x500 0x01 0x01 0

}

puts {start_check_prbs31 {}}
puts {example useage start_check_prbs31 }
puts ""

###############################################################################
# The following are examples and can be used as a reference.
###############################################################################

proc start_test {} {

start_check_prbs31
}

proc dump_debug {phy index channel} {
rd_channel $phy $index $channel 0x161 1
rd_channel $phy $index $channel 0x149 1
rd_channel $phy $index $channel 0x15F 1
rd_channel $phy $index $channel 0x148 1
rd_channel $phy $index $channel 0x14C 1
rd_channel $phy $index $channel 0x15D 1
rd_channel $phy $index $channel 0x131 1
rd_channel $phy $index $channel 0x12F 1
rd_channel $phy $index $channel 0x150 1
rd_channel $phy $index $channel 0x140 1
rd_channel $phy $index $channel 0x162 1
rd_channel $phy $index $channel 0x167 1
rd_channel $phy $index $channel 0x158 1
}

###############################################################################
# Displays the PHY's and PLL's found in the design
###############################################################################

puts {}
puts {These are the Native PHY's identified in the design : }
puts {You can use the index of the phy to identify a certain phy }
set phy [show_phys]

puts {These are the ATX PLL's identified in the design : }
puts {You can use the index of the ATX PLL to identify a certain ATX PLL }
set atx_pll [show_atx_plls]

puts {These are the FPLL's identified in the design : }
puts {You can use the index of the FPLL to identify a certain FPLL }
set fpll [show_fplls]

puts {}
puts {!!! IMPORTANT !!! if you have H-Tile Production and the speed is higher then 17.5 Gbps background calibration is enabled by default}
puts {in order to perform access to the register space (using rd_channel etc) one needs to disable the background calibration first on that phy}
puts {}

###############################################################################		
#Enable background calibration on all channels in the phy
###############################################################################
proc background_calibration {phy index bg_cal verbose} {
foreach m [get_service_paths slave] {

	if {[string last slave $m] != -1 } {
      # Determine from text in the marker info if m is a Native PHY and only continue if it is
      # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
         set marker_info [marker_get_info $m] 
         set m [claim_service slave $m ""]
		if {[string last xcvr_native_s10 $marker_info] != -1  } {

		# Match the phy
			if {[string last [lindex $phy $index ] $marker_info] != -1 } { 
		
			set num_channels [rd $m 0x0 0x410]

			# Loop through all channels in this Native PHY
			for {set i 0} {$i < $num_channels } {incr i} {
				 set base_addr [expr 0x2000 * $i]
		
			rmw $m $base_addr 0x542 0x01 $bg_cal

		
		 if {$verbose == 1} {

				# Print info			
				if {$bg_cal == 0} {
				set identifier [rd $m $base_addr 0x200]
				set slave_addr [dict get $marker_info BASE_ADDRESS]
				puts -nonewline "Slave: [format 0x%x $slave_addr]  "
				puts -nonewline "channel  : $i	"
				puts -nonewline "base_addr : [format 0x%x [expr $base_addr ]]	"
				puts -nonewline "	Background Calibration  : " 
				set read_back [rd $m $base_addr 0x542]
				puts -nonewline  [expr [expr $read_back & 0x01] ]
				puts ""
				}
			}
}}}}}
close_service slave $m
}

puts {background_calibration {phy index bg_cal verbose}}
puts {example useage background_calibration $phy 0 1 1}
puts ""


proc bg_cal_dis {} {
foreach m [get_service_paths slave] {
     
     if {[string last slave $m] != -1 } {
           puts ""
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
           if {[string last xcvr_native_s10 $marker_info] != -1  } {
                     set slave_addr [dict get $marker_info BASE_ADDRESS]
							

							set num_channels [rd $m 0x0 0x410]

							# Loop through all channels in each phy
							for {set j 0} {$j < $num_channels } {incr j} {
								set base_addr [expr 0x2000 * $j]
		
								rmw $m $base_addr 0x542 0x01 0
								}

           }
}
}
close_service slave $m
puts "Background calibration disabled on all phys"
}
puts {bg_cal_dis {} }
puts {disable background calibration on all phys: useage bg_cal_dis}
puts ""

proc bg_cal_ena {} {
foreach m [get_service_paths slave] {
     
     if {[string last slave $m] != -1 } {
           puts ""
          # Determine from text in the marker info if m is a Native PHY and only continue if it is
          # The marker will exist on the path of $m right now, but we are going to change the path in a second so do this now.
           set marker_info [marker_get_info $m] 

           set m [claim_service slave $m ""]
           if {[string last xcvr_native_s10 $marker_info] != -1  } {
                     set slave_addr [dict get $marker_info BASE_ADDRESS]
							

							set num_channels [rd $m 0x0 0x410]

							# Loop through all channels in each phy
							for {set j 0} {$j < $num_channels } {incr j} {
								set base_addr [expr 0x2000 * $j]
		
								rmw $m $base_addr 0x542 0x01 0x01
								}

           }
}
}
close_service slave $m
puts "Background calibration enabled on all phys"
}
puts {bg_cal_ena {} }
puts {enable background calibration on all phys: useage bg_cal_ena}
puts ""

