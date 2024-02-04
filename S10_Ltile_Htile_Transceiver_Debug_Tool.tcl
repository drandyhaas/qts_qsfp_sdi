
# 	author : Kurrinchi balakrishnan
set version "5p4"
#	quartus : 17.1 production

# 	Version 2p0 fixes
# 	Adding seraail loopback column in the EYE meansurement tab
# 	

# 	Version 3p0 fixes
# 	H1sign stored in ODI_dict_err , so that it can be cleared loaded everytime the eye is measured
# 	Removed the one tab tool, Three tool will have three tabs
#	Changed the view from false to true at the very end to make the loading faster


# 	Version 3p2 fixes
# 	fixed the data logging for eye measutrement

# 	Version 3p3 fixes
# 	fixed the data header in the log file

# 	Version 3p4 fixes
# 	Adding Ltile support, susported for q17p1p1

# 	Version 3p5 fixes
# 	Adding number of bit teseted drop menu for eye tool
# 	change the height and width order in the GUI
#	added the prbs - traffic - prbs works

# 	Version 4p0 fixes
# 	added the BER column 
# 	Removed the log file. Now file be generated automatically and all the data will be logged.
#	

# 	Version 5p0 fixes
# 	Adding new tool called adapation 
#	



# ##################################################################################################################################################
# reg read write
# ##################################################################################################################################################

set quartus "18p1p1"
proc write_reg	{ addr_in_hex reg_value_in_hex chan avmm } {
if {0} { puts [info level 0] }	
	set addr_in_hex [ string tolower $addr_in_hex]
	set reg_value_in_hex [ string tolower $reg_value_in_hex]
	#set usb [string toupper $usb]
	
		set slave_path $avmm 	
		set slave_path [claim_service slave $slave_path foo]
		set word_addr_reg [expr $addr_in_hex + 0x800 * $chan]	
		set byte_addr_reg [expr $word_addr_reg << 2]
		#puts "master_write_32 $slave_path [format "0x%x" $byte_addr_reg]  0x[format "%08s" [dec2hex [expr $reg_value_in_hex]]]\n"
		master_write_32 $slave_path [format "0x%x" $byte_addr_reg]  0x[format "%08s" [format %X [expr $reg_value_in_hex]]]
		close_service slave $slave_path
}
proc read_reg	{ addr_in_hex chan avmm {no_of_reg 1} {start 8} {stop 9}} {
	if {0} { puts [info level 0] }	
	set addr_in_hex [ string tolower $addr_in_hex]
	
	# puts "\n\navmm = $avmm\n\n\n" 
	set slave_path $avmm 	
	set slave_path [claim_service slave $slave_path foo]
	# puts $addr_in_hex
	set word_addr_reg [expr $addr_in_hex + 0x800 * $chan]	
	# puts "word_addr_reg $word_addr_reg"
	set byte_addr_reg [expr $word_addr_reg << 2]
	# puts "byte_addr_reg $byte_addr_reg"
	set byte_addr_reg [format "0x%x" $byte_addr_reg]   
	# puts "byte_addr_reg $byte_addr_reg"
	set dprio_value [master_read_32 $slave_path $byte_addr_reg $no_of_reg]
	set dprio_value_mod ""
	foreach value $dprio_value {
		set val 0x[string range $value $start $stop]
		lappend dprio_value_mod $val
	}
	#puts $dprio_value_mod
	close_service slave $slave_path
	# puts "addr_in_hex=$addr_in_hex, dprio_value=$dprio_value"
	return $dprio_value_mod
}
proc rdmwrite 	{ address bitmask newval chan avmm } {
	if {0} { puts [info level 0] }	
    set value [read_reg $address $chan "$avmm"]
    set value [expr $value & [expr 0xFF & ~$bitmask]]
    set value [expr $value | $newval]
	write_reg $address 0x[format %X $value] $chan "$avmm"
}
proc bkgrnd_cal_disable 	{ chan avmm } {
	if {0} { puts [info level 0] }
	# DIsable calibratiob	
		global dash_xcvr_debug_kit 

    if [dict get $dash_xcvr_debug_kit pma.background_enable.${chan}.${avmm}] {
		rdmwrite 0x542 0x1 0x0 $chan $avmm  ;
	}

}
proc bkgrnd_cal_enable 	{ chan avmm } {
	if {0} { puts [info level 0] }	
		global dash_xcvr_debug_kit 

    # ENable calibratiob
	if [dict get $dash_xcvr_debug_kit pma.background_enable.${chan}.${avmm}] {
		rdmwrite 0x542 0x1 0x1 $chan $avmm  ;
	}

}
proc bkgrnd_cal_read 	{ chan avmm } {
	if {0} { puts [info level 0] }	
	# puts "bkgrnd_cal_read = [read_reg 0x542 $chan $avmm]"
	return [read_reg 0x542 $chan $avmm]
}
proc bkgrnd_cal_read_int { } {
	if {0} { puts [info level 0] }	
	global dash_xcvr_debug_kit 
	foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
		set avmm 			[lindex [get_service_paths slave ] $phy]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {
			dict set dash_xcvr_debug_kit pma.background_enable.${chan}.${avmm} [expr [bkgrnd_cal_read $chan $avmm]]
		}
	}
}
# ##################################################################################################################################################
# PRBS
# ##################################################################################################################################################
proc htile_hard_prbs_pattern_gen 	{ chan pattern avmm } {
	if {0} { puts [info level 0] }	
	if { $pattern == 7 || [string match -nocase $pattern PRBS7] } {
		rdmwrite 0x0007 0xF0 0x10 $chan $avmm;
		rdmwrite 0x0008 0x70 0x00 $chan $avmm;
		rdmwrite 0x110 0x07 0x03 $chan $avmm; 
		#Enable the clock last
		rdmwrite 0x006 0xCF 0x64 $chan $avmm;
  
  after 100;
  
	} elseif { $pattern == 9 || [string match -nocase $pattern PRBS9] } {
		rdmwrite 0x0007 0xF0 0x20 $chan $avmm;
		rdmwrite 0x0008 0x70 0x00 $chan $avmm;
		rdmwrite 0x110 0x07 0x03 $chan $avmm; 
		#Enable the clock last
		rdmwrite 0x006 0xCF 0x64 $chan $avmm;
  
  after 100;

	} elseif { $pattern == 15 || [string match -nocase $pattern PRBS15] } {
		rdmwrite 0x0007 0xF0 0x40 $chan $avmm;
		rdmwrite 0x0008 0x70 0x00 $chan $avmm;
		rdmwrite 0x110 0x07 0x03 $chan $avmm; 
		#Enable the clock last
		rdmwrite 0x006 0xCF 0x64 $chan $avmm;
  
  after 100;
 
	} elseif { $pattern == 23 || [string match -nocase $pattern PRBS23] } {
		rdmwrite 0x0007 0xF0 0x80 $chan $avmm;
		rdmwrite 0x0008 0x70 0x00 $chan $avmm;
		rdmwrite 0x110 0x07 0x03 $chan $avmm; 
		#Enable the clock last
		rdmwrite 0x006 0xCF 0x64 $chan $avmm;
  
  after 100;
 
	} elseif { $pattern == 31 || [string match -nocase $pattern PRBS31] } {
		rdmwrite 0x0007 0xF0 0x00 $chan $avmm;
		rdmwrite 0x0008 0x70 0x10 $chan $avmm;
		rdmwrite 0x110 0x07 0x03 $chan $avmm; 
		#Enable the clock last
		rdmwrite 0x006 0xCF 0x64 $chan $avmm;
  
  after 100;
  
	} elseif { [string match -nocase $pattern PRBS_OFF] } {
		rdmwrite 0x0008 0x70 0x00 $chan $avmm;
		rdmwrite 0x0007 0xF0 0x00 $chan $avmm;
		#Enable the clock last
		rdmwrite 0x006 0xFF 0x23 $chan $avmm;
		after 100;
  
	} elseif { [string match -nocase $pattern SQ_WAVE_1] } {
		rdmwrite 0x0008 0xFF 0x01 $chan $avmm;
		rdmwrite 0x0006 0x87 0x85 $chan $avmm;
	} elseif { [string match -nocase $pattern SQ_WAVE_4] } {
		rdmwrite 0x0008 0xFF 0x04 $chan $avmm;
		rdmwrite 0x0006 0x87 0x85 $chan $avmm;
	} elseif { [string match -nocase $pattern SQ_WAVE_8] } {
		rdmwrite 0x0008 0xFF 0x08 $chan $avmm;
		rdmwrite 0x0006 0x87 0x85 $chan $avmm;
	} elseif { [string match -nocase $pattern SQ_WAVE_6] } {
		rdmwrite 0x0008 0xFF 0x06 $chan $avmm;
		rdmwrite 0x0006 0x87 0x85 $chan $avmm;
	} else {
		puts "wrong pattern selected"
		}
}
proc htile_hard_prbs_pattern_chk 	{ chan pattern avmm } {
	# if {0} { puts [info level 0] }	
		if { $pattern == 7 || [string match -nocase $pattern PRBS7] } {
			rdmwrite 0x000C 0x01 0x00 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x10 $chan $avmm;
			rdmwrite 0x13F 0x0F 0x0E $chan $avmm;
			rdmwrite 0x000A 0x80 0x80 $chan $avmm;
			
		} elseif { $pattern == 9 || [string match -nocase $pattern PRBS9] } {
			rdmwrite 0x000C 0x01 0x00 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x20 $chan $avmm;
			rdmwrite 0x13F 0x0F 0x0E $chan $avmm;
			rdmwrite 0x000A 0x80 0x80 $chan $avmm;
			
		} elseif { $pattern == 15 || [string match -nocase $pattern PRBS15] } {
			rdmwrite 0x000C 0x01 0x00 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x40 $chan $avmm;
			rdmwrite 0x13F 0x0F 0x0E $chan $avmm;			
			rdmwrite 0x000A 0x80 0x80 $chan $avmm;
			
		} elseif { $pattern == 23 || [string match -nocase $pattern PRBS23] } {
			rdmwrite 0x000C 0x01 0x00 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x80 $chan $avmm;
			rdmwrite 0x13F 0x0F 0x0E $chan $avmm;
			rdmwrite 0x000A 0x80 0x80 $chan $avmm;
			
		} elseif { $pattern == 31 || [string match -nocase $pattern PRBS31] } {
			rdmwrite 0x000C 0x01 0x01 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x00 $chan $avmm;
			rdmwrite 0x13F 0x0F 0x0E $chan $avmm;			
			rdmwrite 0x000A 0x80 0x80 $chan $avmm;
			
		} elseif { [string match -nocase $pattern PRBS_OFF] } {
			rdmwrite 0x000C 0x01 0x00 $chan $avmm;
			rdmwrite 0x000B 0xF0 0x00 $chan $avmm;
			rdmwrite 0x000A 0x80 0x00 $chan $avmm;
			
		} else {
			puts "wrong pattern selected"
			}
	}
proc hard_prbs_disable 	{ chan avmm} {
	global dash_xcvr_debug_kit
	
	write_reg 0x6 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x6] $chan $avmm
	write_reg 0x7 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x7] $chan $avmm
	write_reg 0x8 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x8] $chan $avmm
	write_reg 0x110 [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x110] $chan $avmm
	write_reg 0xa 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xa] $chan $avmm
	write_reg 0xb 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xb] $chan $avmm
	write_reg 0xc 	[dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xc] $chan $avmm
	write_reg 0x13f [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x13f] $chan $avmm
} 
	
proc hard_prbs_reset 				{ chan  avmm } {
if {0} { puts [info level 0] }	
	rdmwrite 0x500 0x2 0x2 $chan $avmm
	rdmwrite 0x500 0x2 0x0 $chan $avmm
}
proc hard_prbs_start 				{ chan avmm } {
	if {0} { puts [info level 0] }	
	rdmwrite 0x500 0x7 0x1 $chan  $avmm
}
proc hard_prbs_stop 				{ chan avmm } {
if {0} { puts [info level 0] }	
	rdmwrite 0x500 0x7 0x0 $chan $avmm
}
proc hard_prbs_snapshot 			{ chan avmm} {
  #puts "Error accumulator snapshot taken";
	rdmwrite 0x500 0x04 0x04 $chan $avmm; #take a snapshot of the error count
}
proc hard_prbs_error_count 			{ chan avmm {exp 1} } {
if {0} { puts [info level 0] }	
	set val_7_0 	[format %08s [dec2bin [expr [read_reg 0x501 $chan $avmm]]]]
	set val_15_8 	[format %08s [dec2bin [expr [read_reg 0x502 $chan $avmm]]]]
	set val_23_16 	[format %08s [dec2bin [expr [read_reg 0x503 $chan $avmm]]]]
	set val_31_24 	[format %08s [dec2bin [expr [read_reg 0x504 $chan $avmm]]]]
	set val_39_32 	[format %08s [dec2bin [expr [read_reg 0x505 $chan $avmm]]]]
	set val_47_40 	[format %08s [dec2bin [expr [read_reg 0x506 $chan $avmm]]]]
	set val_49_48 	[format %02s [string range [format %08s [dec2bin [expr [read_reg 0x507 $chan $avmm]]]] 6 7]]
	
	if { $exp } {set val "[format %e [bin2dec ${val_49_48}${val_47_40}${val_39_32}${val_31_24}${val_23_16}${val_15_8}${val_7_0}]]"
		} else { 
			set val "[bin2dec ${val_49_48}${val_47_40}${val_39_32}${val_31_24}${val_23_16}${val_15_8}${val_7_0}]"
		}
	return $val
}
proc hard_prbs_bit_count   			{ chan avmm {exp 1} } {
if {0} { puts [info level 0] }	
	set val_7_0 	[format %08s [dec2bin [expr [read_reg 0x50D $chan $avmm]]]]
	set val_15_8 	[format %08s [dec2bin [expr [read_reg 0x50E $chan $avmm]]]]
	set val_23_16 	[format %08s [dec2bin [expr [read_reg 0x50F $chan $avmm]]]]
	set val_31_24 	[format %08s [dec2bin [expr [read_reg 0x510 $chan $avmm]]]]
	set val_39_32 	[format %08s [dec2bin [expr [read_reg 0x511 $chan $avmm]]]]
	set val_47_40 	[format %08s [dec2bin [expr [read_reg 0x512 $chan $avmm]]]]
	set val_49_48 	[format %02s [string range [format %08s [dec2bin [expr [read_reg 0x513 $chan $avmm]]]] 6 7]]
	if { $exp } {set val "[format %e [expr [bin2dec ${val_49_48}${val_47_40}${val_39_32}${val_31_24}${val_23_16}${val_15_8}${val_7_0}]*64]]"
		} else { 
			set val "[expr [bin2dec ${val_49_48}${val_47_40}${val_39_32}${val_31_24}${val_23_16}${val_15_8}${val_7_0}]*64]"
		}
	return $val
}
proc hard_prbs_ber 					{ chan avmm {exp 1}} {
if {0} { puts [info level 0] }	
	set total_bit 	[healthkit_hard_prbs_bit_count  $chan $avmm]
	set error		[healthkit_hard_prbs_error_count $chan $avmm ]
	#puts "Total Bits=$total_bit , Error= $error"
	set val 0
	if { $total_bit > 0 } {
		if { $exp } {
			set val [format %e [expr $error/$total_bit]]
		} else  {
			set val [expr $error/$total_bit]
		}
	}

	return $val
}
proc hard_prbs_locked 				{ chan avmm} {
	return [string range [format %08s [dec2bin [expr [read_reg 0x500 $chan $avmm]]]] 4 4]
}
proc hard_prbs_stat		 			{ chan avmm} {
	set checker_data  "[healthkit_hard_prbs_bit_count $chan $avmm] [healthkit_hard_prbs_error_count $chan $avmm] [healthkit_hard_prbs_ber $chan $avmm] [healthkit_hard_prbs_locked $chan $avmm]"
	return $checker_data
}
proc hard_prbs_configure_adapter 	{ chan avmm} {
 # puts "Configure Adapter Registers...";
  # PMA register
  rdmwrite 0x164 0x80 0x80 $chan $avmm; #pma_rx_deser clk1x override
  # PLD registers                                                                                                                            
  rdmwrite 0x210 0x1F 0x09 $chan $avmm; #8'b0001_1111, 8'b0000_1001
  rdmwrite 0x212 0xE0 0x00 $chan $avmm; #8'b1110_0000, 8'b0000_0000
  rdmwrite 0x213 0xFF 0x47 $chan $avmm; #8'b1111_1111, 8'b0100_0111
  rdmwrite 0x214 0x01 0x00 $chan $avmm; #8'b0000_0001, 8'b0000_0000
  rdmwrite 0x215 0x01 0x00 $chan $avmm; #8'b0000_0001, 8'b0000_0000
  rdmwrite 0x218 0xC1 0x40 $chan $avmm; #8'b1100_0001, 8'b0100_0000
  rdmwrite 0x223 0x1F 0x00 $chan $avmm; #8'b0001_1111, 8'b0000_0000
  # PLDADAPT registers                                        
  rdmwrite 0x300 0x3F 0x00 $chan $avmm; #8'b0011_1111, 8'b0000_0000
  rdmwrite 0x312 0xFF 0x07 $chan $avmm; #8'b1111_1111, 8'b0000_0111
  rdmwrite 0x313 0xFF 0x02 $chan $avmm; #8'b1111_1111, 8'b0000_0010
  rdmwrite 0x315 0x47 0x00 $chan $avmm; #8'b0100_0111, 8'b0000_0000
  rdmwrite 0x318 0x03 0x02 $chan $avmm; #8'b0000_0011, 8'b0000_0010
  rdmwrite 0x31A 0x1C 0x04 $chan $avmm; #8'b0001_1100, 8'b0000_0100
  rdmwrite 0x320 0x07 0x02 $chan $avmm; #8'b0000_0111, 8'b0000_0010
  rdmwrite 0x321 0x1E 0x18 $chan $avmm; #8'b0001_1110, 8'b0001_1000
  rdmwrite 0x322 0x73 0x41 $chan $avmm; #8'b0111_0011, 8'b0100_0001
  #puts "Adapter Register Configuration Complete";             
} 
proc htile_get_hard_prbs_pattern_gen { chan avmm } {
	if {0} { puts [info level 0] }	
	set reg_read_0x07 [expr [expr 0xF0 & [read_reg 0x7 $chan $avmm]] >> 4]
	set reg_read_0x08 [expr [expr 0x70 & [read_reg 0x8 $chan $avmm]] >> 4]
	if $reg_read_0x08 {
		return "PRBS31"
	} elseif  { $reg_read_0x07 == 1 } {	
		return "PRBS7"
	} elseif  { $reg_read_0x07 == 2 } {	
		return "PRBS9"
	} elseif  { $reg_read_0x07 == 4 } {	
		return "PRBS15"
	} elseif  { $reg_read_0x07 == 8 } {	
		return "PRBS23"
	} else {
		return "PRBS7"
	}
}
proc htile_get_hard_prbs_pattern_chk { chan avmm } {
	if {0} { puts [info level 0] }	
	set reg_read_0x0b [expr [expr 0xF0 & [read_reg 0xb $chan $avmm]] >> 4]
	set reg_read_0x0c [expr 0x01 & [read_reg 0xc $chan $avmm]]
	if $reg_read_0x0c {
		return "PRBS31"
	} elseif  { $reg_read_0x0b == 1 } {	
		return "PRBS7"
	} elseif  { $reg_read_0x0b == 2 } {	
		return "PRBS9"
	} elseif  { $reg_read_0x0b == 4 } {	
		return "PRBS15"
	} elseif  { $reg_read_0x0b == 8 } {	
		return "PRBS23"
	} else {
		return "PRBS7"
	}
}

# ##################################################################################################################################################
# PMA
# ##################################################################################################################################################
proc adapt_initial_value 	{ac dc vga chan avmm } {
	if { $ac == 0 } { rdmwrite 0x160 0x03 0x00 $chan $avmm}
	if { $ac == 2 } { rdmwrite 0x160 0x03 0x01 $chan $avmm}
	if { $ac == 4 } { rdmwrite 0x160 0x03 0x02 $chan $avmm}
	if { $ac == 8 } { rdmwrite 0x160 0x03 0x03 $chan $avmm}
	
	if { $dc == 0 }  { rdmwrite 0x160 0x0c 0x00 $chan $avmm}
	if { $dc == 8 }  { rdmwrite 0x160 0x0c 0x04 $chan $avmm}
	if { $dc == 16 } { rdmwrite 0x160 0x0c 0x08 $chan $avmm}
	if { $dc == 32 } { rdmwrite 0x160 0x0c 0x0c $chan $avmm}
	
	if { $vga == 0 }  { rdmwrite 0x167 0x03 0x00 $chan $avmm}
	if { $vga == 4 }  { rdmwrite 0x167 0x03 0x01 $chan $avmm}
	if { $vga == 8 }  { rdmwrite 0x167 0x03 0x02 $chan $avmm}
	if { $vga == 16 } { rdmwrite 0x167 0x03 0x03 $chan $avmm}
	
}
proc adapt_reset 			{ chan avmm } {
#adp_rstn	RADP_RSTN_0	148	[0]	0
rdmwrite 0x148 0x1 0x0 $chan $avmm
after 100				
#adp_rstn	RADP_RSTN_1	148	[0]	1
rdmwrite 0x148 0x1 0x1 $chan $avmm
#adp_adapt_start	RADP_ADAPT_START_0	14C	[0]	0
rdmwrite 0x14C 0x1 0x0 $chan $avmm
after 100				
#adp_adapt_start	RADP_ADAPT_START_1	14C	[0]	1
rdmwrite 0x14C 0x1 0x1 $chan $avmm

}
proc adapt_stop 			{ chan avmm } {
#adp_rstn	RADP_RSTN_0	148	[0]	0
rdmwrite 0x148 0x1 0x0 $chan $avmm
after 100				
#adp_adapt_start	RADP_ADAPT_START_0	14C	[0]	0
rdmwrite 0x14C 0x1 0x0 $chan $avmm
after 100				
}
proc set_tx 				{ vod post pre chan avmm } { 
	vod_wr 		$chan $vod $avmm
	postemp1_wr $chan $post $avmm
	preemp1_wr 	$chan $pre $avmm
}
proc vod_wr 				{ chan dec avmm } {
if {0} { puts [info level 0] }	
	rdmwrite 0x109 0x1F 0x[format %X $dec] $chan $avmm; 
}
proc vod_rd 		{ chan avmm  } {
if {0} { puts [info level 0] }	
	return [ bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x109 $chan $avmm; ]]]] 3 7]]
}
proc ODI_postemp1_rd 	{ chan avmm } {
if {0} { puts [info level 0] }	
	
	set val [ ODI_bin2dec [string range [format %08s [ODI_dec2bin [expr [ODI_read_reg 0x105 $chan $avmm; ]]]] 3 7]]
	if { [ ODI_bin2dec [string range [format %08s [ODI_dec2bin [expr [ODI_read_reg 0x105 $chan $avmm; ]]]] 1 1]] == "1" && $val > 0 } {
		set sign "-"
	} else {
		set sign ""
	}
	
	return "${sign}${val}"
}
proc postemp1_wr 			{ chan dec avmm } {
if {0} { puts [info level 0] }	
	if { $dec < 0 } { 
		rdmwrite 0x105 0x40 0x40 $chan $avmm; 
		set dec [ expr $dec * -1 ]
	} else { 
		rdmwrite 0x105 0x40 0x0 $chan $avmm; 
	}
	rdmwrite 0x105 0x1F 0x[format %X  $dec] $chan $avmm; 
	
}
proc postemp1_rd 	{ chan avmm } {
if {0} { puts [info level 0] }	
	
	set val [ bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x105 $chan $avmm; ]]]] 3 7]]
	if { [ bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x105 $chan $avmm; ]]]] 1 1]] == "1" && $val > 0 } {
		set sign "-"
	} else {
		set sign ""
	}
	
	return "${sign}${val}"
}
proc preemp1_wr 			{ chan dec avmm} {
if {0} { puts [info level 0] }	
	if { $dec < 0 } { 
		rdmwrite 0x107 0x20 0x20 $chan $avmm; 
		set dec [ expr $dec * -1 ]
	} else { 
		rdmwrite 0x107 0x20 0x0 $chan $avmm; 
	}
	rdmwrite 0x107 0x1F 0x[format %X  $dec] $chan $avmm; 
}
proc preemp1_rd 	{ chan avmm } {
if {0} { puts [info level 0] }	
	set val [ bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x107 $chan $avmm; ]]]] 3 7]]
	if { [ bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x107 $chan $avmm; ]]]] 2 2]] == "1" && $val > 0 } {
		set sign "-"
	} else {
		set sign ""
	}
	return "${sign}${val}"
}
proc ch_rx_is_lockedtodata 	{ chan avmm } {
	set rx_is_lockedtodata1 1
	for { set i 0 } { $i < 100 } { incr i } {
		set rx_is_lockedtodata [string range [format %08s [format %llb  [expr [ read_reg 0x480 $chan "$avmm"]]]] 7 7]
		if {$rx_is_lockedtodata == 0 } { set rx_is_lockedtodata1 0}
	}
			
	return $rx_is_lockedtodata1
}
proc ch_rx_is_lockedtoref 	{ chan avmm } {
	set rx_is_lockedtoref1 1
	for { set i 0 } { $i < 100 } { incr i } {
		set rx_is_lockedtoref [string range [format %08s [format %llb  [expr [ read_reg 0x480 $chan "$avmm"]]]] 6 6]
		if {$rx_is_lockedtoref == 0 } { set rx_is_lockedtoref1 0}
	}
	
	return $rx_is_lockedtoref1
}
proc tx_inversion 			{ chan avmm  } {
	set val [bin2dec [string range [format %08s [dec2bin [expr [ read_reg 0x7 $chan $avmm ]]]] 5 5]]
	if {$val} { 
			 rdmwrite 0x7 0x4 0x0 $chan $avmm; 
		} else {
			 rdmwrite 0x7 0x4 0x4 $chan $avmm; 
		}
}
proc rx_inversion 			{ chan avmm  } {
	set val [bin2dec [string range [format %08s [dec2bin [expr [ read_reg 0xA $chan $avmm ]]]] 3 3]]
	# puts $val
	if {$val} { 
			 rdmwrite 0xA 0x10 0x0 $chan $avmm; 
		} else {
			 rdmwrite 0xA 0x10 0x10 $chan $avmm; 
		}
}
 
proc get_adapt_ctle_ac_gain { chan avmm } {
	rdmwrite 0x171 0x1E 0x16 $chan $avmm;
	rdmwrite 0x149 0x3F 0x03 $chan $avmm;
	set ctle_ac_gain_adapt_val [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 1 4]]
	# puts $ctle_ac_gain_adapt_val
	return $ctle_ac_gain_adapt_val
}
proc get_adapt_ctle_dc_gain { chan avmm } {
	rdmwrite 0x171 0x1E 0x16 $chan $avmm;
	rdmwrite 0x149 0x3F 0x04 $chan $avmm;
	set ctle_dc_gain_adapt_val [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 2 7]]
	# puts $ctle_dc_gain_adapt_val
	return $ctle_dc_gain_adapt_val
}
proc get_adapt_vga_dc_gain { chan avmm } {
	rdmwrite 0x171 0x1E 0x16 $chan $avmm;
	rdmwrite 0x149 0x3F 0x05 $chan $avmm;
	set vga_dc_gain_adapt_val [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 3 7]]
	#puts $vga_dc_gain_adapt_val
	return $vga_dc_gain_adapt_val
}
proc get_dfe_taps_from_adapt_testmux { chan avmm } {
	rdmwrite 0x171 0x1E 0x16 $chan $avmm;
	# Tap1
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 000111
	rdmwrite 0x149 0x3F 0x07 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 1 1]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap1_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 2 7]]"
	
	# Tap2
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001000
	rdmwrite 0x149 0x3F 0x08 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 2 2]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap2_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 7]]"

	# Tap3
	##s10_write $chan $avmm; xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001001
	rdmwrite 0x149 0x3F 0x09 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 2 2]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap3_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 7]]"

	# Tap4
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001010
	rdmwrite 0x149 0x3F 0x0a $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 3]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap4_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 7]]"

	# Tap5
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001011
	rdmwrite 0x149 0x3F 0x0b $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 3]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap5_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 7]]"
	
	# Tap6
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001100
	rdmwrite 0x149 0x3F 0x0c $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 3]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap6_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 7]]"
	

	# Tap7
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001101
	rdmwrite 0x149 0x3F 0x0d $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 3 3]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap7_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 7]]"
	
	# Tap8
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001110
	rdmwrite 0x149 0x3F 0x0e $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 5 5]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap8_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 6 7]]"

	# Tap9
	##s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001110
	rdmwrite 0x149 0x3F 0x0e $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 1 1]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap9_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 2 4]]"
	
	# Tap10
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001111
	rdmwrite 0x149 0x3F 0x0f $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 4]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap10_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 5 7]]"
	
	# Tap11
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 001111
	rdmwrite 0x149 0x3F 0x0f $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 0 0]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	set tap11_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 1 3]]"

	# Tap12
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 010000
	rdmwrite 0x149 0x3F 0x10 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 4]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	#puts "mag"
	set tap12_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 5 7]]"
	
	# Tap13
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 010000
	rdmwrite 0x149 0x3F 0x10 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 0 0]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	#puts "mag"
	set tap13_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 1 3]]"
	
	# Tap14
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 010001
	rdmwrite 0x149 0x3F 0x11 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 4 4]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	#puts "mag"
	set tap14_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 5 7]]"

	# Tap15	
	#s10_write $chan xhssi_tile_0.pm_pma_6pack.xpm_tx_rx0.xrx_path.xadapt.adp_status_sel 010001
	rdmwrite 0x149 0x3F 0x11 $chan $avmm;
	set sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 0 0]]
	if { $sign } { set sign_bit "-" } ; if { !$sign } { set sign_bit "" } ; 
	#puts "mag"
	set tap15_val "${sign_bit}[bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm;  ]]]] 1 3]]"
	
	# puts "Taps_1:$tap1_val,Taps_2:$tap2_val,Taps_3:$tap3_val,Taps_4:$tap4_val,Taps_5:$tap5_val,Taps_6:$tap6_val,Taps_7:$tap7_val,Taps_8:$tap8_val,Taps_9:$tap9_val,Taps_10:$tap10_val,DFE_Taps_11:$tap11_val,Taps_12:$tap12_val,Taps_13:$tap13_val,Taps_14:$tap14_val,Taps_15:$tap15_val"
	return "$tap1_val,$tap2_val,$tap3_val,$tap4_val,$tap5_val,$tap6_val,$tap7_val,$tap8_val,$tap9_val,$tap10_val,$tap11_val,$tap12_val,$tap13_val,$tap14_val,$tap15_val"

}
proc get_adapt_afe { chan avmm } {

set VGA_DC [get_adapt_vga_dc_gain $chan $avmm;]
set CTLE_DC [get_adapt_ctle_dc_gain $chan $avmm;]
set CTLE_AC [get_adapt_ctle_ac_gain $chan $avmm;]
set dfe_taps [get_dfe_taps_from_adapt_testmux $chan $avmm;]

# puts "\nDLEV: $DLEV,VGA_DC: $VGA_DC,CTLE_DC: $CTLE_DC,CTLE_AC: $CTLE_AC"

return "$VGA_DC $CTLE_DC $CTLE_AC $dfe_taps"

}
proc adapt_reverse_engineer { chan avmm } {
# Adaptation Mode DecODIng				
# Manual 				adp_dlev_bypass = 1 & adp_dfe_fxtap_bypass = 1;			
# Adaptive NO DFE		adp_dlev_bypass = 0 & adp_dfe_fxtap_bypass = 1			
# Adaptive 1-Tap DFE	adp_dfe_fxtap_bypass = 0  & adp_dfe_tap_sel_en = 2'b10 & adp_vga_bypass =0			
# Adaptive All-Tap DFE	adp_dfe_fxtap_bypass = 0  & adp_dfe_tap_sel_en = 2'b00 & adp_vga_bypass =0			

	set adp_dlev_bypass 		[expr [expr 0x20 & [read_reg 0x161 $chan $avmm]] >> 5]
	set adp_dfe_fxtap_bypass 	[expr [expr 0x40 & [read_reg 0x161 $chan $avmm]] >> 6]
	set adp_dfe_tap_sel_en 		[expr [expr 0x60 & [read_reg 0x14C $chan $avmm]] >> 5]
	set adp_vga_bypass 			[expr [expr 0x80 & [read_reg 0x149 $chan $avmm]] >> 7]
	# puts "$adp_dlev_bypass $adp_dfe_fxtap_bypass $adp_dfe_tap_sel_en $adp_vga_bypass"

	if { $adp_dlev_bypass && $adp_dfe_fxtap_bypass } {
		return "manual"
	} elseif { ($adp_dlev_bypass == 0) && ($adp_dfe_fxtap_bypass == 1) } {
		return "ctle_adaptive_no_dfe"
	} elseif { ($adp_dfe_fxtap_bypass == 0) && ($adp_dfe_tap_sel_en == 2) && ($adp_vga_bypass == 0) } {
		return "ctle_adaptive_1tap_dfe"
	} elseif { ($adp_dfe_fxtap_bypass == 0) && ($adp_dfe_tap_sel_en == 0) && ($adp_vga_bypass == 0) } {
		return "ctle_adaptive_all_tap_dfe"
	} else {
		return "no_good_combination"
	}

}
proc adapt_ctle_dfe { chan avmm } {
	if {0} { puts [info level 0] }	
	rdmwrite 0x0161 0x40 0x00 $chan $avmm;
	rdmwrite 0x0161 0x20 0x00 $chan $avmm;
	rdmwrite 0x0149 0x80 0x00 $chan $avmm;
	rdmwrite 0x015F 0x08 0x00 $chan $avmm;
	rdmwrite 0x015C 0x80 0x00 $chan $avmm;
	rdmwrite 0x0148 0x02 0x02 $chan $avmm;
	rdmwrite 0x0148 0x08 0x08 $chan $avmm;
	rdmwrite 0x0148 0x10 0x10 $chan $avmm;
	rdmwrite 0x0161 0x80 0x80 $chan $avmm;
	rdmwrite 0x0148 0x20 0x20 $chan $avmm;
	rdmwrite 0x014C 0x40 0x00 $chan $avmm;
	rdmwrite 0x014C 0x20 0x00 $chan $avmm;
	rdmwrite 0x015D 0x08 0x00 $chan $avmm;
	rdmwrite 0x015D 0x04 0x00 $chan $avmm;
	rdmwrite 0x015D 0x02 0x00 $chan $avmm;

	rdmwrite 0x0131 0x40 0x40 $chan $avmm;
	rdmwrite 0x0131 0x80 0x80 $chan $avmm;
	rdmwrite 0x012F 0x40 0x40 $chan $avmm;
	rdmwrite 0x012F 0x80 0x80 $chan $avmm;
	rdmwrite 0x0150 0x20 0x20 $chan $avmm;

	rdmwrite 0x014A 0x20 0x00 $chan $avmm;
	rdmwrite 0x0162 0x08 0x08 $chan $avmm;
	rdmwrite 0x0162 0x04 0x00 $chan $avmm;
	rdmwrite 0x0167 0x40 0x00 $chan $avmm;
	rdmwrite 0x0167 0x20 0x00 $chan $avmm;
	rdmwrite 0x0167 0x10 0x00 $chan $avmm;
	rdmwrite 0x0167 0x08 0x00 $chan $avmm;
	rdmwrite 0x0167 0x04 0x00 $chan $avmm;
	rdmwrite 0x0158 0x40 0x40 $chan $avmm;
	rdmwrite 0x0166 0x10 0x00 $chan $avmm;
	rdmwrite 0x0166 0x08 0x08 $chan $avmm;
	rdmwrite 0x0166 0x04 0x04 $chan $avmm;
	rdmwrite 0x0166 0x02 0x02 $chan $avmm;
	rdmwrite 0x0166 0x01 0x01 $chan $avmm;

	rdmwrite 0x0174 0x80 0x80 $chan $avmm;
	rdmwrite 0x0168 0x04 0x00 $chan $avmm;
	rdmwrite 0x011E 0x04 0x00 $chan $avmm;
	rdmwrite 0x011E 0x02 0x02 $chan $avmm;
	rdmwrite 0x011E 0x01 0x01 $chan $avmm;


}
proc pma_init { } {
	global dash_xcvr_debug_kit
	if {0} { puts [info level 0] }	
	set native_nos ""
	set k 0
	foreach temp [get_service_paths slave] {
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
			
			if { ($condition1 && $condition2 )} { 
				lappend native_nos $k 
				# set split_path [split $temp "/"]
				# set split_path [lindex $split_path 1]_[lindex $split_path 2]
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				# puts $split_path
				puts [lindex [marker_get_info $temp] 1]
				dict lappend dash_xcvr_debug_kit pma.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit pma.native.$k.cable_info $cable_info
				set avmm [lindex [get_service_paths slave ] $k]
				dict lappend dash_xcvr_debug_kit pma.native.$k.no_of_chan [expr [read_reg 0x410 0 $avmm]]
			}
		}
		incr k
	}
	
	foreach phy [dict get $dash_xcvr_debug_kit pma.native.phy_id] {
		set avmm 			[lindex [get_service_paths slave ] $phy]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit pma.native.$phy.no_of_chan] } {incr chan } {
			bkgrnd_cal_disable $chan $avmm
			set_tx 31 -8 0 $chan $avmm
			htile_hard_prbs_pattern_gen $chan 31 $avmm
			htile_hard_prbs_pattern_chk $chan 31 $avmm
			hard_prbs_start  $chan $avmm
			adapt_ctle_dfe $chan $avmm
			adapt_reset $chan $avmm
			hard_prbs_reset $chan $avmm
			bkgrnd_cal_enable $chan $avmm
		}
		
	}
}

# ##################################################################################################################################################
# math function
# ##################################################################################################################################################
proc dec2bin x 		{
    if {[string index $x 0] eq {-}} {
        set sign -
        set x [string range $x 1 end]
    } else {
        set sign {}
    }
    return $sign[string trimleft [string map {
    0 {000} 1 {001} 2 {010} 3 {011} 4 {100} 5 {101} 6 {110} 7 {111}
    } [format %o $x]] 0]
}
proc bin2dec bin 	{
    if {$bin == 0} {
        return 0
    } elseif {[string match -* $bin]} {
        set sign -
        set bin [string range $bin[set bin {}] 1 end]
    } else {
        set sign {}
    }
    return $sign[expr 0b$bin]
}
proc bin2hex {bin} {
    set t {
         0000 0 0001 1 0010 2 0011 3 0100 4 0101 5 0110 6 0111 7
         1000 8 1001 9 1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
    }
    if {[set diff [expr {4-[string length $bin]%4}]] != 4} {
         set bin [format %0${diff}d$bin 0]
    }
    return [string map $t $bin]
 }
# ########################################################################################################################
# Widget function
# ########################################################################################################################
proc widget_group {dash name group itemsPerRow text {preferredWidth 0}} {
	dashboard_add $dash $name group $group
	dashboard_set_property $dash $name itemsPerRow $itemsPerRow
	dashboard_set_property $dash $name title $text
	# puts "widget_group $preferredWidth"
	if $preferredWidth {dashboard_set_property $dash $name preferredWidth $preferredWidth }
}
proc widget_checkBox {dash name group text onClick {value "false"} {foregroundColor red} } {
	dashboard_add $dash $name checkBox $group
	dashboard_set_property $dash $name text $text
	dashboard_set_property $dash $name onClick $onClick
	dashboard_set_property $dash $name checked $value
	dashboard_set_property $dash $name foregroundColor	$foregroundColor
}
proc widget_button {dash name group text onClick} {
	dashboard_add $dash $name button $group
	dashboard_set_property $dash $name text $text
	dashboard_set_property $dash $name onClick $onClick
}
proc widget_label {dash name group text {foregroundColor black} } {

	dashboard_add $dash $name label $group
	dashboard_set_property $dash $name text $text
	dashboard_set_property $dash $name foregroundColor	$foregroundColor
}
proc widget_led {dash id grp txt hue} {
    dashboard_add           $dash  $id  led       $grp
    dashboard_set_property  $dash  $id  text      $txt
    dashboard_set_property  $dash  $id  color     $hue
}
proc widget_text {dash name group text foregroundColor } {
	dashboard_add $dash $name label $group
	dashboard_set_property $dash $name text $text
	dashboard_set_property $dash $name foregroundColor	$foregroundColor
}
proc widget_comboBox {dash name group options selectedItem {foregroundColor black} {label ""} } {

	dashboard_add $dash $name comboBox $group
	dashboard_set_property $dash $name options $options
	dashboard_set_property $dash $name selectedItem $selectedItem
	dashboard_set_property $dash $name foregroundColor $foregroundColor
	dashboard_set_property $dash $name label $label
}

# ##################################################################################################################################################
# Tranceiver status function
# ##################################################################################################################################################
proc healthkit_init { } {
	
	global dash_xcvr_debug_kit
	
	set native_nos ""
	set k 0
	foreach temp [get_service_paths slave] {
		
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
			
			if { ($condition1 && $condition2 )} { 
				# puts "native found"
				lappend native_nos $k 
				# puts [lindex [marker_get_info "$temp"] 1]
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				dict lappend dash_xcvr_debug_kit xcvr_status.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit xcvr_status.native.$k.cable_info $cable_info
			}
		}
		incr k
	}
	
	dict lappend dash_xcvr_debug_kit xcvr_status.native.no_of_phy [llength $native_nos]
	# dict lappend dash_xcvr_debug_kit xcvr_status.GUI_dash ""
	# dict lappend dash_xcvr_debug_kit xcvr_status.debug_signal rx_analogreset rx_digitalreset tx_analogreset tx_digitalreset rx_is_lockedtodata rx_is_lockedtoref tx_cal_busy rx_cal_busy avmm_busy rx_seriallpbken prbs_counter_en prbs_reset prbs_snap prbs_done cable_P_N_swap
	dict lappend dash_xcvr_debug_kit xcvr_status.debug_signal rx_is_lockedtodata rx_is_lockedtoref tx_cal_busy rx_cal_busy avmm_busy rx_seriallpbken prbs_counter_en prbs_done cable_P_N_swap


	foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
		# puts "kk1 $phy"
		dict lappend dash_xcvr_debug_kit xcvr_status.native.$phy.avmm [lindex [get_service_paths slave ] [lindex $native_nos $phy]]
		set avmm [lindex [get_service_paths slave ] $phy]
		dict lappend dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan [expr [ read_reg 0x410 0 "$avmm"]]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan] } {incr chan } {
			# puts "phy=$phy chan=$chan "	
			foreach debug [dict get $dash_xcvr_debug_kit xcvr_status.debug_signal]  {
			# puts $debug
				dict lappend dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.$debug 0
				dict lappend dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.$debug.led_id 0
			}
		}
	}
	foreach debug [dict get $dash_xcvr_debug_kit xcvr_status.debug_signal]  {
		# puts $debug
		if {[string first "reset" $debug] > -1 } {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "red"    
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "green_off"
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Red:Reset_High, Dark_green:Reset_low"
		} elseif {[string first "rx_is_lockedtodata" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "green"	
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "red"  
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Red:NoLock, Green:LockHigh,"
		} elseif {[string first "rx_is_lockedtoref" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "green"	
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "red"  
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Red:NoLock, Green:LockHigh, Dark_green: Don't Care, Since Lock_to_data is high"
		} elseif {[string first "cal_busy" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "red"
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "green_off" 
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Red:Cal_on, Dark_Green:Cal_done"
		} elseif {[string first "busy" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "red"
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "green_off" 
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Red:Avmm_Busy, Dark_Green:Avmm_not_Busy"
		} elseif {[string first "serial" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "green"	
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "green_off"  
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Green:Loopback_on, Dark_green:Loopback_off"
		} elseif {[string first "prbs_counter_en" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "green"	
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "red_off" 
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Green:PRBS_enabled, Dark_red:PRBS_Disabled"
		} elseif {[string first "prbs_done" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "green"	
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "red" 
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Green:PRBS_patt_found, Red:PRBS_patt_not_found"
		} elseif {[string first "cable_P_N_swap" $debug] > -1} {
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_good_color "red"		
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_bad_color "green" 
			dict lappend dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment "Green:No_need_to_swap_polarity,Red:Need_to_swap_polarity, Dark_green:Disable/No Data Lock"
		}	
	}			
	# puts $health_dict
}
proc healthkit_update_debug_signal { } {

	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit XCVR_Status.GUI_dash]
	foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan] } {incr chan } {
			# puts -nonewline "."
			# puts "phy_instance=$phy chan=$chan "	
			set avmm [lindex [get_service_paths slave ] $phy]
			bkgrnd_cal_disable $chan $avmm

			 rdmwrite 0x4E0 0x0C 0x0C $chan "$avmm";
			 rdmwrite 0x4E2 0xF0 0xF0 $chan "$avmm";
			
			
			#ch_rx_is_lockedtodata
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_is_lockedtodata [ch_rx_is_lockedtodata $chan $avmm]]
			
			#ch_rx_is_lockedtoref
			
			if [ch_rx_is_lockedtodata $chan $avmm] {
				set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_is_lockedtoref 0.5 ]
			} else {
				set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_is_lockedtoref [ch_rx_is_lockedtoref $chan $avmm] ]
			}
			
			
			
			
			# set dash_xcvr_debug_kit xcvr_status.[dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_is_lockedtoref [string range [format %08s [format %llb  [expr [ read_reg 0x480 $chan "$avmm"]]]] 6 6]]
			#ch_tx_cal_busy
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.tx_cal_busy [string range [format %08s [format %llb  [expr [ read_reg 0x481 $chan "$avmm"]]]] 7 7]]
			#ch_rx_cal_busy
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_cal_busy [string range [format %08s [format %llb  [expr [ read_reg 0x481 $chan "$avmm"]]]] 6 6]]
			#ch_avmm_busy
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.avmm_busy [string range [format %08s [format %llb  [expr [ read_reg 0x481 $chan "$avmm"]]]] 5 5]]
			#ch_rx_seriallpbken
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.rx_seriallpbken [string range [format %08s [format %llb  [expr [ read_reg 0x4E1 $chan "$avmm"]]]] 7 7]]
			
			#prbs_counter_en
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.prbs_counter_en [string range [format %08s [format %llb  [expr [ read_reg 0x500 $chan "$avmm"]]]] 7 7]]
			
			#prbs_reset
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.prbs_reset [string range [format %08s [format %llb  [expr [ read_reg 0x500 $chan "$avmm"]]]] 6 6]]
			
			#prbs_snap
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.prbs_snap [string range [format %08s [format %llb  [expr [ read_reg 0x500 $chan "$avmm"]]]] 5 5]]
			
			#prbs_done
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.prbs_done [string range [format %08s [format %llb  [expr [ read_reg 0x500 $chan "$avmm"]]]] 4 4]]
			
			 rdmwrite 0x4E0 0x0C 0x00 $chan "$avmm";
			 rdmwrite 0x4E2 0xF0 0x00 $chan "$avmm";
			
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.cable_P_N_swap [healthkit_cable_is_swap $chan "$avmm" $phy]] 
			
			bkgrnd_cal_enable $chan $avmm

		}
	}
	foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
		foreach debug [dict get $dash_xcvr_debug_kit xcvr_status.debug_signal]  {	
			for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan] } {incr chan } {			
			# puts "updating phy=$phy Chan=$chan."
				
				if {[dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}] == 1 } {
					dashboard_set_property $dash [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}.led_id] color [dict get $dash_xcvr_debug_kit xcvr_status.native.${debug}.led_good_color] 
				} elseif {[dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}] == 0 } {
					dashboard_set_property $dash [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}.led_id] color [dict get $dash_xcvr_debug_kit xcvr_status.native.${debug}.led_bad_color]			
				} elseif {[dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}] == 0.5 } {
					dashboard_set_property $dash [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}.led_id] color "green_off"			
				}
				
			}
		}
	}
	# puts "."
	# puts $health_dict
	# puts  ""
}
proc healthkit_cable_is_swap { chan avmm phy } {
	if {0} { puts [info level 0] }	
	 global dash_xcvr_debug_kit 
	
	if {[ string tolower [dashboard_get_property [ dict get $dash_xcvr_debug_kit XCVR_Status.GUI_dash] xcvr_status_stop_check_${phy} checked]] == "false" } {
		adapt_reset $chan "$avmm"
		hard_prbs_reset $chan "$avmm" 
		after 10
		if { [ch_rx_is_lockedtodata $chan "$avmm"] } { 
			hard_prbs_reset $chan "$avmm"  
			hard_prbs_snapshot $chan "$avmm"
			set err [hard_prbs_error_count $chan "$avmm" 0 ]
			if $err { 
				hard_prbs_stop $chan "$avmm"
				rx_inversion $chan $avmm
				hard_prbs_start $chan "$avmm"
				hard_prbs_reset $chan "$avmm"  
				set err_1 [hard_prbs_error_count $chan "$avmm" 0 ]
				hard_prbs_stop $chan "$avmm"
				rx_inversion $chan $avmm
				hard_prbs_start $chan "$avmm"
				hard_prbs_reset $chan "$avmm" 
				if $err_1 { 
					set return_val 0
				} else {
					set return_val 1
				}
			} else {
				set return_val 0
			}
		} else {
			set return_val 0.5
		}
	} else {
		set return_val 0.5
	}
	return $return_val
}
proc healthkit_gui_tab { } {
		global dash_xcvr_debug_kit version
		set dash [add_service dashboard S10_Ltile_Htile_Transceiver_Status_Tool_v${version} "S10_Ltile_Htile_Transceiver_Status_Tool_v${version}" "Tools/S10_Ltile_Htile_Transceiver_Status_Tool_v${version}"]
		dict lappend dash_xcvr_debug_kit XCVR_Status.GUI_dash $dash
		# dashboard_set_property $dash self visible true
		set no_of_line 0

		widget_group $dash Transceiver_status_top self 1 ""
		
			widget_group $dash Transceiver_status_comment Transceiver_status_top 1 "Comments"
				widget_label $dash my_label1 Transceiver_status_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
				widget_label $dash my_label1 Transceiver_status_comment   "Tool_v${version} based on Q17.1.2" blue
				widget_label $dash my_label1 Transceiver_status_comment   "1.To use this Tool ADME should be Enabled" blue
				widget_label $dash my_label1 Transceiver_status_comment   "2.Uncheck checkbox to enable Cable P/N Swap test" blue
				widget_label $dash my_label1 Transceiver_status_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
			
			widget_group $dash Transceiver_status Transceiver_status_top 3 "Measurement Type"
				widget_button $dash xcvr_status_refresh_once Transceiver_status "Measure Transceiver Status Once" xcvr_status_refresh_once
				widget_checkBox $dash xcvr_status_refresh_continuous Transceiver_status "continuous update Disabled/check to Enable" xcvr_status_refresh_continuous
				widget_button 	$dash xcvr_status_log Transceiver_status "logfile" healthkit_logfile
			 
			widget_group $dash Transceiver_status_ch Transceiver_status_top 1 "PHY + Channel"
			foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
				
				set cable_name [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.cable_info]
				set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
				widget_group $dash $phy_name Transceiver_status_ch [expr [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan]  + 4] "${cable_name}${phy_name}" [expr ([string length $cable_name] +[string length $phy_name]) * 6 ]
					#row 1
					widget_label $dash xcvr_status_my_label_1  $phy_name   " " blue
					widget_label $dash xcvr_status_my_label_1  $phy_name   "Description" blue
					widget_label $dash xcvr_status_my_label_1  $phy_name   "Disable" blue
					for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan]  } {incr chan } {			
						widget_label $dash xcvr_status_my_label_1  $phy_name   "Ch$chan" blue
					}
					widget_label $dash xcvr_status_my_label_1  $phy_name   "click_for_help" blue
					#row 2 onwards
					foreach debug [dict get $dash_xcvr_debug_kit xcvr_status.debug_signal] {
						 
						widget_label $dash xcvr_status_my_label_1  $phy_name   "$debug" black
						widget_label $dash xcvr_status_my_label_1  $phy_name   "[dict get $dash_xcvr_debug_kit xcvr_status.native.$debug.led_comment]" black
						
						if { $debug == "cable_P_N_swap" } {
							widget_checkBox $dash xcvr_status_stop_check_${phy} $phy_name " " " " "true"
						} else {
							widget_label $dash xcvr_status_my_label_1  $phy_name   " " black
						}
						for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan]  } {incr chan } {			
							# healthkit_create_led    $dash  ${debug}_led_${phy}_${chan}    $phy_name  ""  yellow_off
							widget_led    $dash  xcvr_status.native.$phy.$chan.${debug}.led_id    $phy_name  ""  green_off
							set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}.led_id xcvr_status.native.$phy.$chan.${debug}.led_id  ]
						}
						widget_button $dash xcvr_status_help_${debug} $phy_name "${debug}_help" help_${debug}
					}
			}
		# puts -nonewline "."
		set no_of_phy 0
		foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
			incr no_of_phy 
		}
		set no_of_line [expr $no_of_phy * 14 + 6]
		
		dict lappend dash_xcvr_debug_kit xcvr_status.no_of_line $no_of_line
	}	
proc xcvr_status_refresh_once { } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit XCVR_Status.GUI_dash]
	dashboard_set_property $dash xcvr_status_refresh_once foregroundColor blue
	dashboard_set_property $dash xcvr_status_refresh_once text "updating"
	dashboard_set_property $dash xcvr_status_refresh_once enabled false
	healthkit_update_debug_signal
	dashboard_set_property $dash xcvr_status_refresh_once text "Measure Transceiver Status Once"
	dashboard_set_property $dash xcvr_status_refresh_once foregroundColor blue
	dashboard_set_property $dash xcvr_status_refresh_once enabled true
}
proc xcvr_status_refresh_continuous { } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit XCVR_Status.GUI_dash]
	set loop 1
	while {[string match [dashboard_get_property $dash xcvr_status_refresh_continuous checked] "true"]} {
		dashboard_set_property $dash xcvr_status_refresh_continuous foregroundColor blue
		dashboard_set_property $dash xcvr_status_refresh_continuous text "continuous update Enabled/Uncheck to Disable"
		healthkit_update_debug_signal
		puts "xcvr_status update in continuous mode, loop=$loop"
		incr loop
		after 200
    }
	dashboard_set_property $dash xcvr_status_refresh_continuous foregroundColor red
	dashboard_set_property $dash xcvr_status_refresh_continuous text "continuous update Disabled/check to Enable"
}
proc healthkit_logfile 		{ } {
	global dash_xcvr_debug_kit 
	set systemTime [clock seconds]
	set filename "log/healthkit_xcvr_status_log1_[clock format $systemTime -format  %jjulian_%Hhr_%Mmin_%Ssec]_[info hostname].csv"
	set data_log_file [open "$filename" "w"]
	puts "****************************************************************************************************************"
	puts "****************************************************************************************************************"
	puts "LogFile is created in the following folder --> [pwd]/log \n\n"
	foreach phy [dict get $dash_xcvr_debug_kit xcvr_status.native.phy_id] {
		puts -nonewline "phy_name,debug_signal,"
		puts -nonewline $data_log_file  "phy_name,debug_signal,"
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan] } {incr chan } {			
			puts -nonewline "channel$chan,"
			puts -nonewline $data_log_file  "Channel$chan,"
		}
		puts ""
		puts $data_log_file ""
		set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
		foreach debug [dict get $dash_xcvr_debug_kit xcvr_status.debug_signal]  {	
		puts -nonewline "$phy_name,$debug"
		puts -nonewline $data_log_file  "$phy_name,$debug"
			for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.no_of_chan] } {incr chan } {			
				puts -nonewline ",[dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}] "
				puts -nonewline $data_log_file ",[dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}] "
			}
			puts ""
			puts $data_log_file  ""
		}
	}
	close $data_log_file	
	puts "\n\n****************************************************************************************************************"
	puts "****************************************************************************************************************"
		
}
# ####help menu
proc help_rx_is_lockedtodata { } {
	puts "**************************************************************************************************************************"
	puts "step1:CDR PPM deviation limit violation"
	puts "	Ensure the maximum PPM difference limit between TX and RX in the link is within device specification 
			check CDR PPM setting in RX PMA tab under Native PHY IP 
			Set CDR to manual LTD mode, measure rx_clkout frequency"
	puts "Step2: Incoming data"
	puts "	Enable internal serial loopback. If CDR locks to data (rx_is_locktodata asserted), 
			the issue could be from the incoming data or not optimized link tuning 
		   	Check incoming data	does not violate run length specification of the device 
			adequate eye opening (if possible, probe the eye diagram at device RX pin 
			Perform link tuning to optimize RX buffer analog settings 
			A reset to RX channel is required under following conditions: 
			RX cable is unplugged and re-plugged 
			long period of idle on the link 
			incoming data path switched from external to internal loopback, and vice versa"
	puts ""
	puts "**************************************************************************************************************************"

}
proc help_rx_is_lockedtoref { } {
	puts "**************************************************************************************************************************"
	puts "Step1:Reference clock issue"
	puts "Ensure reference clock meets the specifications in datasheet"
	puts "Ensure the reference clock is free running and stable before device power up calibration"
	puts "**************************************************************************************************************************"
	
}
proc help_tx_cal_busy { } {
	puts "**************************************************************************************************************************"
	puts ""
	puts "step1	:upgrade design to the latest Quartus II release version" 
	puts "step2	:Tx_cal_busy signal stuck high indicates RX calibration is not completed. Debug calibration and reference clock"
	puts "step2a:Verify reference clock is free running and stable before and during calibration"
	puts "step2c:Verify CLKUSR is free running stable before and during calibration"
	puts "Step3	:Verify RREF resistor value and tolerance is within specification. Measure voltage at RREF resistor, the voltage VREF should be 0.7V"
 	puts ""
puts "**************************************************************************************************************************"
}
proc help_rx_cal_busy { } {
puts "**************************************************************************************************************************"	
puts ""
	puts "step1:upgrade design to the latest Quartus II release version" 
	puts "step2:Rx_cal_busy signal stuck high indicates RX calibration is not completed. Debug calibration and reference clock"
	puts "	step2a:Verify reference clock is free running and stable before and during calibration"
	puts "	step2b:Recalibrate the CDR under following conditions"
	puts "		step2b.1:If reference clock is not stable/available during power upcalibration"
	puts "		step2b.2:If the reference clock chip/buffer is initialize to a difference frequency during power up calibration"
	puts "	step2c:Verify CLKUSR is free running stable before and during calibration"
	puts "	step2d:Recalibrate the CDR if CLKSUR is disrupted during power up calibration"
	puts "Step3:Verify RREF resistor value and tolerance is within specification. Measure voltage at RREF resistor, the voltage VREF should be 0.7V"
 	puts ""
puts "**************************************************************************************************************************"
}
proc help_avmm_busy { } {
	puts ""
}
proc help_rx_seriallpbken { } {
puts "**************************************************************************************************************************"	
puts "Green LED: Serial loopback is enabled"
puts "**************************************************************************************************************************"
}
proc help_prbs_counter_en { } {
puts "**************************************************************************************************************************"
	puts "Green LED:The verifier is counting the number of error"
puts "**************************************************************************************************************************"
}
proc help_prbs_done { } {
puts "**************************************************************************************************************************"
	puts "Green LED : PRBS pattern found"
	puts "RED LED :PRBS pattern not found"
puts "**************************************************************************************************************************"
}
proc help_cable_P_N_swap { } {
puts "**************************************************************************************************************************"
	puts "Green LED : the P/N cables are matching"
	puts "Red LED	: the P/N ables are swaped"
	puts "Yellow LED : Either this function disabled or lock to data is low"
puts "**************************************************************************************************************************"
}
# ##################################################################################################################################################
# Tranceiver Voltage GUI
# ##################################################################################################################################################
proc atb_init { } {
	
	global dash_xcvr_debug_kit
	
	#finding the number of native phy ip instantiated
	set native_nos ""
	set k 0
	foreach temp [get_service_paths slave] {
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
		
			if { ($condition1 && $condition2 )} { 
				lappend native_nos $k 
				# set split_path [split $temp "/"]
				# set split_path [lindex $split_path 1]_[lindex $split_path 2]
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				# puts $split_path
				puts [lindex [marker_get_info $temp] 1]
				dict lappend dash_xcvr_debug_kit atb.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit atb.native.$k.cable_info $cable_info
			}
		}
		incr k
	}
	 
	if { [llength $native_nos] ==0  } {
		puts "**********************************************"
		puts "**** Error1: No Native Phy  Found 		****"
		puts "**** Cause1: Design has not been loaded	****"
		puts "**** Cause2: ADME is not enabled			****"
		puts "**********************************************"
	} 
	if { [llength $native_nos] ==0  } {
		error "**** Error1: No Native Phy  Found 		****"
	} 
	
	dict lappend dash_xcvr_debug_kit atb.native.no_of_phy [llength $native_nos]
	
	
	#preparing the dict to store the debug values
	# dict lappend dash_xcvr_debug_kit atb.GUI_dash ""
	dict lappend dash_xcvr_debug_kit atb.debug_signal VCCER VCCET

	
	
	foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
		dict lappend dash_xcvr_debug_kit atb.native.$phy.avmm 		[lindex [get_service_paths slave ] [lindex $native_nos $phy]]
		set avmm [lindex [get_service_paths slave ] $phy]
		dict lappend dash_xcvr_debug_kit atb.native.$phy.no_of_chan [expr [read_reg 0x410 0 $avmm]]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {
			
			#VCCER		
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.value 0
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.text 0
			
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.good.value 	1.15
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.average.value 	1.13
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.bad.value 		1.13
			
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.good.led_color 	green
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.average.led_color 	green
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.bad.led_color 		green
			
			#VCCET
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.value 0
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.text 0
			
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.good.value 	1.15
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.average.value 	1.13
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.bad.value 		1.13
			
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.good.led_color 	green
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.average.led_color 	green
			dict lappend dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.bad.led_color 		green

		}
	}
	
	# puts $dash_xcvr_debug_kit
}
proc atb_update_signal_all { } {
	global dash_xcvr_debug_kit
	foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
		atb_update_signal $phy
	}

}
proc atb_update_signal { phy } {
	if {0} { puts [info level 0] }
	global dash_xcvr_debug_kit
	# set dash [dict get $dash_xcvr_debug_kit Transceiver_Debug.GUI_dash]
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	
		set avmm [dict get $dash_xcvr_debug_kit atb.native.$phy.avmm ]
		set avmm [lindex [get_service_paths slave ] $phy]
		bkgrnd_cal_disable 0 $avmm
		atb_enable_disable 0 $avmm 1
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {
			#kill_loop $phy $dash
			bkgrnd_cal_disable $chan $avmm
			# puts -nonewline "." 
			#VCCER
			dashboard_set_property $dash VCCER_${phy}_status text "Measuring Channel ${chan}" 
			dashboard_set_property $dash VCCER_${phy}_status foregroundColor blue
			
			
			rdmwrite 0x15A 0x10 0x10 $chan $avmm ;
			atb_VCCER_dfe_enable_disable $chan $avmm 1
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.value [atb_find_voltage $phy $chan $avmm 5]]
			
			atb_VCCER_dfe_enable_disable $chan $avmm 0
			rdmwrite 0x15A 0x10 0x00 $chan $avmm ;
			bkgrnd_cal_enable 0 $avmm
			
			
			dashboard_set_property $dash VCCER_${phy}_status text "Done"
			dashboard_set_property $dash VCCER_${phy}_status foregroundColor black
			dashboard_set_property $dash [dict get $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.text] text [dict get $dash_xcvr_debug_kit atb.native.$phy.${chan}.VCCER.value]V
		}
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {
			#VCCET
			#kill_loop $phy $dash
			
			dashboard_set_property $dash VCCET_${phy}_status text "Measuring Channel ${chan}"
			dashboard_set_property $dash VCCET_${phy}_status foregroundColor blue
			bkgrnd_cal_disable $chan $avmm
			rdmwrite 0x15A 0x10 0x10 $chan $avmm ;
			atb_VCCET_top_enable_disable $chan $avmm 1
			set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.value [atb_find_voltage $phy $chan $avmm 5]]
			atb_VCCET_top_enable_disable $chan $avmm 0
			rdmwrite 0x15A 0x10 0x00 $chan $avmm ;
			dashboard_set_property $dash VCCET_${phy}_status text "Done"
			dashboard_set_property $dash VCCET_${phy}_status foregroundColor black
			dashboard_set_property $dash [dict get $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCET.text] text [dict get $dash_xcvr_debug_kit atb.native.$phy.${chan}.VCCET.value]V
			bkgrnd_cal_enable $chan $avmm
		}
		bkgrnd_cal_enable 0 $avmm

	
			
	# puts $dash_xcvr_debug_kit
	# puts  ""
}
proc atb_gui_tab {  } {
		global dash_xcvr_debug_kit version
		set dash [add_service dashboard S10_Ltile_Htile_Transceiver_Voltage_Debug_Tool_v${version} "S10_Ltile_Htile_Transceiver_Voltage_Debug_Tool_v${version}" "Tools/S10_Ltile_Htile_Transceiver_Voltage_Debug_Tool_v${version}"]
		dict lappend dash_xcvr_debug_kit atb.GUI_dash $dash
		# dashboard_set_property $dash self visible true
		
		set no_of_line 0
		# dict lappend dash_xcvr_debug_kit atb.main_tab "Transceiver_voltage_top"
		
		
		# widget_group $dash Transceiver_voltage_top $top_group_name 1 "Transceiver_Voltage"
		widget_group $dash Transceiver_voltage_top self 1 ""
			widget_group $dash Transceiver_voltage_comment Transceiver_voltage_top 1 "Comments"
				widget_label $dash my_label1 Transceiver_voltage_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
				widget_label $dash my_label1 Transceiver_voltage_comment   "Tool_v${version} based on Q17.1.2" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "To use this Tool ADME should be Enabled" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "Datarate < 17.4Gbps   - VCCET/VCCER - Min 1.0V || Typ 1.03V || Max 1.06V" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "Datarate > 17.4Gbps   - VCCET/VCCER - Min 1.1V || Typ 1.12V || Max 1.14V" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "Accuracy : +-18mV" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "Reference Voltage Look up table" blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    0.2328V,   0.2508V,   0.2688V,   0.2869V,   0.3049V,   0.3229V,   0.3409V,   0.3589V,   0.3770V,   0.3950V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    0.4130V,   0.4310V,   0.4490V,   0.4671V,   0.4851V,   0.5031V,   0.5211V,   0.5391V,   0.5572V,   0.5752V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    0.5932V,   0.6112V,   0.6292V,   0.6473V,   0.6653V,   0.6833V,   0.7013V,   0.7193V,   0.7374V,   0.7554V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    0.7734V,   0.7914V,   0.8094V,   0.8275V,   0.8455V,   0.8635V,   0.8815V,   0.8995V,   0.9176V,   0.9356V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    0.9536V,   0.9716V,   0.9896V,   1.0077V,   1.0257V,   1.0437V,   1.0617V,   1.0797V,   1.0978V,   1.1158V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "                    1.1338V,   1.1518V,   1.1698V,   1.1879V,   1.2059V,   1.2239V,   1.2419V,   1.2599V,   1.2780V,   1.2960V," blue
				widget_label $dash my_label1 Transceiver_voltage_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
			set native_nos 0
			foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
				incr native_nos
			}
	
			if {$native_nos > 1 } { 
			widget_group $dash Transceiver_voltage1 Transceiver_voltage_top 4 "Measurement Type"
				widget_button $dash atb_Measure_once Transceiver_voltage1 "Measure Voltages once - All PHY" atb_Measure_once_all
				widget_checkBox $dash atb_Measure_continuous Transceiver_voltage1 "continuous update Disabled/check to Enable" atb_Measure_continuous_all
				widget_checkBox $dash kill_loop_all Transceiver_voltage1 "Stop the current measurement" "kill_loop $dash" false
				widget_button 	$dash atb_log Transceiver_voltage1 "LogFile" atb_logfile
			}
			widget_group $dash Transceiver_voltage_ch Transceiver_voltage_top 1 "Phy + Channel"
				foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
					set cable_name [dict get $dash_xcvr_debug_kit atb.native.$phy.cable_info]
					set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
				widget_group $dash Transceiver_voltage2_$phy Transceiver_voltage_ch 3 "${cable_name}${phy_name}" [expr ([string length $cable_name] +[string length $phy_name]) * 6 ]
				
					widget_button $dash atb_Measure_once_$phy Transceiver_voltage2_$phy "Measure Voltage Once" "atb_Measure_once $phy"
					widget_checkBox $dash atb_Measure_continuous_$phy Transceiver_voltage2_$phy "continuous update Disabled/check to Enable" "atb_Measure_continuous $phy"
					widget_checkBox $dash kill_loop_$phy Transceiver_voltage2_$phy "Stop the current measurement" "kill_loop $phy $dash" false
					
				
					dashboard_add $dash $phy_name group Transceiver_voltage_ch
					dashboard_set_property $dash $phy_name itemsPerRow [expr [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan]  + 2]
					dashboard_add $dash atb_my_label_1 label $phy_name
					dashboard_set_property $dash atb_my_label_1 text ""
					dashboard_set_property $dash $phy_name preferredWidth 800
					
					
					for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan]  } {incr chan } {			
						widget_label $dash my_label1 $phy_name   "Ch$chan" blue
					}	
					widget_label $dash atb_my_label_1 $phy_name  "Status" blue
					
					foreach debug [dict get $dash_xcvr_debug_kit atb.debug_signal] {	
						
						dashboard_add $dash atb_my_label_1 label $phy_name
						dashboard_set_property $dash atb_my_label_1 text $debug
						
						for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan]  } {incr chan } {			
							widget_text $dash ${debug}_text_${phy}_${chan} $phy_name "--" black
							set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit atb.native.$phy.$chan.${debug}.text ${debug}_text_${phy}_${chan} ]
						}
						widget_label $dash ${debug}_${phy}_status $phy_name  "--" black
						# puts "${debug}_led_${phy}_status"
					}
				}
		set no_of_phy 0
		foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
			incr no_of_phy 
		}
		set no_of_line [expr $no_of_phy * 5 + 7]
		dict lappend dash_xcvr_debug_kit atb.no_of_line $no_of_line
	}	
proc atb_create_led {dash id grp txt hue} {
    global STDWIDTH
    dashboard_add           $dash  $id  led       $grp
    # dashboard_set_property  $dash  $id  minWidth  $STDWIDTH
    dashboard_set_property  $dash  $id  text      $txt
    dashboard_set_property  $dash  $id  color     $hue
}
proc atb_logfile { } {
	global dash_xcvr_debug_kit 
	set systemTime [clock seconds]
	if { ![file isdirectory log] } {file mkdir log } 
	set filename "log/xcvr_voltage_[clock format $systemTime -format  %jjulian_%Hhr_%Mmin_%Ssec]_[info hostname].csv"
	set data_log_file [open "$filename" "w"]
	puts "****************************************************************************************************************"
	puts "LogFile is created in the following folder --> $filename"
	puts "****************************************************************************************************************"
	foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
		puts -nonewline "phy_name,Voltage_Node,"
		puts -nonewline $data_log_file  "phy_name,debug_signal,"
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {			
			puts -nonewline "channel$chan,"
			puts -nonewline $data_log_file  "Channel$chan,"
		}
		puts ""
		puts $data_log_file ""
		set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
		foreach debug [dict get $dash_xcvr_debug_kit atb.debug_signal]  {	
		puts -nonewline "$phy_name,$debug"
		puts -nonewline $data_log_file  "$phy_name,$debug"
			for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit atb.native.$phy.no_of_chan] } {incr chan } {			
				puts -nonewline ",[dict get $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.value] "
				puts -nonewline $data_log_file ",[dict get $dash_xcvr_debug_kit atb.native.$phy.$chan.VCCER.value] "
			}
			puts ""
			puts $data_log_file  ""
		}
	}
	close $data_log_file		
	puts "\n\n****************************************************************************************************************"
	puts "LogFile is created in the following folder --> $filename"
	puts "****************************************************************************************************************"
	
}
proc atb_Measure_once_all { } {
	global dash_xcvr_debug_kit 
	# set dash [dict get $dash_xcvr_debug_kit Transceiver_Debug.GUI_dash]
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	
	# dashboard_set_property $dash atb_Measure_once checked "false"
    dashboard_set_property $dash atb_Measure_once foregroundColor blue
	dashboard_set_property $dash atb_Measure_once text "updating"
	dashboard_set_property $dash atb_Measure_once enabled false

	atb_update_signal_all
	dashboard_set_property $dash atb_Measure_once text "Measure Voltages once - All PHY"
	dashboard_set_property $dash atb_Measure_once foregroundColor blue
	dashboard_set_property $dash atb_Measure_once enabled true

}
proc atb_Measure_once { phy } {
	global dash_xcvr_debug_kit 
	# set dash [dict get $dash_xcvr_debug_kit Transceiver_Debug.GUI_dash]
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	
	# dashboard_set_property $dash atb_Measure_once checked "false"
    dashboard_set_property $dash atb_Measure_once_$phy foregroundColor blue
	dashboard_set_property $dash atb_Measure_once_$phy text "updating"
	dashboard_set_property $dash atb_Measure_once_$phy enabled false

	
	atb_update_signal $phy
	
	
	dashboard_set_property $dash atb_Measure_once_$phy text "Measure Voltage Once"
	dashboard_set_property $dash atb_Measure_once_$phy foregroundColor black
	dashboard_set_property $dash atb_Measure_once_$phy enabled true

}
proc atb_Measure_continuous_all { } {
	global dash_xcvr_debug_kit 
	# set dash [dict get $dash_xcvr_debug_kit Transceiver_Debug.GUI_dash]
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	set loop 1
	
	while {[dashboard_get_property $dash atb_Measure_continuous checked] == "true"} {
		dashboard_set_property $dash atb_Measure_continuous foregroundColor blue
		dashboard_set_property $dash atb_Measure_continuous text "continuous update Enabled/Uncheck to Disable"
		atb_update_signal_all
		puts "Voltage Measurement in continuous mode, loop=$loop"
		incr loop
		after 200	
		
    }
	dashboard_set_property $dash atb_Measure_continuous text "continuous update Disabled/check to Enable"
	dashboard_set_property $dash atb_Measure_continuous foregroundColor black
}
proc atb_Measure_continuous { phy } {
	global dash_xcvr_debug_kit 
	# set dash [dict get $dash_xcvr_debug_kit Transceiver_Debug.GUI_dash]
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	set loop 1
	
	while {[dashboard_get_property $dash atb_Measure_continuous_$phy checked] == "true"} {
		dashboard_set_property $dash atb_Measure_continuous_$phy foregroundColor blue
		dashboard_set_property $dash atb_Measure_continuous_$phy text "continuous update Enabled/Uncheck to Disable"
		atb_update_signal $phy
		puts "Voltage Measurement in continuous mode, loop=$loop"
		incr loop
		after 200	
		
    }
	dashboard_set_property $dash atb_Measure_continuous_$phy text "continuous update Disabled/check to Enable"
	dashboard_set_property $dash atb_Measure_continuous_$phy foregroundColor red
}
# ##################################################################################################################################################
# ATB function
# ##################################################################################################################################################
proc atb_vha_enable {  chan avmm  } {
  rdmwrite 0x0102 0x08 0x08 $chan $avmm ;
}  
proc atb_vha_disable { chan } {
  rdmwrite 0x0102 0x08 0x00 $chan $avmm ;
}  
proc atb_enable_disable { chan avmm {enable 0} } {
	# s10_vha_enable 0
	rdmwrite 0x102 0x08 0x08 $chan $avmm ;
	if $enable {
		# s10_vha_write 0 0 xatb_top.pm_aux_atb_bgbyp ATB_VCC_REF
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x5 $chan $avmm;
		write_reg 0x16E  0x20 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_io ATB0_IO_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_io ATB1_IO_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atb_en ATB_GLOBAL_ENABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x0 $chan $avmm;
		write_reg 0x16E  0x01 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0 ATBEN0_ENABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x1 $chan $avmm;
		write_reg 0x16E  0x02 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1 ATBEN1_ENABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x2 $chan $avmm;
		write_reg 0x16E  0x04 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_hssi ATB0_HSSI_PRECOMP_CLOSED
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x3 $chan $avmm;
		write_reg 0x16E  0x08 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_hssi ATB1_HSSI_PRECOMP_CLOSED
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x4 $chan $avmm;
		write_reg 0x16E  0x10 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_comp_plus ATB_COMP_PLUS_CONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x5 $chan $avmm;
		write_reg 0x16E  0x20 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_comp_minus ATB_COMP_MINUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atbcmp_pdb ATB_COMP_POWER_ON
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_swap ATBEN0_SWAP_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0019 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_swap ATBEN1_SWAP_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0019 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vrefen_plus VREF_COMP_PLUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x0 $chan $avmm;
		write_reg 0x16E  0x01 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vrefen_minus VREF_COMP_MINUS_CONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x1 $chan $avmm;
		write_reg 0x16E  0x02 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vgen_pdb VREF_POWER_ON
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x2 $chan $avmm;
		write_reg 0x16E  0x04 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_dftcmp_pdb DFT_COMP_POWER_ON
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x3 $chan $avmm;
		write_reg 0x16E  0x08 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write $chans 0 xpm_cr_aux.pm_aux_tstmux_statreg PM_AUX_TSTMUX_STATREG_5
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x1D $chan $avmm;
		write_reg 0x16C  0x5 $chan $avmm;
		write_reg 0x16D  0x04 $chan $avmm;
		write_reg 0x16E  0x70 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
	} else {
		rdmwrite 0x15A 0x10 0x00 0 $avmm ;
		# s10_vha_write 0 0 xatb_top.pm_aux_atb_bgbyp ATB_VCC_REF
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x01 $chan $avmm;
		write_reg 0x16D  0x5 $chan $avmm;
		write_reg 0x16E  0x20 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_io ATB0_IO_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_io ATB1_IO_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0017 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atb_en ATB_GLOBAL_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x0 $chan $avmm;
		write_reg 0x16E  0x01 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0 ATBEN0_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x1 $chan $avmm;
		write_reg 0x16E  0x02 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1 ATBEN1_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x2 $chan $avmm;
		write_reg 0x16E  0x04 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_hssi ATB0_HSSI_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x3 $chan $avmm;
		write_reg 0x16E  0x08 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_hssi ATB1_HSSI_PRECOMP_OPEN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x4 $chan $avmm;
		write_reg 0x16E  0x10 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_comp_plus ATB_COMP_PLUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x5 $chan $avmm;
		write_reg 0x16E  0x20 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_comp_minus ATB_COMP_MINUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atbcmp_pdb ATB_COMP_POWER_DOWN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0018 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben0_swap ATBEN0_SWAP_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0019 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x6 $chan $avmm;
		write_reg 0x16E  0x40 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_atben1_swap ATBEN1_SWAP_DISABLE
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x0019 $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x7 $chan $avmm;
		write_reg 0x16E  0x80 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vrefen_plus VREF_COMP_PLUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x0 $chan $avmm;
		write_reg 0x16E  0x01 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vrefen_minus VREF_COMP_MINUS_DISCONNECT
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x1 $chan $avmm;
		write_reg 0x16E  0x02 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_vgen_pdb VREF_POWER_DOWN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x2 $chan $avmm;
		write_reg 0x16E  0x04 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;
		# s10_vha_write 0 0 xatb_top.pm_aux_dftcmp_pdb DFT_COMP_POWER_DOWN
		write_reg 0x16A  0x02 $chan $avmm;
		write_reg 0x16B  0x001D $chan $avmm;
		write_reg 0x16C  0x00 $chan $avmm;
		write_reg 0x16D  0x3 $chan $avmm;
		write_reg 0x16E  0x08 $chan $avmm;
		write_reg 0x0  0x3 $chan $avmm;

	}
	rdmwrite 0x102 0x08 0x0 $chan $avmm ;
}
proc atb_VCCER_dfe_enable_disable  { chan avmm {enable 0} } {
	if $enable {
	rdmwrite 0x0155 0x1F 0x1C $chan $avmm;
	} else {
	rdmwrite 0x0155 0x1F 0x00 $chan $avmm;
	}
}
proc atb_VCCET_top_enable_disable { chan avmm {enable 0} } {

	if $enable {
		rdmwrite 0x010E 0x0F 0x01 $chan $avmm ;
	} else  {
		rdmwrite 0x010E 0x0F 0x00 $chan $avmm ;
	}

}
proc atb_find_voltage { phy chan avmm {iter_val 5}} {
	
	rdmwrite 0x102 0x08 0x08 $chan $avmm ;
	
	set index_list {}
	for { set iter 0 } { $iter < $iter_val } { incr iter } {
		for {set vgen_sel 32} {$vgen_sel < 59} {incr vgen_sel} {
			# puts "index $vgen_sel"
			# stratix10_dprio::vha_write $m_path 0 0 0x19 [dec2hex $vgen_sel] 0x0 0x3f
			
			write_reg 0x16A  0x02 $chan $avmm;
			write_reg 0x16B  0x0019 $chan $avmm;
			write_reg 0x16C  0x[format %X $vgen_sel] $chan $avmm;
			write_reg 0x16D  0x0 $chan $avmm;
			write_reg 0x16E  0x3F $chan $avmm;
			write_reg 0x0  	0x3 $chan $avmm;
	
			write_reg 0x16A  0x03 $chan $avmm;
			write_reg 0x16B  0x28 $chan $avmm;
			write_reg 0x16D  0x06 $chan $avmm;
			write_reg 0x16E  0x40 $chan $avmm;
			write_reg 0x0  0x3 $chan $avmm;
			set comp_out_value [expr [read_reg 0x16C  $chan $avmm]];
			# puts $comp_out_value
			# set comp_out_value [string range $comp_out_value 8 9]
			
			 if {$comp_out_value == 0 } {
				 # puts "$vgen_sel: Vref Voltage value:[voltage_lookup $vgen_sel] - $comp_out_value"
				 lappend index_list $vgen_sel
				 break
			}
		}
	}
	rdmwrite 0x102 0x08 0x0 $chan $avmm ;

	set index_list [lsort -integer -decreasing $index_list]
	
	set res [atb_lcount $index_list]
	
	set index_list $res
	set index_max 0
	set freq_max 0
	
	foreach element $index_list {
		set curr_index [lindex $element 0] 
		set curr_freq [lindex $element 1] 
		if { $curr_freq <= $freq_max } {
			set freq_max $freq_max
			set index_max $index_max
		} else { 
			set freq_max $curr_freq
			set index_max $curr_index
		}
		
	}
	# puts "index_max=$index_max,freq_max=$freq_max"
	set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
	puts "$phy_name || chan$chan :[atb_voltage_lookup $index_max]V"
	return [atb_voltage_lookup $index_max]
}
proc atb_lcount list {
    foreach x $list {lappend arr($x) {}}
    set res {}
    foreach name [array names arr] {
       lappend res [list $name [llength $arr($name)]]
    }
    return $res
 }
proc atb_voltage_lookup { index } {
return [lindex "
0.23280
0.25082
0.26884
0.28686
0.30488
0.32290
0.34092
0.35894
0.37696
0.39498
0.41300
0.43102
0.44904
0.46706
0.48508
0.50310
0.52112
0.53914
0.55716
0.57518
0.59320
0.61122
0.62924
0.64726
0.66528
0.68330
0.70132
0.71934
0.73736
0.75538
0.77340
0.79142
0.80944
0.82746
0.84548
0.86350
0.88152
0.89954
0.91756
0.93558
0.95360
0.97162
0.98964
1.00766
1.02568
1.04370
1.06172
1.07974
1.09776
1.11578
1.13380
1.15182
1.16984
1.18786
1.20588
1.22390
1.24192
1.25994
1.27796
1.29598
" $index]
 
}
# ########################################################################################################################
# ODI
# ########################################################################################################################
proc ODI_plot_whole_eye 	{ chan avmm } {
	global dash_xcvr_debug_kit ODI_dict_err 
	
	# ODI_pma_init $chan $avmm ;	
	# ODI_init $chan $avmm 
	
	set even_parm 0
	set bottom_parm 1 
	set spec_parm 4 
	set horiz_start_parm 1
	set horiz_stop_parm 128
	set horiz_inc_parm 2
	set vert_start_parm 0 
	set vert_stop_parm 64
	set vert_inc_parm 2  
	set fast_err 1
	set phy 0 
	set dash 0
	
	bkgrnd_cal_disable $chan $avmm
	# set_tx 31 -5 0 $chan $avmm
	htile_hard_prbs_pattern_gen $chan 31 $avmm
	htile_hard_prbs_pattern_chk $chan 31 $avmm
	hard_prbs_start  $chan $avmm
	adapt_ctle_dfe $chan $avmm
	adapt_reset $chan $avmm
	hard_prbs_reset $chan $avmm
	bkgrnd_cal_enable $chan $avmm
			
			
			
	bkgrnd_cal_disable $chan $avmm 
	set ODI_dict_err ""
	set debug_reg_rw 0
	if 1 {
		# ODI_pma_init $chan $avmm
		ODI_init $chan $avmm
		set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
		#Horizontal intilization
		ODI_set_no_of_bits 1e6 $chan $avmm
		set even 0
		ODI_set_odd_even_bits $even $chan $avmm
		for {set spec 0} {$spec < $spec_parm } {incr spec } {
			ODI_set_spec_bits $h1_sign $spec $chan $avmm
			 
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				ODI_set_top_bottom_bits $bottom $chan $avmm
				 
				for {set vert 0  } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					ODI_vertical_bits $bottom $vert 0 $chan $avmm
					 
					for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
						#######
						# if {$dash != 0 } {kill_loop $phy $dash }				
						#######
						set ODI_count [ODI_counter_stats 1e6 $chan $avmm $phy $dash]
						if {$ODI_count ==1} {set ODI_count 0 }
						# puts [clock seconds]seconds
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err $ODI_count 
						# puts "$even.$spec.$bottom.$vert.$horiz $ODI_count" 
					}
				}
			}
		}
		ODI_combine_top_bottom_eye  "horizontal" $chan $avmm $even_parm $bottom_parm $spec_parm $horiz_start_parm $horiz_stop_parm $horiz_inc_parm $vert_start_parm $vert_stop_parm $vert_inc_parm
	}

	bkgrnd_cal_enable $chan $avmm 
	if { ![file isdirectory log] } {file mkdir log } 
	set systemTime [clock seconds];set file [open "log/Eye_measurement_[clock format [clock seconds] -format  %jjulian_%Hhr_%Mmin_%Ssec]_[info hostname].csv" "w"]
	puts -nonewline $file "chan,even,bottom,na,vert,"
	for { set horiz $horiz_start_parm } { $horiz < $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
		puts -nonewline $file "$horiz,"
	}
	puts -nonewline $file "\n" 

	#Combine 
	for { set even 0 } { $even <= $even_parm} { incr even } {
		for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
			for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
				if $bottom { 
					puts -nonewline $file "$chan,$even,$bottom,na,$vert,"
				} else {
					puts -nonewline $file "$chan,$even,$bottom,na,[expr $vert_stop_parm - $vert],"
				}
				for { set horiz $horiz_start_parm } { $horiz < $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
					puts -nonewline $file "[dict get $ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err],"
				}
			puts -nonewline $file "\n" 
			}
		}
	}

	#pd clock
	for { set even 0 } { $even < -1} { incr even } {
		for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
			for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					puts -nonewline $file  "$chan,$even,$bottom,na,$vert,"
					for { set horiz $horiz_start_parm } { $horiz < $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						puts -nonewline $file  "[dict get $ODI_dict_err native.$avmm.$chan.$even.0.$bottom.$vert.$horiz.ODI_get_even_pd_bit],"
					}
				puts -nonewline $file  "\n" 
				}
			}
	}
	#all
	for { set even 0 } { $even <= $even_parm} { incr even } {
		for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
			for {set spec 0 } {$spec < $spec_parm } {incr spec} {
				for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					puts -nonewline $file "$chan,$even,$bottom,$spec,$vert,"
					for { set horiz $horiz_start_parm } { $horiz < $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						puts -nonewline $file "[dict get $ODI_dict_err horizontal.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err],"
					}
				puts -nonewline $file "\n" 
				}
			}	
		}
	}
	close $file
}
proc ODI_pi_encoder 		{	pi_in} {

  switch -exact -- $pi_in {
    "1"   {set pi_encode 0x71}
    "2"   {set pi_encode 0x70}
    "3"   {set pi_encode 0x73}
    "4"   {set pi_encode 0x72}
    "5"   {set pi_encode 0x77}
    "6"   {set pi_encode 0x76}
    "7"   {set pi_encode 0x75}
    "8"   {set pi_encode 0x74}
    "9"   {set pi_encode 0x7D}
    "10"  {set pi_encode 0x7C}
    "11"  {set pi_encode 0x7F}
    "12"  {set pi_encode 0x7E}
    "13"  {set pi_encode 0x7B}
    "14"  {set pi_encode 0x7A}
    "15"  {set pi_encode 0x79}
    "16"  {set pi_encode 0x78}
    "17"  {set pi_encode 0x69}
    "18"  {set pi_encode 0x68}
    "19"  {set pi_encode 0x6B}
    "20"  {set pi_encode 0x6A}
    "21"  {set pi_encode 0x6F}
    "22"  {set pi_encode 0x6E}
    "23"  {set pi_encode 0x6D}
    "24"  {set pi_encode 0x6C}
    "25"  {set pi_encode 0x65}
    "26"  {set pi_encode 0x64}
    "27"  {set pi_encode 0x67}
    "28"  {set pi_encode 0x66}
    "29"  {set pi_encode 0x63}
    "30"  {set pi_encode 0x62}
    "31"  {set pi_encode 0x61}
    "32"  {set pi_encode 0x60}
    "33"  {set pi_encode 0x40}
    "34"  {set pi_encode 0x41}
    "35"  {set pi_encode 0x42}
    "36"  {set pi_encode 0x43}
    "37"  {set pi_encode 0x46}
    "38"  {set pi_encode 0x47}
    "39"  {set pi_encode 0x44}
    "40"  {set pi_encode 0x45}
    "41"  {set pi_encode 0x4C}
    "42"  {set pi_encode 0x4D}
    "43"  {set pi_encode 0x4E}
    "44"  {set pi_encode 0x4F}
    "45"  {set pi_encode 0x4A}
    "46"  {set pi_encode 0x4B}
    "47"  {set pi_encode 0x48}
    "48"  {set pi_encode 0x49}
    "49"  {set pi_encode 0x58}
    "50"  {set pi_encode 0x59}
    "51"  {set pi_encode 0x5A}
    "52"  {set pi_encode 0x5B}
    "53"  {set pi_encode 0x5E}
    "54"  {set pi_encode 0x5F}
    "55"  {set pi_encode 0x5C}
    "56"  {set pi_encode 0x5D}
    "57"  {set pi_encode 0x54}
    "58"  {set pi_encode 0x55}
    "59"  {set pi_encode 0x56}
    "60"  {set pi_encode 0x57}
    "61"  {set pi_encode 0x52}
    "62"  {set pi_encode 0x53}
    "63"  {set pi_encode 0x50}
    "64"  {set pi_encode 0x51}
    "65"  {set pi_encode 0x11}
    "66"  {set pi_encode 0x10}
    "67"  {set pi_encode 0x13}
    "68"  {set pi_encode 0x12}
    "69"  {set pi_encode 0x17}
    "70"  {set pi_encode 0x16}
    "71"  {set pi_encode 0x15}
    "72"  {set pi_encode 0x14}
    "73"  {set pi_encode 0x1D}
    "74"  {set pi_encode 0x1C}
    "75"  {set pi_encode 0x1F}
    "76"  {set pi_encode 0x1E}
    "77"  {set pi_encode 0x1B}
    "78"  {set pi_encode 0x1A}
    "79"  {set pi_encode 0x19}
    "80"  {set pi_encode 0x18}
    "81"  {set pi_encode 0x09}
    "82"  {set pi_encode 0x08}
    "83"  {set pi_encode 0x0B}
    "84"  {set pi_encode 0x0A}
    "85"  {set pi_encode 0x0F}
    "86"  {set pi_encode 0x0E}
    "87"  {set pi_encode 0x0D}
    "88"  {set pi_encode 0x0C}
    "89"  {set pi_encode 0x05}
    "90"  {set pi_encode 0x04}
    "91"  {set pi_encode 0x07}
    "92"  {set pi_encode 0x06}
    "93"  {set pi_encode 0x03}
    "94"  {set pi_encode 0x02}
    "95"  {set pi_encode 0x01}
    "96"  {set pi_encode 0x00}
    "97"  {set pi_encode 0x20}
    "98"  {set pi_encode 0x21}
    "99"  {set pi_encode 0x22}
    "100" {set pi_encode 0x23}
    "101" {set pi_encode 0x26}
    "102" {set pi_encode 0x27}
    "103" {set pi_encode 0x24}
    "104" {set pi_encode 0x25}
    "105" {set pi_encode 0x2C}
    "106" {set pi_encode 0x2D}
    "107" {set pi_encode 0x2E}
    "108" {set pi_encode 0x2F}
    "109" {set pi_encode 0x2A}
    "110" {set pi_encode 0x2B}
    "111" {set pi_encode 0x28}
    "112" {set pi_encode 0x29}
    "113" {set pi_encode 0x38}
    "114" {set pi_encode 0x39}
    "115" {set pi_encode 0x3A}
    "116" {set pi_encode 0x3B}
    "117" {set pi_encode 0x3E}
    "118" {set pi_encode 0x3F}
    "119" {set pi_encode 0x3C}
    "120" {set pi_encode 0x3D}
    "121" {set pi_encode 0x34}
    "122" {set pi_encode 0x35}
    "123" {set pi_encode 0x36}
    "124" {set pi_encode 0x37}
    "125" {set pi_encode 0x32}
    "126" {set pi_encode 0x33}
    "127" {set pi_encode 0x30}
    "128" {set pi_encode 0x31}
    default {set pi_encode 0x31}
  } 
  return $pi_encode 
}
proc ODI_check_done 		{ 	chan avmm } {
  if {0} { puts [info level 0] }
  global  dash_xcvr_debug_kit 
  # bkgrnd_cal_read $chan $avmm
  rdmwrite  0x149 0x3f 0x1c $chan $avmm ;#10
  set temp [read_reg 0x17e $chan $avmm]
  set status [read_reg 0x17E $chan $avmm]
  #  puts "\nODI_done $status"
  set done1 [expr $status / 2]
  set done2 [expr $done1 & 0x01]
  if { $done2 == 1 } {
    return 1
  } else {
      return 0
    }
}
proc ODI_get_pd_bit  		{ 	chan avmm } {
if {0} { puts [info level 0] }	
  rdmwrite 0x171 0x1E 0x0A $chan $avmm;
  set even_pi_bit [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 4 4]
  set odd_pi_bit [string range [format %08s [dec2bin [expr [read_reg 0x17e  $chan $avmm; ]]]] 5 5]
  rdmwrite  0x171 0x1e 0x16 $chan $avmm ;#L
  return "$even_pi_bit $odd_pi_bit"
}
proc ODI_init 				{ chan avmm } {
	global  dash_xcvr_debug_kit  ODI_dict_err

	#1.	Disable the background calibration if the device is H-Tile production and background calibration is enabled:
		#a.	Set 0x542[0] to 0x0
		#rdmwrite 0x542 0x1 0x0 $chan $avmm  ;
		
		#b.	Read 0x481[2] until it becomes 0x0
		# puts "0x481 [read_reg 0x481 $chan $avmm]"
		# puts "0x481 [expr [read_reg 0x481 $chan $avmm] & [expr 0xFF & 0x02]]"
		after 500
		
	#2.	Request access to the Native PHY’s AVMM bus:
		#a.	Set 0x000 to 0x02
		write_reg 0x0 0x02 0 $avmm 
		after 500
		#b.	Read 0x481[2] until it becomes 0x0	

	
	# Initialize ODI 
	set adapt_val [adapt_reverse_engineer $chan $avmm]
	#1. If the RX is in adaptation mode, set 0x148[1] to 0x1
	if { ($adapt_val == "manual")  } {
		# rdmwrite 0x148 0x02 0x02 $chan $avmm  ;# B
	} else {
		# rdmwrite 0x148 0x02 0x00 $chan $avmm  ;# B
	}
	
	#2. Set register 0x169[6] to 0x1 to enable the counter to detect error bits.
		rdmwrite 0x169 0x40 0x40 $chan $avmm  ;# B
	#3. Set register 0x168[0] to 0x1 to enable the serial bit detector for ODI.
		rdmwrite 0x168 0x01 0x01 $chan $avmm  ;# B
	#4. If the DFE is enabled/disable:

	if { ($adapt_val == "manual") || ($adapt_val == "ctle_adaptive_no_dfe") } {
		rdmwrite 0x169 0x04 0x00 $chan $avmm  ;#C
		dict lappend ODI_dict_err ODI.native.$avmm.$chan.adapt_val  "dfe_disable"
	} else {
		#a Set register 0x169[2] to 0x1 to enable DFE speculation.
		rdmwrite 0x169 0x04 0x04 $chan $avmm  ;#C
		#b. Set register 0x149[5:0] to 0x07 to read the DFE tap signs.
		rdmwrite 0x149 0x3f 0x07 $chan $avmm  ;#D
		#c. Read register 0x17F[6] and store it as DFE_tap1_sign.
		set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
		dict lappend ODI_dict_err ODI.native.$avmm.$chan.adapt_val  "dfe_enable"
		if [dict exists ODI_dict_err ODI.native.$avmm.$chan.h1_sign] {
			set ODI_dict_err [dict replace $ODI_dict_err ODI.native.$avmm.$chan.h1_sign $h1_sign]
		} else {
			dict lappend ODI_dict_err ODI.native.$avmm.$chan.h1_sign  $h1_sign
		}
	} 
		
	
	
	#6. Trade off between runtime and BER resolution by setting the number of bits to count before stopping at each horizontal or vertical step. Set {0x169[1:0], 0x168[5]} to: 	
	rdmwrite 0x169 0x03 0x00 $chan $avmm  ;# A
	rdmwrite 0x168 0x20 0x01 $chan $avmm  ;# A
	
	#7. Set register 0x158[5] to 0x1 to enable the serial bit comparator control from AVMM.
	rdmwrite 0x158 0x20 0x20 $chan $avmm  ;#F
	#8. Set register 0x12D[4] to 0x1 to disable the path from the DFE to the AVMM testmux.
	rdmwrite 0x12d 0x10 0x00 $chan $avmm  ;#G

	#9. Configure the ODI bandwidth by writing the values from the following table into register {0x145[7], 0x144[7]} based on datarate.
	set datarate [expr [lindex [marker_get_assignments $avmm] 1]/1e9]
	# puts "Datarate = $datarate"
	if 1 {
	if { $datarate > 25 } {
		rdmwrite 0x145 0x80 0x00  $chan $avmm   ;#H
		rdmwrite 0x144 0x80 0x00 $chan $avmm   ;#H
	} elseif { $datarate > 16 } {
		rdmwrite 0x145 0x80 0x00 $chan $avmm   ;#H
		rdmwrite 0x144 0x80 0x80 $chan $avmm   ;#H
	} elseif { $datarate > 10 } {
		rdmwrite 0x145 0x80 0x80 $chan $avmm   ;#H
		rdmwrite 0x144 0x80 0x00 $chan $avmm   ;#H
	} else {
		rdmwrite 0x145 0x80 0x80 $chan $avmm   ;#H
		rdmwrite 0x144 0x80 0x80 $chan $avmm   ;#H
	}
	}
	
	#10. Set register 0x144[6:4] to 0x0 to set the ODI phase interpolator to 128.
	rdmwrite 0x144 0x70 0x00 $chan $avmm  ;#I
	
	#11. Set register 0x140[5:3] to 0x0 to disable the ODI test pattern generator.
	rdmwrite 0x140 0x38 0x00 $chan $avmm  ;#J
	#12. Set register 0x13C[0] to 0x0, then set it to 0x1 to reset the serial bit checker logic.
	rdmwrite 0x13c 0x01 0x00 $chan $avmm  ;#K
	rdmwrite 0x13c 0x01 0x01 $chan $avmm  ;#K
	#13. Set register 0x171[4:1] to 0xB, to configure the testmux to read out the ODI counter values.
	rdmwrite 0x171 0x1e 0x16 $chan $avmm  ;#L
	
	
}
proc ODI_analyze_eye 		{ 	chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm fast_err  {phy 0 } {dash 0} } {
	# if {0} { puts [info level 0] }
	global  dash_xcvr_debug_kit  ODI_dict_err
	set   	ODI_dict_err ""
	set 	debug_reg_rw 0
	# ODI_pma_init $chan $avmm
	ODI_init $chan $avmm
	set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
	for { set even 0 } { $even <= $even_parm } { incr even } {
		if {$even == 0} {
			rdmwrite  0x157 0x0c 0x04 $chan $avmm ;#1
		} else {
			rdmwrite  0x157 0x0c 0x08 $chan $avmm ;#1
		}
		for {set spec 0} {$spec < $spec_parm } {incr spec } {
			# set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]

			if {$spec == 0} {
               	rdmwrite 0x14d 0x01 0x00 $chan $avmm ; #3
				rdmwrite 0x144 0x04 0x00  $chan $avmm ;#2
               if {$h1_sign == 0} {
                  rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
               } else {
                  rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
               }
            }
            if {$spec == 1} {
               rdmwrite 0x14d 0x01 0x01 $chan $avmm ; #3
               rdmwrite 0x144 0x04 0x00  $chan $avmm ;#2
               if {$h1_sign == 0} {
                  rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
               } else {
                  rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
               }
            }
            if {$spec == 2} {
               rdmwrite 0x14d 0x01 0x00 $chan $avmm ; #3
               rdmwrite 0x144 0x04 0x04  $chan $avmm ;#2
               if {$h1_sign == 0} {
                  rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
               } else {
                  rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
               }
            }
            if {$spec == 3} {
               rdmwrite 0x14d 0x01 0x01 $chan $avmm ; #3
               rdmwrite 0x144 0x04 0x04  $chan $avmm ;#2
               if {$h1_sign == 0} {
                  rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
               } else {
                  rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
               }
            }
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				
				if {$bottom == 0} {
					rdmwrite  0x156 0x01 0x01 $chan $avmm ;#4
				} else {
					rdmwrite  0x156 0x01 0x00 $chan $avmm ;#4
				}
				for {set vert $vert_start_parm  } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					if {$bottom == 0} {
						set vert2 0x[format %X [expr $vert_stop_parm*4 - $vert * 4]]
					} else {
						set vert2  0x[format %X [expr $vert * 4]]

					}
					rdmwrite  0x143 0xfc $vert2  $chan $avmm ;#7
					for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						if {$dash != 0 } {kill_loop $phy $dash }				
						# if {[get_stop]} { break } 
						
						rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
						set ODI_count 0
						set pattern_count 0
						
						#######
						if 1 {
						rdmwrite  0x168 0x04 0x00 $chan $avmm ;#9
						rdmwrite  0x168 0x04 0x04 $chan $avmm ;#9
						} else {
						set value_kk [read_reg 0x168 $chan $avmm]
						set value_kk [expr $value_kk & [expr 0xFF & ~0x04]]
						set value_kk1 [expr $value_kk | 0x0]
						write_reg 0x168 0x[format %X  $value_kk1] $chan $avmm
						set value_kk2 [expr $value_kk | 0x04]
						write_reg 0x168 0x[format %X  $value_kk2] $chan $avmm
						}
						######
						
						rdmwrite  0x149 0x3f 0x1c $chan $avmm ;#10
						# after 20
						set is_done [ODI_check_done  $chan $avmm]
						set start_time [clock milliseconds]
						set interval 0
						if 1 {
							while { (!$is_done) && ($interval < 1000) } {
								set curr_time [clock milliseconds]
								set is_done [ODI_check_done  $chan $avmm]
								set interval [expr $curr_time - $start_time]
							}
							if {$interval > 10000} {
								# error "ODI read time out"
							}
						}
						
						#write_reg 0x17E 0x0 $chan $avmm					
						set ODI_count_a 1
						set ODI_count_b 1
						set ODI_count_c 1
						set ODI_count_d 1
						
						
						set value_kk [read_reg 0x149 $chan $avmm]
						set value_kk [expr $value_kk & [expr 0xFF & ~0x3f]]
						set value_ODI_count_a [expr $value_kk | 0x1b]
						set value_ODI_count_b [expr $value_kk | 0x1a]
						set value_ODI_count_c [expr $value_kk | 0x19]
						set value_ODI_count_d [expr $value_kk | 0x18]
						
						
						#ODI_count_a
						
						# rdmwrite  0x149 0x3f 0x1b $chan $avmm
						write_reg 0x149 0x[format %X  $value_ODI_count_a] $chan $avmm
						set ODI_count_a [read_reg 0x17E $chan $avmm]
						# set fast_err 1
						if { $fast_err > 0 } {
							if {[expr $ODI_count_a] == 0} {
								#ODI_count_b
								# rdmwrite 0x149 0x3f 0x1a $chan $avmm 
								write_reg 0x149 0x[format %X  $value_ODI_count_b] $chan $avmm								
								set ODI_count_b [read_reg 0x17E $chan $avmm]
								if { [expr $ODI_count_b] ==0 } {
									#ODI_count_c
									# rdmwrite  0x149 0x3f 0x19 $chan $avmm
									write_reg 0x149 0x[format %X  $value_ODI_count_c] $chan $avmm	
									set ODI_count_c [read_reg 0x17E $chan $avmm]
									if { [expr $ODI_count_c] ==0 } {
										#ODI_count_d
										rdmwrite  0x149 0x3f 0x18 $chan $avmm
										write_reg 0x149 0x[format %X  $value_ODI_count_d] $chan $avmm
										set ODI_count_d [read_reg 0x17E $chan $avmm]
									}
								}
							}
						} else {
							
							# rdmwrite 0x149 0x3f 0x1a $chan $avmm     
							write_reg 0x149 0x[format %X  $value_ODI_count_b] $chan $avmm
							set ODI_count_b [read_reg 0x17E $chan $avmm]
							# rdmwrite  0x149 0x3f 0x19 $chan $avmm
							write_reg 0x149 0x[format %X  $value_ODI_count_c] $chan $avmm
							set ODI_count_c [read_reg 0x17E $chan $avmm]
							# rdmwrite  0x149 0x3f 0x18 $chan $avmm
							write_reg 0x149 0x[format %X  $value_ODI_count_d] $chan $avmm
							set ODI_count_d [read_reg 0x17E $chan $avmm]
						}
						
						
						
						
						if 0 {
							rdmwrite  0x149 0x3f 0x17 $chan $avmm
							after 10					
							set pattern_count_a [read_reg 0x17E $chan $avmm]
							set pattern_count_a [read_reg 0x17E $chan $avmm]
							rdmwrite  0x149 0x3f 0x16 $chan $avmm
							after 10					
							set pattern_count_b [read_reg 0x17E $chan $avmm]
							set pattern_count_b [read_reg 0x17E $chan $avmm]
							rdmwrite  0x149 0x3f 0x15 $chan $avmm
							after 10					
							set pattern_count_c [read_reg 0x17E $chan $avmm]
							set pattern_count_c [read_reg 0x17E $chan $avmm]
							rdmwrite  0x149 0x3f 0x14 $chan $avmm
							after 10					
							set pattern_count_d [read_reg 0x17E $chan $avmm]
							set pattern_count_d [read_reg 0x17E $chan $avmm]
						}
						
						set ODI_count [expr $ODI_count_a * 2**24 + $ODI_count_b * 2**16 + $ODI_count_c * 2**8 + $ODI_count_d]
						# set pattern_count [expr $pattern_count_a * 2**24 + $pattern_count_b * 2**16 + $pattern_count_c * 2**8 + $pattern_count_d]
						# if { [expr $horiz_start_parm + 1 ]  == $horiz_stop_parm } {
							# puts "chan$chan.$even.$spec.$bottom.$vert.$horiz : err_count=$ODI_count,"
						# }
						if {$ODI_count ==1} {set ODI_count 0 }
						dict lappend ODI_dict_err native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err $ODI_count 
						dict lappend ODI_dict_err native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.ODI_get_even_pd_bit [lindex [ODI_get_pd_bit $chan $avmm] 0]
						# dict lappend ODI_dict_err native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.ODI_get_odd_pd_bit [lindex [ODI_get_pd_bit $chan $avmm] 1]
					
					}
				}
			}
		}
	}
	# ODI_combine_top_bottom_eye  $chan $avmm $even_parm $bottom_parm $spec_parm $horiz_start_parm $horiz_stop_parm $horiz_inc_parm $vert_start_parm $vert_stop_parm $vert_inc_parm
	ODI_combine_top_bottom_eye  "horizontal" $chan $avmm $even_parm $bottom_parm $spec_parm $horiz_start_parm $horiz_stop_parm $horiz_inc_parm $vert_start_parm $vert_stop_parm $vert_inc_parm
	if $debug_reg_rw  { puts "$read_counter $write_counter" }
}
proc ODI_set_spec_bits { h1_sign spec chan avmm } {
	global ODI_dict_err
	# set h1_sign [dict get $ODI_dict_err ODI.native.$avmm.$chan.h1_sign]
	
	if {$spec == 0} {
       	rdmwrite 0x14d 0x01 0x00 $chan $avmm ; #3
		rdmwrite 0x144 0x04 0x00  $chan $avmm ;#2
        if {$h1_sign == 0} {
            rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
        } else {
            rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
        }
    }
    if {$spec == 1} {
       rdmwrite 0x14d 0x01 0x01 $chan $avmm ; #3
       rdmwrite 0x144 0x04 0x00  $chan $avmm ;#2
       if {$h1_sign == 0} {
          rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
       } else {
          rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
       }
    }
    if {$spec == 2} {
       rdmwrite 0x14d 0x01 0x00 $chan $avmm ; #3
       rdmwrite 0x144 0x04 0x04  $chan $avmm ;#2
       if {$h1_sign == 0} {
          rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
       } else {
          rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
       }
    }
    if {$spec == 3} {
       rdmwrite 0x14d 0x01 0x01 $chan $avmm ; #3
       rdmwrite 0x144 0x04 0x04  $chan $avmm ;#2
       if {$h1_sign == 0} {
          rdmwrite 0x156 0x02 0x02  $chan $avmm ;#5
       } else {
          rdmwrite 0x156 0x02 0x00  $chan $avmm ;#5
       }
    }
}
proc ODI_set_odd_even_bits { odd_even chan avmm } {
		if {$odd_even == 0} {
			rdmwrite  0x157 0x0c 0x04 $chan $avmm ;#1
		} else {
			rdmwrite  0x157 0x0c 0x08 $chan $avmm ;#1
		}
}
proc ODI_set_top_bottom_bits { bottom chan avmm } {	
	if {$bottom == 0} {
		rdmwrite  0x156 0x01 0x01 $chan $avmm ;#4
	} else {
		rdmwrite  0x156 0x01 0x00 $chan $avmm ;#4
	}
}
proc ODI_vertical_bits { bottom vert vert_stop_parm chan avmm } {	
	if {$bottom == 0} {
		set vert2 0x[format %X [expr $vert_stop_parm*4 - $vert * 4]]
	} else {
		set vert2  0x[format %X [expr $vert * 4]]
	}
	rdmwrite  0x143 0xfc $vert2  $chan $avmm ;#7
}
proc ODI_reset_odi_counter { chan avmm } {	
	if 1 {
		rdmwrite  0x168 0x04 0x00 $chan $avmm ;#9
		rdmwrite  0x168 0x04 0x04 $chan $avmm ;#9
		} else {
		set value_kk [read_reg 0x168 $chan $avmm]
		set value_kk [expr $value_kk & [expr 0xFF & ~0x04]]
		set value_kk1 [expr $value_kk | 0x0]
		write_reg 0x168 0x[format %X  $value_kk1] $chan $avmm
		set value_kk2 [expr $value_kk | 0x04]
		write_reg 0x168 0x[format %X  $value_kk2] $chan $avmm
		}
}
proc ODI_counter_stats { no_of_bit_to_set chan avmm phy dash } {	
	set ODI_count 0
	set pattern_count 0
	
	if { [expr $no_of_bit_to_set] <= [expr 1e9] } {
		set muliplier 1	
	} else {
		set muliplier [expr $no_of_bit_to_set/[expr 1e9]]
	}

	
	set odi_pattern_count 0
	set odi_error_count 0
	for {set muliplier_temp 1 } {$muliplier_temp <= $muliplier} { incr muliplier_temp } {
		
		ODI_reset_odi_counter $chan $avmm
		set is_done [ODI_check_done  $chan $avmm]
		set start_time [clock milliseconds]
		set interval 0	
		while { (!$is_done) && ($interval < 1000) } {
			set curr_time [clock milliseconds]
			set is_done [ODI_check_done  $chan $avmm]
			set interval [expr $curr_time - $start_time]
			if {$dash != 0 } {kill_loop $phy $dash }
			
		}
		if {$interval > 10000} {
			# error "ODI read time out"
		}
		
		# rdmwrite 0x149 0x3f 0x17 $chan $avmm ;	set pattern_count_a [read_reg 0x17e $chan $avmm]
		# rdmwrite 0x149 0x3f 0x16 $chan $avmm ;	set pattern_count_b [read_reg 0x17e $chan $avmm]
		# rdmwrite 0x149 0x3f 0x15 $chan $avmm ; 	set pattern_count_c [read_reg 0x17e $chan $avmm]
		# rdmwrite 0x149 0x3f 0x14 $chan $avmm ;  set pattern_count_d [read_reg 0x17e $chan $avmm]
		# set pattern_count_c 0x0; set pattern_count_d 0x0
		# set odi_pattern_count  [expr $odi_pattern_count + $pattern_count_a * 2**24 + $pattern_count_b * 2**16 + $pattern_count_c * 2**8 + $pattern_count_d]
		#write_reg 0x17E 0x0 $chan $avmm					
		set ODI_count_a 0
		set ODI_count_b 0
		set ODI_count_c 0
		set ODI_count_d 0
		
		
		set value_kk [read_reg 0x149 $chan $avmm]
		set value_kk [expr $value_kk & [expr 0xFF & ~0x3f]]
		set value_ODI_count_a [expr $value_kk | 0x1b]
		set value_ODI_count_b [expr $value_kk | 0x1a]
		set value_ODI_count_c [expr $value_kk | 0x19]
		set value_ODI_count_d [expr $value_kk | 0x18]
		write_reg 0x149 0x[format %X  $value_ODI_count_a] $chan $avmm
		set ODI_count_a [read_reg 0x17E $chan $avmm]
		
		# set fast_err 1
		if { 1 } {
			if {[expr $ODI_count_a] == 0} {
				#ODI_count_b
				# rdmwrite 0x149 0x3f 0x1a $chan $avmm 
				write_reg 0x149 0x[format %X  $value_ODI_count_b] $chan $avmm								
				set ODI_count_b [read_reg 0x17E $chan $avmm]
				if { [expr $ODI_count_b] ==0 } {
					#ODI_count_c
					# rdmwrite  0x149 0x3f 0x19 $chan $avmm
					write_reg 0x149 0x[format %X  $value_ODI_count_c] $chan $avmm	
					set ODI_count_c [read_reg 0x17E $chan $avmm]
					if { [expr $ODI_count_c] ==0 } {
						#ODI_count_d
						rdmwrite  0x149 0x3f 0x18 $chan $avmm
						write_reg 0x149 0x[format %X  $value_ODI_count_d] $chan $avmm
						set ODI_count_d [read_reg 0x17E $chan $avmm]
					}
				}
			}
		} 	
		set odi_error_count [expr $odi_error_count + $ODI_count_a * 2**24 + $ODI_count_b * 2**16 + $ODI_count_c * 2**8 + $ODI_count_d]
		
		if {$odi_error_count > 2 } { break }
	}
	# puts "$odi_pattern_count $odi_error_count $muliplier $muliplier_temp  [expr $pattern_count_a * 2**24 + $pattern_count_b * 2**16 + $pattern_count_c * 2**8 + $pattern_count_d] $is_done $interval"
	return  $odi_error_count
}
proc ODI_set_no_of_bits {no_of_bit_to_set chan avmm } {
	if { $no_of_bit_to_set == "1e6" } {
		# 0'b001
		rdmwrite 0x169 0x03 0x00 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x20 $chan $avmm  ;#E
	} elseif {	$no_of_bit_to_set == "1e7"} {
		# 0'b010
		rdmwrite 0x169 0x03 0x01 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x00 $chan $avmm  ;#E
	} elseif {	$no_of_bit_to_set == "1e8"} {
		# 0'b011
		rdmwrite 0x169 0x03 0x01 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x20 $chan $avmm  ;#E
	} elseif {	$no_of_bit_to_set == "3*1e8"} {
		# 0'b100
		rdmwrite 0x169 0x03 0x02 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x00 $chan $avmm  ;#E
	} elseif {	$no_of_bit_to_set == "1e9"} {
		# 0'b101
		rdmwrite 0x169 0x03 0x02 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x20 $chan $avmm  ;#E
	} elseif {	[expr $no_of_bit_to_set] > [expr 1e9] } {
		rdmwrite 0x169 0x03 0x02 $chan $avmm  ;#E
		rdmwrite 0x168 0x20 0x20 $chan $avmm  ;#E
	}
}
proc ODI_analyze_eye_initial_coordinates	{ chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm fast_err  {phy 0 } {dash 0} } {
	if {0} { puts [info level 0] }
	global  dash_xcvr_debug_kit  ODI_dict_err
	set   	ODI_dict_err ""
	set 	debug_reg_rw 0
	if 1 {
		# ODI_pma_init $chan $avmm
		ODI_init $chan $avmm
		set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
		#Horizontal intilization
		ODI_set_no_of_bits 1e6 $chan $avmm
		set even 0
		ODI_set_odd_even_bits $even $chan $avmm
		for {set spec 0} {$spec < $spec_parm } {incr spec } {
			ODI_set_spec_bits $h1_sign $spec $chan $avmm
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				ODI_set_top_bottom_bits $bottom $chan $avmm
				for {set vert 0  } {$vert <= 0 } {incr vert $vert_inc_parm} {
					ODI_vertical_bits $bottom $vert 0 $chan $avmm
					for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
						#######
						if {$dash != 0 } {kill_loop $phy $dash }				
						#######
						set ODI_count [ODI_counter_stats 1e6 $chan $avmm $phy $dash]
						if {$ODI_count ==1} {set ODI_count 0 }
						# puts [clock seconds]seconds
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err $ODI_count 
						# puts "$even.$spec.$bottom.$vert.$horiz $ODI_count" 
					}
				}
			}
		}
		
		ODI_combine_top_bottom_eye  "horizontal" $chan $avmm $even_parm $bottom_parm $spec_parm $horiz_start_parm $horiz_stop_parm $horiz_inc_parm 0 0 $vert_inc_parm
		ODI_find_eye_stat  1 $chan $avmm $even_parm $bottom_parm $spec_parm $horiz_start_parm $horiz_stop_parm $horiz_inc_parm 0 0 $vert_inc_parm
		set top_horizontal_width 	[expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.0.horiz_width]]
		set bottom_horizontal_width [expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.1.0.horiz_width]]			
					
		if { $top_horizontal_width > $bottom_horizontal_width } {
			set start_window_index 	[expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.0.start_window_index]]
			set stop_window_index 	[expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.0.stop_window_index]]
		} else {
			set start_window_index 	[expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.1.0.start_window_index]]
			set stop_window_index 	[expr $horiz_inc_parm * [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.1.0.stop_window_index]]
		}
		
		set total_horizontal_width  [expr {min($top_horizontal_width,$bottom_horizontal_width)} * 1 ] 
		
		if { [expr $start_window_index + ($total_horizontal_width/2) ] >= 128 } {
			set rollover [expr $start_window_index + ($total_horizontal_width/2)  - 128 ]
			puts "clock phase rollover = $rollover"
			set clock_phase_index $rollover
		} else {
			puts "clock phase = [expr $start_window_index + ($total_horizontal_width/2) ]"
			set clock_phase_index [expr $start_window_index + ($total_horizontal_width/2) ]
		}
		
		dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.total_horizontal_width.1e6 $total_horizontal_width
		dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.start_horiz_window_index.1e6 $start_window_index
		dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.stop_horiz_window_index.1e6 $stop_window_index
		dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.clock_phase_index.1e6 $clock_phase_index
	
	}
	# #####################################################################################################################################################
	#vertical intilization
	set horiz_start_parm $clock_phase_index
	set horiz_stop_parm $clock_phase_index	
	puts "clock_phase_index=$clock_phase_index"
	ODI_init $chan $avmm
	set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
	set even 0
		ODI_set_odd_even_bits $even $chan $avmm	
		for {set spec 0} {$spec < $spec_parm } {incr spec } {
			ODI_set_spec_bits $h1_sign $spec $chan $avmm
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				ODI_set_top_bottom_bits $bottom $chan $avmm
				for {set vert $vert_start_parm  } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					if {$bottom == 0} {
						set vert2 0x[format %X [expr $vert_stop_parm*4 - $vert * 4]]
					} else {
						set vert2  0x[format %X [expr $vert * 4]]

					}
					rdmwrite  0x143 0xfc $vert2  $chan $avmm ;#7
					for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						if {$dash != 0 } {kill_loop $phy $dash }				
						# if {[get_stop]} { break } 
						rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
						ODI_reset_odi_counter $chan $avmm
						set ODI_count [ODI_counter_stats 1e6 $chan $avmm $phy $dash]
						if {$ODI_count ==1} {set ODI_count 0 }
						# puts "$chan.$even.$spec.$bottom.$horiz.$vert=$ODI_count"
						# puts [clock seconds]seconds
						dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err $ODI_count 
					}
				}
			}
		}
	
		ODI_combine_top_bottom_eye  "vertical" $chan $avmm $even_parm $bottom_parm $spec_parm $clock_phase_index $clock_phase_index $horiz_inc_parm $vert_start_parm $vert_stop_parm  $vert_inc_parm
		ODI_find_eye_stat 0  $chan $avmm $even_parm $bottom_parm $spec_parm $clock_phase_index $clock_phase_index $horiz_inc_parm $vert_start_parm $vert_stop_parm $vert_inc_parm
		set top_vertical_height 	[expr $vert_inc_parm * [dict get $ODI_dict_err vertical.native.$avmm.$chan.0.0.$clock_phase_index.vert_width]]
		set bottom_vertical_height [expr $vert_inc_parm * [dict get $ODI_dict_err vertical.native.$avmm.$chan.0.1.$clock_phase_index.vert_width]]
		set total_vertical_height  [expr {min($top_vertical_height,$bottom_vertical_height)} * 2 ] 

		dict lappend ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.1e6 $total_vertical_height
		
		# puts "$start_window_index $stop_window_index  $total_horizontal_width $clock_phase_index $total_vertical_height " 	

}
proc ODI_analyze_eye_bathtub_coordinates	{ no_of_bits chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm fast_err   clock_phase_index {phy 0 } {dash 0} } {
	if {0} { puts [info level 0] }
	global  dash_xcvr_debug_kit  ODI_dict_err
	set   	ODI_dict_err ""
	set 	debug_reg_rw 0
	puts "$horiz_start_parm  $horiz_stop_parm"

	
	# #####################################################################################################################################################
	#Horizontal intilization
	# ODI_pma_init $chan $avmm
	ODI_init $chan $avmm
	set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
	set start_window_index 0 
	set stop_window_index 0
	set spec_err 0	
	#left side 1111000
	ODI_set_no_of_bits $no_of_bits $chan $avmm
	#Even odd
	set even 0
	ODI_set_odd_even_bits $even $chan $avmm
	for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
		ODI_set_top_bottom_bits $bottom $chan $avmm
		for {set vert 0  } {$vert <= 0 } {incr vert $vert_inc_parm} {
			ODI_vertical_bits $bottom $vert 0 $chan $avmm
			#horiz
			if { $horiz_start_parm >  $horiz_stop_parm } {
				set horiz_start_parm_temp $horiz_start_parm
				set horiz_stop_parm_temp 128
			} else {
				set horiz_start_parm_temp 0
				set horiz_stop_parm_temp $horiz_start_parm
			}
			for { set horiz $horiz_start_parm_temp } { $horiz <=  $horiz_stop_parm_temp } { incr horiz $horiz_inc_parm } {
				# puts "1 $horiz_start_parm_temp  $horiz_stop_parm_temp $horiz"
				rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
				set spec_err 0
				for {set spec 0} {$spec < $spec_parm } {incr spec } {
					ODI_set_spec_bits $h1_sign $spec $chan $avmm
					if {$dash != 0 } {kill_loop $phy $dash }				
					#######
					ODI_reset_odi_counter $chan $avmm
					set ODI_count [ODI_counter_stats $no_of_bits $chan $avmm  $phy $dash ]
					if {$ODI_count ==1} {set ODI_count 0 }
					# puts [clock seconds]seconds
					set spec_err [expr $spec_err + $ODI_count]						
				}
				# puts "left chan$chan.$even.$bottom.$vert.$horiz $spec_err" 
				if {$spec_err==0 }  { break } 
			}
			if {$spec_err==0 }  { break } 
		}
	if {$spec_err==0 }  { break } 
	}
	set start_window_index $horiz
	
	##right side 0000111
	#Even odd
	set even 0
	set spec_err 0
	ODI_set_odd_even_bits $even $chan $avmm
	for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
		ODI_set_top_bottom_bits $bottom $chan $avmm
		for {set vert 0  } {$vert <= 0 } {incr vert $vert_inc_parm} {
			ODI_vertical_bits $bottom $vert 0 $chan $avmm
			#horiz
			if { $horiz_start_parm >  $horiz_stop_parm } {
				set horiz_start_parm_temp 0
				set horiz_stop_parm_temp $horiz_stop_parm
			} else {
				set horiz_start_parm_temp $horiz_start_parm
				set horiz_stop_parm_temp 128
			}
			for { set horiz [expr $horiz_stop_parm_temp ] } { $horiz >=  $horiz_start_parm_temp } { incr horiz -[expr $horiz_inc_parm] } {
				# puts "2 $horiz_start_parm_temp  $horiz_stop_parm_temp $horiz"
				rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6
				set spec_err 0
				for {set spec 0} {$spec < $spec_parm } {incr spec } {
					ODI_set_spec_bits $h1_sign $spec $chan $avmm
					if {$dash != 0 } {kill_loop $phy $dash }				
					#######
					ODI_reset_odi_counter $chan $avmm
					set ODI_count [ODI_counter_stats $no_of_bits $chan $avmm  $phy $dash ]
					if {$ODI_count ==1} {set ODI_count 0 }
					# puts [clock seconds]seconds
					set spec_err [expr $spec_err + $ODI_count]						
				}
				# puts "right chan$chan.$even.$bottom.$vert.$horiz $spec_err"
				if {$spec_err==0 }  { break } 
			}
			if {$spec_err==0 }  { break } 
		}
	if {$spec_err==0 }  { break } 
	}
	set stop_window_index $horiz
	
	if { $horiz_start_parm <  $horiz_stop_parm } {
		set total_horizontal_width [expr ($stop_window_index-$start_window_index)]
	} else {
		set total_horizontal_width [ expr (128 - $start_window_index) + $stop_window_index]
	}
	dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.total_horizontal_width.$no_of_bits $total_horizontal_width
	dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.start_horiz_window_index.$no_of_bits $start_window_index
	dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.stop_horiz_window_index.$no_of_bits $stop_window_index

	# set clock_phase_index [expr ($stop_window_index-$start_window_index)/2 + $start_window_index]
	# set clock_phase_index [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.clock_phase_index.1e6]
	dict lappend ODI_dict_err horizontal.native.$avmm.$chan.0.0.clock_phase_index.$no_of_bits $clock_phase_index
	puts "$chan $stop_window_index $start_window_index $clock_phase_index"
	
	
	# #####################################################################################################################################################
	#vertical intilization
		
	#vertical intilization
	# set vert_start_parm   0
	# set vert_stop_parm  32
	set spec_err 0
	set horiz_start_parm $clock_phase_index
	set horiz_stop_parm $clock_phase_index	
	ODI_init $chan $avmm
	set h1_sign [bin2dec [string range [format %08s [dec2bin [expr [read_reg 0x17f  $chan $avmm; ]]]] 1 1]]
	set even 0
	ODI_set_odd_even_bits $even $chan $avmm	
	for {set bottom 0 } {$bottom <= 0 } {incr bottom} {
		
		ODI_set_top_bottom_bits $bottom $chan $avmm
		for {set vert [expr $vert_stop_parm ]  } {$vert >= 0 } {incr vert [expr -1 * $vert_inc_parm] } {
			if {$bottom == 0} {
				set vert2 0x[format %X [expr $vert_stop_parm*4 - $vert * 4]]
			} else {
				set vert2  0x[format %X [expr $vert * 4]]
			}
			rdmwrite  0x143 0xfc $vert2  $chan $avmm ;#7
			for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
				rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6	
				set spec_err 0					
				for {set spec 0} {$spec < $spec_parm } {incr spec } {
					ODI_set_spec_bits $h1_sign $spec $chan $avmm
					if {$dash != 0 } {kill_loop $phy $dash }				
					# if {[get_stop]} { break } 
			
					ODI_reset_odi_counter $chan $avmm
					set ODI_count [ODI_counter_stats $no_of_bits $chan $avmm  $phy $dash ]
					if {$ODI_count ==1} {set ODI_count 0 }
					# puts "$chan.$even.$spec.$bottom.$horiz.$vert=$ODI_count"
					# puts [clock seconds]seconds
					# dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err $ODI_count 
					set spec_err [expr $spec_err + $ODI_count]	
				}
				 # puts "bottom $bottom.$vert $spec_err"
				if {$spec_err==0 }  { break } 
			}
			if {$spec_err==0 }  { break } 
		}
		if {$spec_err==0 }  { break } 
	}
	set bottom_vertical_height $vert
	set spec_err 0
	for {set bottom 1 } {$bottom <= 1 } {incr bottom} {
		ODI_set_top_bottom_bits $bottom $chan $avmm
		for {set vert [expr $vert_stop_parm ]  } {$vert >= 0 } {incr vert [expr -1 * $vert_inc_parm] } {
			if {$bottom == 0} {
				set vert2 0x[format %X [expr $vert_stop_parm*4 - $vert * 4]]
			} else {
				set vert2  0x[format %X [expr $vert * 4]]
			}
			rdmwrite  0x143 0xfc $vert2  $chan $avmm ;#7
			for { set horiz $horiz_start_parm } { $horiz <=  $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
				rdmwrite  0x145 0x7F [ODI_pi_encoder $horiz] $chan $avmm; #6	
				set spec_err 0					
				for {set spec 0} {$spec < $spec_parm } {incr spec } {
					ODI_set_spec_bits $h1_sign $spec $chan $avmm
					if {$dash != 0 } {kill_loop $phy $dash }				
					# if {[get_stop]} { break } 
			
					ODI_reset_odi_counter $chan $avmm
					set ODI_count [ODI_counter_stats $no_of_bits $chan $avmm  $phy $dash ]
					if {$ODI_count ==1} {set ODI_count 0 }
					set spec_err [expr $spec_err + $ODI_count]	
				}
				# puts "top $bottom.$vert $spec_err"
				if {$spec_err==0 }  { break } 
			}
			if {$spec_err==0 }  { break } 
		}
		if {$spec_err==0 }  { break } 
	}
	set top_vertical_height $vert
	set total_vertical_height  [expr {min($top_vertical_height,$bottom_vertical_height)} * 2 ] 
	dict lappend ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.$no_of_bits $total_vertical_height
	
	# puts "$no_of_bits start_window_index=$start_window_index stop_window_index=$stop_window_index  total_horizontal_width=$total_horizontal_width total_vertical_height=$total_vertical_height " 	
	
}
proc ODI_combine_top_bottom_eye { horizontal chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm} {
if {0} { puts [info level 0] }	
	global ODI_dict_err
	
	#raw addition
	for { set even 0 } { $even <= $even_parm} { incr even } {
		for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
			for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
				for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
					set spec_err 0
					for { set spec 0 } { $spec < $spec_parm } { incr spec  } {
						set spec_err [expr $spec_err + [dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$spec.$bottom.$vert.$horiz.err]]
					}
					# puts "$spec_err chan$chan.$even.$bottom.$vert.$horiz" 
					dict lappend ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err $spec_err					
				}
			}
		}
	}
	
	#to remove the spordiac error
	for { set even 0 } { $even <= $even_parm} { incr even } {
		for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
			for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
				for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
					if { $vert > 0 && $vert < [expr $vert_stop_parm - $vert_inc_parm] } {
						set prev_error [dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.[expr $vert - $vert_inc_parm].$horiz.combo_err]
						set curr_error [dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err]
						set future_error [dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.[expr $vert + $vert_inc_parm].$horiz.combo_err]
						if  { $prev_error == 0 && $future_error == 0 && $curr_error > 0 } {
							# puts "$chan,$even,$bottom,$vert,$horiz, prev_error=$prev_error,curr_error=$curr_error,future_error=$future_error"
							set ODI_dict_err [dict replace $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err 0]
						}
					}
				}
			}
		}
	}
}
proc ODI_find_eye_stat_old { horizontal chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm} {	
	if {0} { puts [info level 0] }	
	global ODI_dict_err
	#horizontal width
	if $horizontal {
		for { set even 0 } { $even <= $even_parm} { incr even } {
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					set window ""
					for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						# puts -nonewline "[dict get $ODI_dict_err native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err],"
						if { [dict get $ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err] > 0 } {
							set window ${window}1 	
						} else {
							set window ${window}0 
						}
					}
					if { [expr $horiz_start_parm ]  != $horiz_stop_parm } {
						puts $window
					}
					set search_val "" 
					set search_index -1 
					set len 0
					for { set search_loop 1 } { $search_loop <= 128 } { incr search_loop } {
						set search_val ${search_val}0
						if {[ string first $search_val $window] > -1} {
							set search_index [ string first $search_val $window]
							set len $search_loop
						}
					}
					
					# puts "search_index=$search_index , len= $len"
					
					dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width $len 
					dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width_window $window 
					set start_window_index 0
					for { set search_loop 0 } { $search_loop < 128 } { incr search_loop } {
						set current_val [string range $window $search_loop $search_loop]
						set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
						if {$current_val == 1 && $next_val==0 } {
							set start_window_index $search_loop
						}	
					}
					set stop_window_index 0
					for { set search_loop $search_index } { $search_loop < 128 } { incr search_loop } {
						set current_val [string range $window $search_loop $search_loop]
						set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
						if {$current_val == 0 && $next_val==1 } {
							set stop_window_index $search_loop
						}	
					}
					dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.start_window_index $start_window_index 
					dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.stop_window_index $stop_window_index 
				
				
				}
				
			}
		}
	} else {
	#vertical
		for { set even 0 } { $even <= $even_parm} { incr even } {
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
					set window ""
					set no_of_1s 0
					for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {	
						# puts -nonewline "[dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err],"
						if { [dict get $ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err] > 0 } {
							set window ${window}1 
							incr 1s
						} else {
							set window ${window}0 
						}
					}
					# puts $window
					set search_val "" 
					set search_index -1 
					set len 0
					for { set search_loop 1 } { $search_loop <= 128 } { incr search_loop } {
						set search_val ${search_val}0
						if {[ string first $search_val $window] > -1} {
							set search_index [ string first $search_val $window]
							set len $search_loop						
						}
					}
					dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$horiz.vert_width $len 
					dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$horiz.vert_width_window $search_index 
				}
			}
		}
		# puts ""
		return 
	}
}
proc ODI_find_eye_stat { horizontal chan avmm even_parm bottom_parm spec_parm horiz_start_parm horiz_stop_parm horiz_inc_parm vert_start_parm vert_stop_parm vert_inc_parm} {	
	if {0} { puts [info level 0] }	
	global ODI_dict_err
	#horizontal width
	if $horizontal {
		for { set even 0 } { $even <= $even_parm} { incr even } {
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {
					set window ""
					for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
						# puts -nonewline "[dict get $ODI_dict_err native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err],"
						if { [dict get $ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err] > 0 } {
							set window ${window}1 	
						} else {
							set window ${window}0 
						}
					}
					if { [expr $horiz_start_parm ]  != $horiz_stop_parm } {
						puts $window
					}
					
					
					if {  ([string range $window 0 0]  == 0)  && ( [string range $window [expr [string length $window] -1] [string length $window]] == 0)} {
						set first_zero_index 0
						for { set search_loop 0 } { $search_loop < 128 } { incr search_loop } {
							set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
							if { $next_val==1 } { set first_one_index $search_loop ; break ;}	
						}
						
						for { set search_loop $first_one_index } { $search_loop < 128 } { incr search_loop } {
							set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
							if { $next_val==0 } { set second_zero_index $search_loop ;break ;}	
						}
						
						set first_zero_width [expr $first_one_index + 1]
						set second_zero_width [expr [string length $window] -  $second_zero_index + 1]
						
						set start_window_index $second_zero_index
						set stop_window_index $first_one_index
						
						puts [string length $window] 
						set totalWidth [expr  ([string length $window] - $start_window_index) + $stop_window_index]
						
						## ########
						puts "$chan start_window_index = $start_window_index stop_window_index  = $stop_window_index totalWidth= $totalWidth"
		
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.start_window_index $start_window_index 
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.stop_window_index $stop_window_index 
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width $totalWidth 
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width_window $window 
						
					} else {
		
						set search_val "" 
						set search_index -1 
						set len 0
						for { set search_loop 1 } { $search_loop <= 128 } { incr search_loop } {
							set search_val ${search_val}0
							if {[ string first $search_val $window] > -1} {
								set search_index [ string first $search_val $window]
								set len $search_loop
							}
						}
						
						# puts "search_index=$search_index , len= $len"
						
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width $len 
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.horiz_width_window $window 
						set start_window_index 0
						for { set search_loop 0 } { $search_loop < 128 } { incr search_loop } {
							set current_val [string range $window $search_loop $search_loop]
							set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
							if {$current_val == 1 && $next_val==0 } {
								set start_window_index $search_loop
							}	
						}
						set stop_window_index 0
						for { set search_loop $search_index } { $search_loop < 128 } { incr search_loop } {
							set current_val [string range $window $search_loop $search_loop]
							set next_val [string range $window [expr $search_loop+1] [expr $search_loop+1]]
							if {$current_val == 0 && $next_val==1 } {
								set stop_window_index $search_loop
							}	
						}
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.start_window_index $start_window_index 
						dict lappend ODI_dict_err horizontal.native.$avmm.$chan.$even.$bottom.$vert.stop_window_index $stop_window_index 
				
					}
				}
				
			}
		}
	} else {
	#vertical
		for { set even 0 } { $even <= $even_parm} { incr even } {
			for {set bottom 0 } {$bottom <= $bottom_parm } {incr bottom} {
				for { set horiz $horiz_start_parm } { $horiz <= $horiz_stop_parm } { incr horiz $horiz_inc_parm } {
					set window ""
					set no_of_1s 0
					for {set vert $vert_start_parm } {$vert <= $vert_stop_parm } {incr vert $vert_inc_parm} {	
						# puts -nonewline "[dict get $ODI_dict_err $horizontal.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err],"
						if { [dict get $ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$vert.$horiz.combo_err] > 0 } {
							set window ${window}1 
							incr 1s
						} else {
							set window ${window}0 
						}
					}
					# puts $window
					set search_val "" 
					set search_index -1 
					set len 0
					for { set search_loop 1 } { $search_loop <= 128 } { incr search_loop } {
						set search_val ${search_val}0
						if {[ string first $search_val $window] > -1} {
							set search_index [ string first $search_val $window]
							set len $search_loop						
						}
					}
					dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$horiz.vert_width $len 
					dict lappend ODI_dict_err vertical.native.$avmm.$chan.$even.$bottom.$horiz.vert_width_window $search_index 
				}
			}
		}
		# puts ""
		return 
	}
}

proc ODIkit_init { } {
	
	global dash_xcvr_debug_kit 
	
	set ODIkit_native_nos ""
	set k 0
	
	foreach temp [get_service_paths slave] {
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {	
		
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
			
			if { ($condition1 && $condition2 )} { 
				lappend native_nos $k 
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				dict lappend dash_xcvr_debug_kit ODI.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit ODI.native.$k.cable_info $cable_info
				
				
			}
		}
		incr k
	}

	dict lappend dash_xcvr_debug_kit ODI.native.no_of_phy [llength $ODIkit_native_nos]
	dict lappend dash_xcvr_debug_kit ODI.info_bar channel chan_en srlpbk Horiz_step Vert_step PRBS Eye_W/H_1e6 Eye_W/H_1e7 Eye_W/H_1e8 Eye_W/H_1e9 Eye_W/H_1e10 Eye_W/H_1e11 Eye_W/H_1e12 Status VOD Post Pre acgain dcgain VGA DFE Test_Time
	
	dict lappend dash_xcvr_debug_kit ODI.ber 1e7 1e8 1e9 1e10 1e11 1e12
	foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
		dict lappend dash_xcvr_debug_kit ODI.native.$phy.avmm [lindex [get_service_paths slave ] [lindex $ODIkit_native_nos $phy]]
		set avmm [lindex [get_service_paths slave ] $phy]
		dict lappend dash_xcvr_debug_kit ODI.native.$phy.no_of_chan [expr [ read_reg 0x410 0 "$avmm"]]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan] } {incr chan } {
			foreach info [dict get $dash_xcvr_debug_kit ODI.info_bar]  {
				dict lappend dash_xcvr_debug_kit ODI.native.$phy.$chan.$info $chan
			}
		}
	}
	
	foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
		set avmm [lindex [get_service_paths slave ] $phy]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan] } {incr chan } {
			foreach info [dict get $dash_xcvr_debug_kit ODI.info_bar]  {
				dict lappend dash_xcvr_debug_kit ODI.native.$phy.$chan.$info $chan
				set dash_xcvr_debug_kit [dict replace $dash_xcvr_debug_kit ODI.native.$phy.$chan.Channel $chan]
				dict lappend dash_xcvr_debug_kit ODI.native.$phy.$chan.vertical_led_value 0
				dict lappend dash_xcvr_debug_kit ODI.native.$phy.$chan.Horizontal_led_value 0
			}
		}
	}
	
	# dict lappend dash_xcvr_debug_kit ODI.native.ODI_Measure_once.text.true 					{Eye Measure Once All PHY instance}
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_once.text.true "Measure Eye Once - All PHY"
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_once.text.false 				{Updating All PHY instance}
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.text.true 			{continuous Measure Eye Disabled/check to Enable}
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.text.false 			{continuous Measure Eye Enable/check to Disabled}
	dict set dash_xcvr_debug_kit ODI.native.ODI_log_continuous.text.true 				{continuous update LogFile Disabled/check to Enable}
	dict set dash_xcvr_debug_kit ODI.native.ODI_log_continuous.text.false 				{Updating LogFile Enable/check to Disabled}
	
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_once.foregroundColor.true  		blue
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_once.foregroundColor.false  	red
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.foregroundColor.true 	blue
	dict set dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.foregroundColor.false red
	dict set dash_xcvr_debug_kit ODI.native.ODI_log_continuous.foregroundColor.true 		blue
	dict set dash_xcvr_debug_kit ODI.native.ODI_log_continuous.foregroundColor.false 	red


	dict set dash_xcvr_debug_kit ODI.native.no_bit_to_test 	"10pow6 10pow7 10pow8 30pow8 10pow9"
	
	foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
	
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_once.text.true 				{Measure Eye Once}
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_once.text.false 				{Updating}
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_continuous.text.true 			{continuous Measure Eye Disabled/check to Enable}
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_continuous.text.false 			{continuous Measure Eye Enable/check to Disabled}
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_log_continuous.text.true 				{continuous update LogFile Disabled/check to Enable}
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_log_continuous.text.false 				{Updating LogFile Enable/check to Disabled}
		
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_once.foregroundColor.true  	blue
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_once.foregroundColor.false  	red
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_continuous.foregroundColor.true blue
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_Measure_continuous.foregroundColor.false red
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_log_continuous.foregroundColor.true 	blue
		dict set dash_xcvr_debug_kit ODI.native.$phy.ODI_log_continuous.foregroundColor.false 	red
		
	}  
	if { ![file isdirectory log] } {file mkdir log} 
	set filename "log/Eye_measurement_[clock format [clock seconds] -format  %jjulian_%Hhr_%Mmin_%Ssec]_[info hostname].csv"
	dict lappend dash_xcvr_debug_kit ODI.log_data_filename $filename
	set data_log_file [open "$filename" "w"]
	puts $data_log_file  "Timestamp,phy_name,Channel,BER,Eye_W/H,VOD,Post,Pre,ACGain,DCGain,VGA,DFE1,DFE2,DFE3,DFE4,DFE5,DFE6,DFE7,DFE8,DFE9,DFE10,DFE11,DFE12,DFE13,DFE14,DFE15,testime"
	close $data_log_file
	
}
proc ODIkit_gui_tab {  } {
	
	global dash_xcvr_debug_kit version
	set dash [add_service dashboard S10_Ltile_Htile_Transceiver_EYE_Debug_Tool_v${version} "S10_Ltile_Htile_Transceiver_EYE_Debug_Tool_v${version}" "Tools/S10_Ltile_Htile_Transceiver_EYE_Debug_Tool_v${version}"]
	dict lappend dash_xcvr_debug_kit eye.GUI_dash $dash
	# dashboard_set_property $dash self visible true
		
	set native_nos 0
	foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
		incr native_nos
	}
	
	set no_of_line 0
	widget_group $dash Transceiver_Eye_top self 1 ""
	
		widget_group $dash Transceiver_eye_top_comment Transceiver_Eye_top 1 "Comments"
			widget_label $dash my_label1 Transceiver_eye_top_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
			widget_label $dash my_label1 Transceiver_eye_top_comment   "Tool_v${version} based on Q17.1.2" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "To use this Tool ADME should be Enabled" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "This Tool measure the Eye Height and Width at the CDR Sampling Point" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "Change the Vertical and Horozontal sweep step size to decrease the measurement time" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "Increasing the Step size will decrease the accuracy" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "For PRBS7 PRBS9 PRBS15 PRBS23 PRBS31 patterns -> Run the eye measurement function after setting the PRBS pattern in TTK" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
			widget_label $dash my_label1 Transceiver_eye_top_comment   "LogFile in the following Location --> [dict get $dash_xcvr_debug_kit ODI.log_data_filename]" blue
			widget_label $dash my_label1 Transceiver_eye_top_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
		widget_group $dash 		Transceiver_eye1 Transceiver_Eye_top 3 "Measurement Type"
			widget_button $dash 	ODI_Measure_once Transceiver_eye1 [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_once.text.true] "ODI_Measure_once_all" 
			widget_checkBox $dash 	ODI_Measure_continuous Transceiver_eye1 [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.text.true] ODI_Measure_continuous_all  
			widget_checkBox $dash 	kill_loop_all Transceiver_eye1 "Stop the current measurement" "kill_loop all $dash" false red
		
		######## very important
		set itemsPerRow 22
		######## very important
			
		widget_group $dash Transceiver_eye_phy_ch Transceiver_Eye_top 1 "Phy instance + Channel"
		
		foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
			set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
			set cable_name [dict get $dash_xcvr_debug_kit ODI.native.$phy.cable_info]
			widget_group $dash Transceiver_eye_phy_ch_measure_$phy Transceiver_eye_phy_ch 3  "${cable_name}${phy_name}" [expr ([string length $cable_name] +[string length $phy_name]) * 6 ]
				#Row1
				widget_button $dash 	${phy}_ODI_Measure_once 		Transceiver_eye_phy_ch_measure_$phy "Measure Eye Once" "ODI_Measure_once $phy"
				widget_checkBox $dash 	${phy}_ODI_Measure_continuous 	Transceiver_eye_phy_ch_measure_$phy "continuous update Disabled/check to Enable"  "ODI_Measure_continuous $phy" false
				widget_checkBox $dash 	kill_loop_$phy 					Transceiver_eye_phy_ch_measure_$phy "Stop the current measurement" "kill_loop $phy $dash" false red
			
			widget_group $dash Transceiver_eye_phy_ch_$phy Transceiver_eye_phy_ch $itemsPerRow $phy_name			

			if { [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan] > 1  } {
				widget_label 	$dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "" black
				widget_comboBox $dash ODI_eye_measurement_channel_enable_allchannel_comboBox_$phy 		Transceiver_eye_phy_ch_$phy "enable disable" "enable"
				widget_label $dash comment_$phy Transceiver_eye_phy_ch_$phy " " black
				
				widget_comboBox $dash ODI_eye_measurement_Horizontal_enable_allchannel_comboBox_$phy 	Transceiver_eye_phy_ch_$phy "1 2 4" "2"
				widget_comboBox $dash ODI_eye_measurement_Vertical_enable_allchannel_comboBox_$phy 	Transceiver_eye_phy_ch_$phy "1 2 4" "2"
				# widget_comboBox $dash ODI_prbs_allchannel_comboBox_$phy								Transceiver_eye_phy_ch_$phy "PRBS7 PRBS9 PRBS15 PRBS23 PRBS31 User_Traffic" "User_Traffic"
				widget_comboBox $dash ODI_prbs_allchannel_comboBox_$phy								Transceiver_eye_phy_ch_$phy "User_Traffic" "User_Traffic"
				
				widget_checkBox $dash eye_no_of_bits_1e6_$phy Transceiver_eye_phy_ch_$phy "1e6" " " true blue
				dashboard_set_property $dash eye_no_of_bits_1e6_$phy enabled false
				foreach no_of_bit [dict get $dash_xcvr_debug_kit ODI.ber]  {
					widget_checkBox $dash eye_no_of_bits_${no_of_bit}_$phy Transceiver_eye_phy_ch_$phy $no_of_bit " " false red
				}
				
				widget_button 	$dash ODI_apply_change_button_$phy Transceiver_eye_phy_ch_$phy "apply" "ODI_apply_change $phy"
				for {set item 15 } { $item <= $itemsPerRow   } { incr item } {			
						widget_label $dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "" black
					}
			} else {
			
				for {set item 1 } { $item <= 6   } { incr item } {			
					widget_label $dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "" black
				}
				widget_checkBox $dash eye_no_of_bits_1e6_$phy Transceiver_eye_phy_ch_$phy "1e6" " " true blue
				dashboard_set_property $dash eye_no_of_bits_1e6_$phy enabled false
				foreach no_of_bit [dict get $dash_xcvr_debug_kit ODI.ber]  {
					widget_checkBox $dash eye_no_of_bits_${no_of_bit}_$phy Transceiver_eye_phy_ch_$phy $no_of_bit " " false red
				}
				widget_button 	$dash ODI_apply_change_button_$phy Transceiver_eye_phy_ch_$phy "apply" "ODI_apply_change $phy"
				for {set item 15 } { $item <= $itemsPerRow   } { incr item } {			
					widget_label $dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "" black
				}
			}
			
			#row 3
				foreach debug [dict get $dash_xcvr_debug_kit ODI.info_bar]  {	
					widget_label $dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "$debug " black
				}
				
				for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan]  } {incr chan } {			
					set avmm 			[lindex [get_service_paths slave ] $phy]
					widget_label $dash ODI_my_label_1 Transceiver_eye_phy_ch_$phy  "Chan$chan" black
					widget_comboBox $dash ODI.native.$phy.$chan.channel_en Transceiver_eye_phy_ch_$phy "enable disable" "enable" blue
					widget_label   $dash ODI.native.$phy.$chan.srlbk   Transceiver_eye_phy_ch_$phy  "--"  
					
					widget_comboBox $dash ODI.native.$phy.$chan.Horizontal_en Transceiver_eye_phy_ch_$phy "1 2 4" "2"
					widget_comboBox $dash ODI.native.$phy.$chan.Vertical_en Transceiver_eye_phy_ch_$phy "1 2 4" "2"
					
					# widget_comboBox $dash ODI.native.$phy.$chan.prbs Transceiver_eye_phy_ch_$phy "PRBS7 PRBS9 PRBS15 PRBS23 PRBS31 User_Traffic" [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.PRBS_selected]
					widget_comboBox $dash ODI.native.$phy.$chan.prbs Transceiver_eye_phy_ch_$phy "User_Traffic" [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.PRBS_selected]
					
					widget_label $dash ODI.native.$phy.$chan.eye_stats_value_1e6 Transceiver_eye_phy_ch_$phy "--" black 
					foreach no_of_bit [dict get $dash_xcvr_debug_kit ODI.ber] {
						widget_label $dash ODI.native.$phy.$chan.eye_stats_value_${no_of_bit} Transceiver_eye_phy_ch_$phy "--" black 
					}
					widget_label $dash ODI.native.$phy.$chan.status Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.VOD Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.post Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.pre Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.acgain Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.dcgain Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.VGA Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.DFE Transceiver_eye_phy_ch_$phy "--" black 
					widget_label $dash ODI.native.$phy.$chan.test_time Transceiver_eye_phy_ch_$phy "--" black 
				}	
			}
		}	
proc ODI_apply_change { phy } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]

	for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan]  } {incr chan } {	
		set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
		set avmm 			[lindex [get_service_paths slave ] $phy]

		set channel_en [ string tolower [dashboard_get_property $dash ODI_eye_measurement_channel_enable_allchannel_comboBox_$phy selectedItem]]
		dashboard_set_property $dash  ODI.native.$phy.$chan.channel_en selectedItem $channel_en
		set Vertical_en [ string tolower [dashboard_get_property $dash ODI_eye_measurement_Vertical_enable_allchannel_comboBox_$phy selectedItem]]
		dashboard_set_property $dash  ODI.native.$phy.$chan.Vertical_en selectedItem $Vertical_en
		set Horizontal_en [ string tolower [dashboard_get_property $dash ODI_eye_measurement_Horizontal_enable_allchannel_comboBox_$phy selectedItem]]
		dashboard_set_property $dash  ODI.native.$phy.$chan.Horizontal_en selectedItem $Horizontal_en
		set prbs [dashboard_get_property $dash ODI_prbs_allchannel_comboBox_$phy selectedItem]
		dashboard_set_property $dash  ODI.native.$phy.$chan.prbs selectedItem $prbs
		
		if {$prbs != "User_Traffic"}  {
			# pma_init $chan $avmm
			# adapt_initial_value 8 32 16 $chan $avmm
			# hard_prbs_stop $chan $avmm
			# htile_hard_prbs_pattern_gen $chan $prbs $avmm
			# htile_hard_prbs_pattern_chk $chan $prbs $avmm
			# hard_prbs_start $chan $avmm
			# adapt_reset $chan $avmm
			# hard_prbs_reset $chan $avmm
			# hard_prbs_reset $chan $avmm
			# hard_prbs_reset $chan $avmm
		} else {				
			# write_reg 0x6 [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x6] $chan $avmm;
			# write_reg 0x7 [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x7] $chan $avmm;
			# write_reg 0x8 [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x8] $chan $avmm;
			# write_reg 0x110 [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x110] $chan $avmm;
			
			# write_reg 0xa [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xa] $chan $avmm;
			# write_reg 0xb [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xb] $chan $avmm;
			# write_reg 0xc [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xc] $chan $avmm;
			# write_reg 0x13f [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x13f] $chan $avmm;
		}
		
	}
}
proc ODIkitkit_update_all_info { } {
	global dash_xcvr_debug_kit 
	foreach phy [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
		ODIkitkit_update_info $phy
	}
}
#main proc
proc ODIkitkit_update_info { phy } {
	global dash_xcvr_debug_kit ODI_dict_err
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	set temp_dict_no_of_bit ""
	
	set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
	set avmm 			[lindex [get_service_paths slave ] $phy]
	foreach no_of_bit [dict get $dash_xcvr_debug_kit ODI.ber] {
		dict lappend temp_dict_no_of_bit eye_no_of_bits_${no_of_bit} [dashboard_get_property $dash eye_no_of_bits_${no_of_bit}_$phy checked] 
	}
	
	

	for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit ODI.native.$phy.no_of_chan] } {incr chan } {
		bkgrnd_cal_disable $chan $avmm
		# puts "Eye measurement $avmm= Chan$chan"
		set systemTime [clock seconds] 
		# puts "native.$phy.$chan"
		# puts "phy_in=$phy chan=$chan "	
		
		set channel_en 		[ string tolower [dashboard_get_property $dash ODI.native.$phy.$chan.channel_en selectedItem]]
		set Vertical_en 	[ string tolower [dashboard_get_property $dash ODI.native.$phy.$chan.Vertical_en selectedItem]]
		set Horizontal_en 	[ string tolower [dashboard_get_property $dash ODI.native.$phy.$chan.Horizontal_en selectedItem]]
		set prbs 			[dashboard_get_property $dash ODI.native.$phy.$chan.prbs selectedItem]
		
		
		if { $channel_en == "enable" } {
		
			dashboard_set_property $dash ODI.native.$phy.$chan.status 			text	"Running"
			dashboard_set_property $dash ODI.native.$phy.$chan.status 			foregroundColor	blue
			dashboard_set_property $dash ODI.native.$phy.$chan.test_time 		text	"--"
			dashboard_set_property $dash ODI.native.$phy.$chan.channel_en foregroundColor	blue
			
			#serial loopback
			if [string range [format %08s [format %llb  [expr [ read_reg 0x4E1 $chan "$avmm"]]]] 7 7] {
				dashboard_set_property $dash ODI.native.$phy.$chan.srlbk text 1
				dashboard_set_property $dash ODI.native.$phy.$chan.srlbk foregroundColor green
			} else {
				dashboard_set_property $dash ODI.native.$phy.$chan.srlbk text 0
				dashboard_set_property $dash ODI.native.$phy.$chan.srlbk foregroundColor red
			}
			
		
			if [ch_rx_is_lockedtodata $chan $avmm] {
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			text	"Measuring 1e6"
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			foregroundColor	blue
				
				set adapt_val [adapt_reverse_engineer $chan $avmm]
				if { ($adapt_val == "manual") || ($adapt_val == "ctle_adaptive_no_dfe") } {	set spec 1  }  else  {  set spec 4 } 
				
				ODI_analyze_eye_initial_coordinates $chan $avmm 0 1 $spec 0 128 $Horizontal_en 0 50 $Vertical_en 1 $phy $dash 
				set clock_phase_index [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.clock_phase_index.1e6]
				set eye_stats_value "[dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.total_horizontal_width.1e6]/[dict get $ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.1e6]"
				dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_1e6 text $eye_stats_value
				dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_1e6 foregroundColor	blue
			
		
				set start_horiz_window_index  [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.start_horiz_window_index.1e6]
				set stop_horiz_window_index  [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.stop_horiz_window_index.1e6]
				set vert_window_index  [expr [dict get $ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.1e6]/2]
				set filename  [dict get $dash_xcvr_debug_kit ODI.log_data_filename]
				set data_log_file [open "$filename" "a+"]
				set afe_adapt_val [get_adapt_afe $chan $avmm]
				puts -nonewline $data_log_file  "[clock format [clock seconds] -format  %jjulian_%Hhr_%Mmin_%Ssec],$phy_name,$chan,"
				puts -nonewline $data_log_file  "1e6,$eye_stats_value,[vod_rd $chan $avmm],[postemp1_rd $chan $avmm],[preemp1_rd $chan $avmm],[lindex $afe_adapt_val 2],[lindex $afe_adapt_val 1],[lindex $afe_adapt_val 0],[lindex $afe_adapt_val 3]"
				puts  $data_log_file "" ; close $data_log_file
				
				foreach no_of_bit [dict get $dash_xcvr_debug_kit ODI.ber] {
					if {[dict get $temp_dict_no_of_bit eye_no_of_bits_${no_of_bit}] == "true" } {
						dashboard_set_property $dash ODI.native.$phy.$chan.status 			text	"Measuring ${no_of_bit}"
						dashboard_set_property $dash ODI.native.$phy.$chan.status 			foregroundColor	blue
						
						ODI_analyze_eye_bathtub_coordinates ${no_of_bit} $chan $avmm 0 1 $spec $start_horiz_window_index $stop_horiz_window_index $Horizontal_en 0 $vert_window_index $Vertical_en 1 $clock_phase_index $phy $dash 
						set clock_phase_index [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.clock_phase_index.${no_of_bit}]
						set eye_stats_value "[dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.total_horizontal_width.${no_of_bit}]/[dict get $ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.${no_of_bit}]"
						dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_${no_of_bit} text $eye_stats_value
						dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_${no_of_bit} foregroundColor	blue
						set start_horiz_window_index  [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.start_horiz_window_index.$no_of_bit]
						set stop_horiz_window_index  [dict get $ODI_dict_err horizontal.native.$avmm.$chan.0.0.stop_horiz_window_index.$no_of_bit]
						set vert_window_index  [expr [dict get $ODI_dict_err vertical.native.$avmm.$chan.0.$clock_phase_index.total_vertical_height.${no_of_bit}]/2]

						set filename  [dict get $dash_xcvr_debug_kit ODI.log_data_filename]
						set data_log_file [open "$filename" "a+"]
						puts -nonewline $data_log_file  "[clock format [clock seconds] -format  %jjulian_%Hhr_%Mmin_%Ssec],$phy_name,$chan,"
						set afe_adapt_val [get_adapt_afe $chan $avmm]
						puts -nonewline $data_log_file  "$no_of_bit,$eye_stats_value,[vod_rd $chan $avmm],[postemp1_rd $chan $avmm],[preemp1_rd $chan $avmm],[lindex $afe_adapt_val 2],[lindex $afe_adapt_val 1],[lindex $afe_adapt_val 0],[lindex $afe_adapt_val 3]"
						puts  $data_log_file ""
						close $data_log_file
				
					} else {
						dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_${no_of_bit} text "--"
						dashboard_set_property $dash ODI.native.$phy.$chan.eye_stats_value_${no_of_bit} foregroundColor	blue
					}
				}
				
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			text	"Done"
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			foregroundColor	blue
			} else {
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			text	"No_CDR_Lock"
				dashboard_set_property $dash ODI.native.$phy.$chan.status 			foregroundColor	red
			}
			
			set afe_adapt_val [get_adapt_afe $chan $avmm]
			dashboard_set_property $dash ODI.native.$phy.$chan.acgain 				text	[lindex $afe_adapt_val 2]  
			dashboard_set_property $dash ODI.native.$phy.$chan.dcgain 				text	[lindex $afe_adapt_val 1]  
			dashboard_set_property $dash ODI.native.$phy.$chan.VGA 					text	[lindex $afe_adapt_val 0]  
			dashboard_set_property $dash ODI.native.$phy.$chan.DFE 					text	[lindex $afe_adapt_val 3]  
			dashboard_set_property $dash ODI.native.$phy.$chan.VOD 					text	[vod_rd $chan $avmm]  
			dashboard_set_property $dash ODI.native.$phy.$chan.post 				text	[postemp1_rd $chan $avmm]  
			dashboard_set_property $dash ODI.native.$phy.$chan.pre 					text	[preemp1_rd $chan $avmm]  
			dashboard_set_property $dash ODI.native.$phy.$chan.test_time			text	"[expr [clock seconds] - $systemTime] sec"
		}
		bkgrnd_cal_enable $chan $avmm	
	}
	

}
proc ODI_Measure_once_all { } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	dashboard_set_property $dash ODI_Measure_once foregroundColor blue
	dashboard_set_property $dash ODI_Measure_once text "Updating"
	dashboard_set_property $dash ODI_Measure_once enabled false
	ODIkitkit_update_all_info    
	dashboard_set_property $dash ODI_Measure_once foregroundColor blue
	dashboard_set_property $dash ODI_Measure_once text "Measure Eye Once"
	dashboard_set_property $dash ODI_Measure_once enabled true
    
}
proc ODI_Measure_once { phy } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	dashboard_set_property $dash ${phy}_ODI_Measure_once foregroundColor blue
	dashboard_set_property $dash ${phy}_ODI_Measure_once text "Updating"
	dashboard_set_property $dash ${phy}_ODI_Measure_once enabled false
	ODIkitkit_update_info $phy
	set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
	# dashboard_set_property $dash ${phy}_ODI_Measure_once  checked "false"
    dashboard_set_property $dash ${phy}_ODI_Measure_once foregroundColor blue
	dashboard_set_property $dash ${phy}_ODI_Measure_once text "Measure Eye Once"
	dashboard_set_property $dash ${phy}_ODI_Measure_once enabled true
	
}
proc ODI_Measure_continuous_all { } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	set loop 1
	while {[string match [dashboard_get_property $dash ODI_Measure_continuous checked] "true"]} {
		ODIkitkit_update_all_info
		puts "Eye Measurement in continuous mode, loop=$loop"
		incr loop
		after 200
    }
}
proc ODI_Measure_continuous { phy } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	set loop 1
	set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
	
	while {[string match [dashboard_get_property $dash ${phy}_ODI_Measure_continuous checked] "true"]} {
		dashboard_set_property $dash ${phy}_ODI_Measure_continuous foregroundColor blue
		dashboard_set_property $dash ${phy}_ODI_Measure_continuous text "continuous Measure Eye Enabled/check to Disable"
		ODIkitkit_update_info $phy
		puts "Eye Measurement in continuous mode, loop=$loop"
		incr loop
		after 200
    }
	dashboard_set_property $dash ${phy}_ODI_Measure_continuous foregroundColor red
	dashboard_set_property $dash ${phy}_ODI_Measure_continuous text "continuous Measure Eye Disabled/check to Ensable"

}
proc prbs_init { } {

	global dash_xcvr_debug_kit 
	
	set ODIkit_native_nos ""
	set k 0
	
	foreach temp [get_service_paths slave] {
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
			
			if { ($condition1 && $condition2 )} { 
				lappend native_nos $k 
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				dict lappend dash_xcvr_debug_kit prbs.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit prbs.native.$k.cable_info $cable_info
				
				
			}
		}
		incr k
	}

	dict lappend dash_xcvr_debug_kit prbs.native.no_of_phy [llength $ODIkit_native_nos]
	dict lappend dash_xcvr_debug_kit prbs.log_data_filename ""

	foreach phy [dict get $dash_xcvr_debug_kit prbs.native.phy_id] {
		dict lappend dash_xcvr_debug_kit prbs.native.$phy.avmm [lindex [get_service_paths slave ] [lindex $ODIkit_native_nos $phy]]
		set avmm [lindex [get_service_paths slave ] $phy]
		dict lappend dash_xcvr_debug_kit prbs.native.$phy.no_of_chan [expr [ read_reg 0x410 0 "$avmm"]]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit prbs.native.$phy.no_of_chan] } {incr chan } {
			bkgrnd_cal_disable $chan $avmm
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x6 [read_reg 0x006 $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x7 [read_reg 0x007 $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x8 [read_reg 0x008 $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x110 [read_reg 0x110 $chan $avmm]
				
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xa [read_reg 0x00a $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xb [read_reg 0x00b $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0xc [read_reg 0x00c $chan $avmm]
			dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x13f [read_reg 0x13f $chan $avmm]
			
			set datapath_sel_0x6 [expr [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x6] & [expr 0xFF & 0x07]]	
			set datapath_sel_0x8 [expr [dict get $dash_xcvr_debug_kit prbs.native.$avmm.$chan.0x8] & [expr 0xFF & 0x60]]	
			
			
			if { ($datapath_sel_0x6 == 4) && ($datapath_sel_0x8 == 0) }  {
				dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.PRBS_selected [htile_get_hard_prbs_pattern_gen $chan $avmm]
			} else {
				dict lappend dash_xcvr_debug_kit prbs.native.$avmm.$chan.PRBS_selected "User_Traffic"
			}
		bkgrnd_cal_enable $chan $avmm
		}
		
	}

}
proc kill_loop { phy dash } {
if {0} { puts [info level 0] }
	global dash_xcvr_debug_kit 
		set data_log_file_close 0
		# puts [dashboard_get_property $dash kill_loop_$phy checked]
		set native_nos 0
		foreach phy1 [dict get $dash_xcvr_debug_kit ODI.native.phy_id] {
			incr native_nos
		}
		set kill_all 0 
		if {$native_nos > 1 } { 
			set kill_all [string match [dashboard_get_property $dash kill_loop_all checked] "true"] 
		}
		set kill_all_phy [string match [dashboard_get_property $dash kill_loop_$phy checked] "true"] 
		
		if {$kill_all || $kill_all_phy } {
			
			#ODI
			set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
			if {$native_nos > 1 } {
				dashboard_set_property $dash kill_loop_all checked false
				
				dashboard_set_property $dash ODI_Measure_once foregroundColor [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_once.foregroundColor.true]  
				dashboard_set_property $dash ODI_Measure_once text [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_once.text.true]
				dashboard_set_property $dash ODI_Measure_once enabled true
				
				dashboard_set_property $dash ODI_Measure_continuous foregroundColor [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.foregroundColor.false]  
				dashboard_set_property $dash ODI_Measure_continuous text [dict get $dash_xcvr_debug_kit ODI.native.ODI_Measure_continuous.text.true]
				dashboard_set_property $dash ODI_Measure_continuous checked false
				
				
			}
			
			foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
				dashboard_set_property $dash kill_loop_$phy checked false
				dashboard_set_property $dash ${phy}_ODI_Measure_once foregroundColor blue
				dashboard_set_property $dash ${phy}_ODI_Measure_once text "Measure Eye Once"
				dashboard_set_property $dash ${phy}_ODI_Measure_once enabled true
				
				dashboard_set_property $dash ${phy}_ODI_Measure_continuous checked false
				dashboard_set_property $dash ${phy}_ODI_Measure_continuous foregroundColor red
				dashboard_set_property $dash ${phy}_ODI_Measure_continuous text "continuous Measure Eye Disabled/check to Enable"
				
				
			}
			
			#atb
			set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
			if {$native_nos > 1 } {
				dashboard_set_property $dash kill_loop_all checked false
				dashboard_set_property $dash atb_Measure_once text "Measure Voltages once - All PHY"
				dashboard_set_property $dash atb_Measure_once foregroundColor blue
				dashboard_set_property $dash atb_Measure_once enabled true
				
				dashboard_set_property $dash atb_Measure_continuous text "continuous update Disabled/check to Enable"
				dashboard_set_property $dash atb_Measure_continuous foregroundColor black	
				dashboard_set_property $dash atb_Measure_continuous checked false	
			}
			foreach phy [dict get $dash_xcvr_debug_kit atb.native.phy_id] {
			
				dashboard_set_property $dash atb_Measure_once_$phy text "Measure Voltage Once"
				dashboard_set_property $dash atb_Measure_once_$phy foregroundColor blue
				dashboard_set_property $dash atb_Measure_once_$phy enabled true
				
				dashboard_set_property $dash atb_Measure_continuous_$phy text "continuous update Disabled/check to Enable"
				dashboard_set_property $dash atb_Measure_continuous_$phy foregroundColor black	
				dashboard_set_property $dash atb_Measure_continuous_$phy checked false	
				dashboard_set_property $dash kill_loop_$phy checked false
				
				
			}
			puts "**** Request made to stop the measurement ****"
			error "**** Request made to stop the measurement ****"
		}
	
}
# ########################################################################################################################
# Tool4 : adaptation status Tool
# ##################################################################################################################################################
proc adaptation_register_init { } {
	
	global dash_xcvr_debug_kit
	
	set native_nos ""
	set k 0
	foreach temp [get_service_paths slave] {
		if {[catch {set x [marker_get_info $temp]} errmsg]} {
			set condition1 0
		} else {
		
			set condition1 [string match -nocase *native* [marker_get_info $temp]]
			set condition2 [string match -nocase *.slave* [marker_get_info $temp]]
		
			if { ($condition1 && $condition2 )} { 
				# puts "native found"
				lappend native_nos $k 
				# puts [lindex [marker_get_info "$temp"] 1]
				set cable_info [string map {" " "_"} [lindex [split $temp "/"] 1]_[lindex [split $temp "/"] 2]]||
				dict lappend dash_xcvr_debug_kit adaptation_register.native.phy_id $k 
				dict lappend dash_xcvr_debug_kit adaptation_register.native.$k.cable_info $cable_info
			}
		}
		incr k
	}
	
	dict lappend dash_xcvr_debug_kit adaptation_register.native.no_of_phy [llength $native_nos]
	
	
	foreach phy [dict get $dash_xcvr_debug_kit adaptation_register.native.phy_id] {
		dict lappend dash_xcvr_debug_kit adaptation_register.native.$phy.avmm [lindex [get_service_paths slave ] [lindex $native_nos $phy]]
		set avmm [lindex [get_service_paths slave ] $phy]
		dict lappend dash_xcvr_debug_kit adaptation_register.native.$phy.no_of_chan [expr [ read_reg 0x410 0 "$avmm"]]
		
	}
	
	dict lappend dash_xcvr_debug_kit adaptation_register.regsiter_bits "
		0x161 6 6	adp_dfe_fxtap_bypass			1	1	0	0
		0x161 5 5	adp_dlev_bypass					1	0	0	0
		0x149 7 7	adp_vga_bypass					1	0	0	0
		0x15F 3 3	adp_ctle_bypass_ac				1	0	0	0
		0x15C 7	7	adp_ctle_bypass_dc				1	0	0	0
		0x148 1	1 	adp_dfe_en						0	1	1	1
		0x148 3 3	adp_dlev_en						0	1	1	1
		0x148 4	4	adp_vga_en						0	1	1	1
		0x161 7	7	adp_ac_ctle_en					0	1	1	1
		0x148 5	5	adp_dc_ctle_en					0	1	1	1
		0x14C 6 5	adp_dfe_tap_sel_en				00	00	10	00
		0x15D 3 1	adp_dfe_hold_sel				000	000	101	000
		0x131 6	6	pdb_edge_pre_h1					NA	NA	1	1
		0x131 7	7	pdb_edge_pst_h1 				NA	NA	1	1
		0x12F 6	6	pdb_tap_4t9						NA	NA	0	1
		0x12F 7	7	pdb_tap_10t15					NA	NA	0	1
		0x150 5	5	pdb_tapsum						NA	NA	0	1
		0x14A 6	6	adp_ac_ctle_cocurrent_mode_sel	NA	0	0	0
		0x162 3 2	adp_dc_ctle_mode_sel			NA	00	00	10
		0x167 6 3	adp_dc_ctle_mode0_win_start		NA	0001	0001	0000
		0x167 2	2	adp_dc_ctle_onetime				NA	0	1	0
		0x158 6	6	adp_vga_ctle_low_limit			NA	1	0	1
		0x166 4 0	adp_vga_dlev_target				NA	01111	01111	11001
		0x174 7	7	vga_ib_max_en					0	1	1	1
		0x168 3	3	bypass_a_edge					NA	NA	NA	NA" 
	

}
proc adaptation_register_gui_tab { } {
		global dash_xcvr_debug_kit version
		set dash [add_service dashboard S10_Ltile_Htile_adaptation_register_Tool_v${version} "S10_Ltile_Htile_adaptation_register_Tool_v${version}" "Tools/S10_Ltile_Htile_adaptation_register_Tool_v${version}"]
		dict lappend dash_xcvr_debug_kit adaptation_register.GUI_dash $dash
		# dashboard_set_property $dash self visible true
		set no_of_line 0

		widget_group $dash adaptation_register_top self 1 ""
		
			widget_group $dash adaptation_register_comment adaptation_register_top 1 "Comments"
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "Tool_v${version} based on Q18.0" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "1.To use this Tool ADME should be Enabled" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "2.Bit Values in brackets (xyz) : Golden bit Values for that adaptation mode configuration" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "3.Red\\Green\\Dark_green LED  : Determines the outcome of the comparison between the read bit value and goldern value" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    1.Red\t\t: The bit values doesn't matches with Values in the brackets" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    2.Green\t\t: The bit values matches with Values in the bracket" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    3.Dark_Green\t: Not Applicable" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "4.Green\\Red Text: Color codes based on the comparison between the silicon register value and golden register value. Green means the channel configured in that particular mode" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    1.Green text --> the channel configured in that adaptation mode" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    2.Red text   --> the channel configured is not configured in that adaptation mode" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "5.Row\\Column" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    1.Rows   --> Channel with all possible adaptation mode combination" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    2.Column --> Column consist of all the adapation bit with golden values which is needed to configure the channel in one particular mode" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "6.Adaptation Modes + Decoding" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    1.Manual_CTLE/VGA_DFE_Off        --> adp_dlev_bypass = 1       & adp_dfe_fxtap_bypass = 1" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    2.Adaptive_CTLE/VGA_DFE_Off      --> adp_dlev_bypass = 0       & adp_dfe_fxtap_bypass = 1" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    3.Adaptive_CTLE/VGA_1Tap_DFE     --> adp_dfe_fxtap_bypass = 0  & adp_dfe_tap_sel_en = 2'b10 & adp_vga_bypass =0" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "    4.Adaptive_CTLE/VGA_All_Tap_DFE  --> adp_dfe_fxtap_bypass = 0  & adp_dfe_tap_sel_en = 2'b00 & adp_vga_bypass =0" blue
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "7. Since this Tool is data rate agnostic, Please check the register 0x11E\[2:0\] manually (These register bits are set based on the data rate)" red
				widget_label $dash adaptation_register_my_label1 adaptation_register_comment   "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **" green
			
			widget_group $dash  adaptation_register adaptation_register_top 2 "Measurement Type"
				widget_button $dash adaptation_register_refresh_once adaptation_register "Measure Adaptation Status" adaptation_register_refresh_once
				widget_button 	$dash adaptatio_status_log adaptation_register "logfile" adaptation_register_logfile
			 
			widget_group $dash adaptation_register_ch adaptation_register_top 1 "PHY + Channel"
			foreach phy [dict get $dash_xcvr_debug_kit adaptation_register.native.phy_id] {
				
				set cable_name [dict get $dash_xcvr_debug_kit adaptation_register.native.$phy.cable_info]
				set phy_name [lindex [marker_get_info [lindex [get_service_paths slave] $phy]] 3]
				widget_group $dash $phy_name adaptation_register_ch 26 "${cable_name}${phy_name}" [expr ([string length $cable_name] +[string length $phy_name]) * 6 ]
					
					set register [string map {\{ "" \} "" \\ ""} [regexp -inline -all -- {\S+} [dict get $dash_xcvr_debug_kit adaptation_register.regsiter_bits] ]]
					#row 1
					widget_label $dash adaptation_register_my_label_1  $phy_name   "" blue
					for {set reg 3 } { $reg < [llength $register]  } {incr reg 8 } {
						
						widget_label $dash adaptation_register_my_label_1  $phy_name   [lindex $register $reg]  blue
					}
					#row 2
					widget_label $dash adaptation_register_my_label_1  $phy_name   " " black
					for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
						set address 	[string trim [lindex $register $reg] " "]
						set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
						set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
						widget_label $dash adaptation_register_my_label_1  $phy_name  "${address}\[${start_mask}:${stop_mask}\]"  blue
					}
					
					
					set modes_list   "Manual_CTLE/VGA_DFE_Off	Adaptive_CTLE/VGA_DFE_Off	Adaptive_CTLE/VGA_1Tap_DFE	Adaptive_CTLE/VGA_All_Tap_DFE"
					
					for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit adaptation_register.native.$phy.no_of_chan]  } {incr chan } {			
						
						#some blank spaces
						for { set temp 0 } { $temp < 26 } { incr temp } {
							widget_label $dash adaptation_register_my_label_1 $phy_name  "--" black
						}
						
						#manual mode
						widget_label $dash adaptation_register.native.$phy.${chan}.Manual_CTLE_VGA_DFE_Off.label $phy_name  "Chan${chan}_Manual_CTLE/VGA_DFE_Off" black
						for {set reg 4 } { $reg < [llength $register]  } {incr reg 8 } {
							widget_led    $dash   adaptation_register.native.$phy.${chan}.Manual_CTLE_VGA_DFE_Off.led_id_[string trim [lindex $register [expr $reg -4]] " "]_[string trim [lindex $register [expr $reg -3]] " "]_[string trim [lindex $register [expr $reg -2]] " "]    $phy_name  "--([lindex $register $reg])"  green_off
						}
						
						# mode 2
						widget_label $dash adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_DFE_Off.label $phy_name  "Chan${chan}_Adaptive_CTLE/VGA_DFE_Off" black
						for {set reg 5 } { $reg < [llength $register]  } {incr reg 8 } {
							widget_led    $dash   adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_DFE_Off.led_id_[string trim [lindex $register [expr $reg -5]] " "]_[string trim [lindex $register [expr $reg -4]]]_[string trim [lindex $register [expr $reg -3]] " "]      $phy_name  "--([lindex $register $reg])"  green_off
						}
						
						#mode 3
						widget_label $dash adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_1Tap_DFE.label $phy_name  "Chan${chan}_Adaptive_CTLE/VGA_1Tap_DFE" black
						for {set reg 6 } { $reg < [llength $register]  } {incr reg 8 } {
							widget_led    $dash   adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_1Tap_DFE.led_id_[string trim [lindex $register [expr $reg -6]] " "]_[string trim [lindex $register [expr $reg -5]]]_[string trim [lindex $register [expr $reg -4]] " "]      $phy_name  "--([lindex $register $reg])"  green_off
						}
						
						#mode3 4
						widget_label $dash adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_All_Tap_DFE.label $phy_name  "Chan${chan}_Adaptive_CTLE/VGA_All_Tap_DFE" black
						
						for {set reg 7 } { $reg < [llength $register]  } {incr reg 8 } {
							widget_led    $dash   adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_All_Tap_DFE.led_id_[string trim [lindex $register [expr $reg -7]] " "]_[string trim [lindex $register [expr $reg -6]]]_[string trim [lindex $register [expr $reg -5]] " "]      $phy_name  "--([lindex $register $reg])"  green_off
						}
					}
			}
	}	
proc adaptation_register_refresh_once { } {
	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit adaptation_register.GUI_dash]
	dashboard_set_property $dash adaptation_register_refresh_once foregroundColor blue
	dashboard_set_property $dash adaptation_register_refresh_once text "updating"
	dashboard_set_property $dash adaptation_register_refresh_once enabled false
	adaptation_register_update_led
	dashboard_set_property $dash adaptation_register_refresh_once text "Measure Adaptation Status Bits"
	dashboard_set_property $dash adaptation_register_refresh_once foregroundColor blue
	dashboard_set_property $dash adaptation_register_refresh_once enabled true
}
proc adaptation_register_logfile 		{ } {
	global dash_xcvr_debug_kit 
	set systemTime [clock seconds]
	set filename "log/adaptation_register_status_log_[clock format $systemTime -format  %jjulian_%Hhr_%Mmin_%Ssec]_[info hostname].csv"
	set data_log_file [open "$filename" "w"]
	puts "****************************************************************************************************************"
	puts "****************************************************************************************************************"
	puts "LogFile is created in the following folder --> [pwd]/log \n"

	set register [string map {\{ "" \} "" \\ ""} [regexp -inline -all -- {\S+} [dict get $dash_xcvr_debug_kit adaptation_register.regsiter_bits] ]]
	#row 1
	puts -nonewline $data_log_file " ,"
	for {set reg 3 } { $reg < [llength $register]  } {incr reg 8 } {
		puts -nonewline $data_log_file "[lindex $register $reg],"  
	}
	puts $data_log_file ""
	#row 2
	puts -nonewline $data_log_file " ,"
	for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
		set address 	[string trim [lindex $register $reg] " "]
		set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
		set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
		puts -nonewline $data_log_file "${address}\[${start_mask}:${stop_mask}\],"
	}

	puts $data_log_file ""
	
	set register [string map {\{ "" \} "" \\ ""} [regexp -inline -all -- {\S+} [dict get $dash_xcvr_debug_kit adaptation_register.regsiter_bits] ]]
	foreach phy [dict get $dash_xcvr_debug_kit adaptation_register.native.phy_id] {
		set avmm [lindex [get_service_paths slave ] $phy]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit adaptation_register.native.$phy.no_of_chan] } {incr chan } {
			puts -nonewline $data_log_file "adaptation_register.native.phy_${phy}.chan_${chan}.Manual_CTLE_VGA_DFE_Off_val.label,"
			for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
				set address 	[string trim [lindex $register $reg] " "]
				set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
				set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
				set Manual_CTLE_VGA_DFE_Off_val 		[string trim [lindex $register [expr $reg + 4]] " "]
				set bit_val [string trim [string range [format %08s [format %llb  [expr [ read_reg $address $chan "$avmm"]]]] [expr 7 - $start_mask] [expr 7 - $stop_mask]] " " ]
				puts -nonewline $data_log_file "${bit_val}(${Manual_CTLE_VGA_DFE_Off_val}),"
			}
			puts $data_log_file ""
			puts -nonewline $data_log_file "adaptation_register.native.phy_${phy}.chan_${chan}.Adaptive_CTLE_VGA_DFE_Off_val.label,"
			for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
				set address 	[string trim [lindex $register $reg] " "]
				set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
				set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
				set Adaptive_CTLE_VGA_DFE_Off_val   	[string trim [lindex $register [expr $reg + 5]] " "]
				set bit_val [string trim [string range [format %08s [format %llb  [expr [ read_reg $address $chan "$avmm"]]]] [expr 7 - $start_mask] [expr 7 - $stop_mask]] " " ]
				puts -nonewline $data_log_file "${bit_val}(${Adaptive_CTLE_VGA_DFE_Off_val}),"
			}
			puts $data_log_file ""
			puts -nonewline $data_log_file "adaptation_register.native.phy_${phy}.chan_${chan}.Adaptive_CTLE_VGA_1Tap_DFE_val.label,"
			for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
				set address 	[string trim [lindex $register $reg] " "]
				set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
				set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
				set Adaptive_CTLE_VGA_1Tap_DFE_val  	[string trim [lindex $register [expr $reg + 6]] " "]
				set bit_val [string trim [string range [format %08s [format %llb  [expr [ read_reg $address $chan "$avmm"]]]] [expr 7 - $start_mask] [expr 7 - $stop_mask]] " " ]
				puts -nonewline $data_log_file "${bit_val}(${Adaptive_CTLE_VGA_1Tap_DFE_val}),"
			}	
			puts $data_log_file ""
			puts -nonewline $data_log_file "adaptation_register.native.phy_${phy}.chan_${chan}.Adaptive_CTLE_VGA_All_Tap_DFE_val.label,"
			for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
				set address 	[string trim [lindex $register $reg] " "]
				set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
				set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
				set Adaptive_CTLE_VGA_All_Tap_DFE_val	[string trim [lindex $register [expr $reg + 7]] " "]
				set bit_val [string trim [string range [format %08s [format %llb  [expr [ read_reg $address $chan "$avmm"]]]] [expr 7 - $start_mask] [expr 7 - $stop_mask]] " " ]
				puts -nonewline $data_log_file "${bit_val}(${Adaptive_CTLE_VGA_All_Tap_DFE_val}),"
			}	
			puts $data_log_file ""
		}
	}
	close $data_log_file	
	puts "****************************************************************************************************************"
	puts "****************************************************************************************************************"
	
}
proc adaptation_register_update_led { } {

	global dash_xcvr_debug_kit 
	set dash [dict get $dash_xcvr_debug_kit adaptation_register.GUI_dash]
	
	set register [string map {\{ "" \} "" \\ ""} [regexp -inline -all -- {\S+} [dict get $dash_xcvr_debug_kit adaptation_register.regsiter_bits] ]]
	foreach phy [dict get $dash_xcvr_debug_kit adaptation_register.native.phy_id] {
		set avmm [lindex [get_service_paths slave ] $phy]
		for {set chan 0 } { $chan < [dict get $dash_xcvr_debug_kit adaptation_register.native.$phy.no_of_chan] } {incr chan } {
			bkgrnd_cal_disable $chan $avmm
				set Manual_CTLE_VGA_DFE_Off_status_val 			0
				set Adaptive_CTLE_VGA_DFE_Off_status_val    	0
				set Adaptive_CTLE_VGA_1Tap_DFE_status_val     	0
				set Adaptive_CTLE_VGA_All_Tap_DFE_status_val	0
				
			for {set reg 0 } { $reg < [llength $register]  } {incr reg 8 } {
				
				set address 	[string trim [lindex $register $reg] " "]
				set start_mask [string trim [lindex $register [expr $reg + 1]] " "]
				set stop_mask [string trim [lindex $register [expr $reg + 2]] " "]
				
				set Manual_CTLE_VGA_DFE_Off_val 		[string trim [lindex $register [expr $reg + 4]] " "]
				set Adaptive_CTLE_VGA_DFE_Off_val   	[string trim [lindex $register [expr $reg + 5]] " "]
				set Adaptive_CTLE_VGA_1Tap_DFE_val  	[string trim [lindex $register [expr $reg + 6]] " "]
				set Adaptive_CTLE_VGA_All_Tap_DFE_val	[string trim [lindex $register [expr $reg + 7]] " "]
				
				set bit_val [string trim [string range [format %08s [format %llb  [expr [ read_reg $address $chan "$avmm"]]]] [expr 7 - $start_mask] [expr 7 - $stop_mask]] " " ]
				
				set id "adaptation_register.native.$phy.${chan}.Manual_CTLE_VGA_DFE_Off.led_id_${address}_${start_mask}_${stop_mask}"
				dashboard_set_property  $dash  $id  text      "${bit_val}(${Manual_CTLE_VGA_DFE_Off_val})"
				if {([string match $Manual_CTLE_VGA_DFE_Off_val $bit_val]==1) & ([string match $Manual_CTLE_VGA_DFE_Off_val "NA"]==0 )} { dashboard_set_property $dash $id color green } else { dashboard_set_property $dash $id color red ; incr Manual_CTLE_VGA_DFE_Off_status_val  }
				if {([string match $Manual_CTLE_VGA_DFE_Off_val "NA"]==1 )} { 	dashboard_set_property  $dash  $id  color green_off ;incr Manual_CTLE_VGA_DFE_Off_status_val  -1 } 
				
				set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_DFE_Off.led_id_${address}_${start_mask}_${stop_mask}"
				dashboard_set_property  $dash  $id  text      "${bit_val}(${Adaptive_CTLE_VGA_DFE_Off_val})"
				if {([string match $Adaptive_CTLE_VGA_DFE_Off_val $bit_val]==1) & ([string match $Adaptive_CTLE_VGA_DFE_Off_val "NA"]==0 ) } { dashboard_set_property $dash $id color green } else { dashboard_set_property $dash $id color red ; incr Adaptive_CTLE_VGA_DFE_Off_status_val }
				if {([string match $Adaptive_CTLE_VGA_DFE_Off_val "NA"]==1 )} { dashboard_set_property  $dash  $id  color green_off ;incr Adaptive_CTLE_VGA_DFE_Off_status_val -1 } 
				
				set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_1Tap_DFE.led_id_${address}_${start_mask}_${stop_mask}"
				dashboard_set_property  $dash  $id  text      "${bit_val}(${Adaptive_CTLE_VGA_1Tap_DFE_val})"
				if {([string match $Adaptive_CTLE_VGA_1Tap_DFE_val $bit_val]==1) & ([string match $Adaptive_CTLE_VGA_1Tap_DFE_val "NA"]==0 ) } { dashboard_set_property $dash $id color green } else { dashboard_set_property $dash $id color red ; incr  Adaptive_CTLE_VGA_1Tap_DFE_status_val  }
				if {([string match $Adaptive_CTLE_VGA_1Tap_DFE_val "NA"]==1 )} { dashboard_set_property  $dash  $id  color green_off ; incr  Adaptive_CTLE_VGA_1Tap_DFE_status_val  -1} 
				
				set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_All_Tap_DFE.led_id_${address}_${start_mask}_${stop_mask}"
				dashboard_set_property  $dash  $id  text      "${bit_val}(${Adaptive_CTLE_VGA_All_Tap_DFE_val})"
				if {([string match $Adaptive_CTLE_VGA_All_Tap_DFE_val $bit_val]==1) &([string match $Adaptive_CTLE_VGA_All_Tap_DFE_val "NA"]==0 ) } { dashboard_set_property $dash $id color green } else { dashboard_set_property $dash $id color red ; incr Adaptive_CTLE_VGA_All_Tap_DFE_status_val }
				if {([string match $Adaptive_CTLE_VGA_All_Tap_DFE_val "NA"]==1 )} { dashboard_set_property  $dash  $id  color green_off ;incr Adaptive_CTLE_VGA_All_Tap_DFE_status_val -1} 
				
				# puts "$phy $chan $reg $address $Manual_CTLE_VGA_DFE_Off_status_val  $Adaptive_CTLE_VGA_DFE_Off_status_val $Adaptive_CTLE_VGA_1Tap_DFE_status_val $Adaptive_CTLE_VGA_All_Tap_DFE_status_val"
			}
			set id "adaptation_register.native.$phy.${chan}.Manual_CTLE_VGA_DFE_Off.label"
			if $Manual_CTLE_VGA_DFE_Off_status_val { dashboard_set_property  $dash  $id  foregroundColor  red } else { dashboard_set_property  $dash  $id  foregroundColor  green}
			set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_DFE_Off.label"
			if $Adaptive_CTLE_VGA_DFE_Off_status_val { dashboard_set_property  $dash  $id  foregroundColor  red } else { dashboard_set_property  $dash  $id  foregroundColor  green}
			set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_1Tap_DFE.label"
			if $Adaptive_CTLE_VGA_1Tap_DFE_status_val { dashboard_set_property  $dash  $id  foregroundColor  red } else { dashboard_set_property  $dash  $id  foregroundColor  green}
			set id "adaptation_register.native.$phy.${chan}.Adaptive_CTLE_VGA_All_Tap_DFE.label"
			if $Adaptive_CTLE_VGA_All_Tap_DFE_status_val { dashboard_set_property  $dash  $id  foregroundColor  red } else { dashboard_set_property  $dash  $id  foregroundColor  green}
			bkgrnd_cal_enable $chan $avmm
		}
	}
}

# dashboard_set_property $dash [dict get $dash_xcvr_debug_kit xcvr_status.native.$phy.$chan.${debug}.led_id] color [dict get $dash_xcvr_debug_kit xcvr_status.native.${debug}.led_good_color] 
# ########################################################################################################################
# ########################################################################################################################
# ########################################################################################################################
set avmm [lindex [get_service_paths slave] 0 ]
if 0 {
	rx_inversion 3 $avmm ; tx_inversion 0 $avmm; tx_inversion 2 $avmm ; tx_inversion 3 $avmm
	foreach addr "0x6 0x7 0x8 0x110 0xa 0xb 0xc 0x13f" { puts -nonewline "$addr=[read_reg $addr 0 [lindex [get_service_paths slave] 9 ]], " }
	puts ""
	foreach addr "0x6 0x7 0x8 0x110 0xa 0xb 0xc 0x13f" { puts -nonewline "$addr=[read_reg $addr 0 [lindex [get_service_paths slave] 10 ]], " }
}

if 1 {

	# set sof_path {C:\Users\kbalakri\system_console\scripts\sof\nios_64ch_18.1_H_TILE_core_noise_22031800_restored_1SX280HU2F50E2VG.sof}
	# set sof_path {C:\Users\kbalakri\Desktop\S10_8chan28gbpsQSFP_plus_4chan28gbpsSMA_plus_2chan12GbpsSMA.sof}
	# puts "Loading ${sof_path} Design" ; set design [design_load $sof_path] ; puts "Loading Done"
	# puts "refresh connections"; refresh_connections
	# after 100
	# puts "refresh connections Done";  
	# puts "Loading Done"
	
	set dash_xcvr_debug_kit { }
	set ODI_dict_err { }
	
	puts "\n** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** "
	puts "S10_Ltile_Htile_Transceiver_Voltage_Debug_Tool_v${version} Load Start 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	atb_init
	atb_gui_tab 
	puts "S10_Ltile_Htile_Transceiver_Voltage_Debug_Tool_v${version} Load Stop 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** "
	puts "S10_Ltile_Htile_Transceiver_Status_Debug_Tool_v${version} Load Start 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	healthkit_init
	healthkit_gui_tab 
	puts "S10_Ltile_Htile_Transceiver_Status_Debug_Tool_v${version} Load Stop 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **"
	puts "S10_Ltile_Htile_Transceiver_Eye_Debug_Tool_v${version} Load Start 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	bkgrnd_cal_read_int
	prbs_init
	ODIkit_init
	pma_init
	ODIkit_gui_tab
	after 3000
	puts "S10_Ltile_Htile_Transceiver_EYE_Debug_Tool_v${version} Load Stop 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** "
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **"
	puts "S10_Ltile_Htile_Transceiver_adaptation_register_Tool_v${version} Load Start 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	adaptation_register_init
	adaptation_register_gui_tab
	# after 3000
	puts "S10_Ltile_Htile_Transceiver_adaptation_register_Tool_v${version} Load Stop 	- Current time- [clock format [clock seconds] -format  %Hhr_%Mmin_%Ssec]"
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** "
	puts "Tool Loaded"
	puts "** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** "
	
	set dash [dict get $dash_xcvr_debug_kit atb.GUI_dash]
	dashboard_set_property $dash self visible true
	set dash [dict get $dash_xcvr_debug_kit XCVR_Status.GUI_dash]
	dashboard_set_property $dash self visible true
	set dash [dict get $dash_xcvr_debug_kit adaptation_register.GUI_dash]
	dashboard_set_property $dash self visible true
	set dash [dict get $dash_xcvr_debug_kit eye.GUI_dash]
	dashboard_set_property $dash self visible true


}
	