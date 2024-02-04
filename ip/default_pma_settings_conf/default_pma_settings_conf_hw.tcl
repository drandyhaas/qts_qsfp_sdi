# TCL File Generated by Component Editor 13.0
# Wed May 01 20:29:02 PDT 2013
# DO NOT MODIFY


# 
# default_pma_settings_conf "default_pma_settings_conf" v1.0
#  2013.05.01.20:29:02
# 
# 

# 
# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0


# 
# module default_pma_settings_conf
# 
set_module_property DESCRIPTION ""
set_module_property NAME default_pma_settings_conf
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Devkit_IPs
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME default_pma_settings_conf
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL default_pma_settings_conf
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file default_pma_settings_conf.v VERILOG PATH default_pma_settings_conf.v


# 
# parameters
# 
add_parameter XCVR_RECONFIG_BASE_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_RECONFIG_BASE_ADDR DEFAULT_VALUE 0
set_parameter_property XCVR_RECONFIG_BASE_ADDR DISPLAY_NAME XCVR_RECONFIG_BASE_ADDR
set_parameter_property XCVR_RECONFIG_BASE_ADDR WIDTH 32
set_parameter_property XCVR_RECONFIG_BASE_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_RECONFIG_BASE_ADDR UNITS None
set_parameter_property XCVR_RECONFIG_BASE_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_RECONFIG_BASE_ADDR HDL_PARAMETER true

add_parameter XCVR_VOD_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_VOD_ADDR DEFAULT_VALUE 1060
set_parameter_property XCVR_VOD_ADDR DISPLAY_NAME XCVR_VOD_ADDR
set_parameter_property XCVR_VOD_ADDR WIDTH 32
set_parameter_property XCVR_VOD_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_VOD_ADDR UNITS None
set_parameter_property XCVR_VOD_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_VOD_ADDR HDL_PARAMETER true

add_parameter XCVR_PRE_1ST_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_PRE_1ST_ADDR DEFAULT_VALUE 1052
set_parameter_property XCVR_PRE_1ST_ADDR DISPLAY_NAME XCVR_PRE_1ST_ADDR
set_parameter_property XCVR_PRE_1ST_ADDR WIDTH 32
set_parameter_property XCVR_PRE_1ST_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_PRE_1ST_ADDR UNITS None
set_parameter_property XCVR_PRE_1ST_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_PRE_1ST_ADDR HDL_PARAMETER true

add_parameter XCVR_PRE_2ND_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_PRE_2ND_ADDR DEFAULT_VALUE 1056
set_parameter_property XCVR_PRE_2ND_ADDR DISPLAY_NAME XCVR_PRE_2ND_ADDR
set_parameter_property XCVR_PRE_2ND_ADDR WIDTH 32
set_parameter_property XCVR_PRE_2ND_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_PRE_2ND_ADDR UNITS None
set_parameter_property XCVR_PRE_2ND_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_PRE_2ND_ADDR HDL_PARAMETER true

add_parameter XCVR_POST_1ST_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_POST_1ST_ADDR DEFAULT_VALUE 1044
set_parameter_property XCVR_POST_1ST_ADDR DISPLAY_NAME XCVR_POST_1ST_ADDR
set_parameter_property XCVR_POST_1ST_ADDR WIDTH 32
set_parameter_property XCVR_POST_1ST_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_POST_1ST_ADDR UNITS None
set_parameter_property XCVR_POST_1ST_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_POST_1ST_ADDR HDL_PARAMETER true

add_parameter XCVR_POST_2ND_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_POST_2ND_ADDR DEFAULT_VALUE 1048
set_parameter_property XCVR_POST_2ND_ADDR DISPLAY_NAME XCVR_POST_2ND_ADDR
set_parameter_property XCVR_POST_2ND_ADDR WIDTH 32
set_parameter_property XCVR_POST_2ND_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_POST_2ND_ADDR UNITS None
set_parameter_property XCVR_POST_2ND_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_POST_2ND_ADDR HDL_PARAMETER true

add_parameter XCVR_CTLE_1S_ENABLE_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR DEFAULT_VALUE 1132
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR DISPLAY_NAME XCVR_CTLE_1S_ENABLE_ADDR
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR WIDTH 32
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR UNITS None
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_CTLE_1S_ENABLE_ADDR HDL_PARAMETER true

add_parameter XCVR_CTLE_1S_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_CTLE_1S_ADDR DEFAULT_VALUE 1432
set_parameter_property XCVR_CTLE_1S_ADDR DISPLAY_NAME XCVR_CTLE_1S_ADDR
set_parameter_property XCVR_CTLE_1S_ADDR WIDTH 32
set_parameter_property XCVR_CTLE_1S_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_CTLE_1S_ADDR UNITS None
set_parameter_property XCVR_CTLE_1S_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_CTLE_1S_ADDR HDL_PARAMETER true

add_parameter XCVR_CTLE_4S_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_CTLE_4S_ADDR DEFAULT_VALUE 1436
set_parameter_property XCVR_CTLE_4S_ADDR DISPLAY_NAME XCVR_CTLE_4S_ADDR
set_parameter_property XCVR_CTLE_4S_ADDR WIDTH 32
set_parameter_property XCVR_CTLE_4S_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_CTLE_4S_ADDR UNITS None
set_parameter_property XCVR_CTLE_4S_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_CTLE_4S_ADDR HDL_PARAMETER true

add_parameter XCVR_DCGAIN_L8_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_DCGAIN_L8_ADDR DEFAULT_VALUE 1128
set_parameter_property XCVR_DCGAIN_L8_ADDR DISPLAY_NAME XCVR_DCGAIN_L8_ADDR
set_parameter_property XCVR_DCGAIN_L8_ADDR WIDTH 32
set_parameter_property XCVR_DCGAIN_L8_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_DCGAIN_L8_ADDR UNITS None
set_parameter_property XCVR_DCGAIN_L8_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_DCGAIN_L8_ADDR HDL_PARAMETER true

add_parameter XCVR_DCGAIN_H4_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_DCGAIN_H4_ADDR DEFAULT_VALUE 1136
set_parameter_property XCVR_DCGAIN_H4_ADDR DISPLAY_NAME XCVR_DCGAIN_H4_ADDR
set_parameter_property XCVR_DCGAIN_H4_ADDR WIDTH 32
set_parameter_property XCVR_DCGAIN_H4_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_DCGAIN_H4_ADDR UNITS None
set_parameter_property XCVR_DCGAIN_H4_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_DCGAIN_H4_ADDR HDL_PARAMETER true

add_parameter XCVR_VGA_ADDR STD_LOGIC_VECTOR 32
set_parameter_property XCVR_VGA_ADDR DEFAULT_VALUE 1408
set_parameter_property XCVR_VGA_ADDR DISPLAY_NAME XCVR_VGA_ADDR
set_parameter_property XCVR_VGA_ADDR WIDTH 32
set_parameter_property XCVR_VGA_ADDR TYPE STD_LOGIC_VECTOR
set_parameter_property XCVR_VGA_ADDR UNITS None
set_parameter_property XCVR_VGA_ADDR ALLOWED_RANGES 0:1879048192
set_parameter_property XCVR_VGA_ADDR HDL_PARAMETER true

# 
# display items
# 
add_display_item "" "Performance Calculate Options" GROUP ""

# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1

# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master master_wen write_n Output 1
add_interface_port avalon_master master_oen read_n Output 1
add_interface_port avalon_master master_be byteenable Output 4
add_interface_port avalon_master master_address address Output 32
add_interface_port avalon_master master_wdata writedata Output 32
add_interface_port avalon_master master_rdata readdata Input 32
add_interface_port avalon_master readdatavalid_in readdatavalid Input 1
add_interface_port avalon_master waitrequest_in waitrequest Input 1

# 
# connection point reset
# 

#add_interface slave_clock clock end
#set_interface_property slave_clock clockRate 0
#set_interface_property slave_clock ENABLED true
#set_interface_property slave_clock EXPORT_OF ""
#set_interface_property slave_clock PORT_NAME_MAP ""
#set_interface_property slave_clock SVD_ADDRESS_GROUP ""
#
#add_interface_port slave_clock slave_clk clk Input 1
#
#
#add_interface slave_reset reset end
#set_interface_property slave_reset associatedClock slave_clock
#set_interface_property slave_reset synchronousEdges DEASSERT
#set_interface_property slave_reset ENABLED true
#set_interface_property slave_reset EXPORT_OF ""
#set_interface_property slave_reset PORT_NAME_MAP ""
#set_interface_property slave_reset SVD_ADDRESS_GROUP ""
#
#add_interface_port slave_reset slave_reset_n reset_n Input 1

# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave slave_read read Input 1
add_interface_port avalon_slave slave_write write Input 1
add_interface_port avalon_slave slave_readdata readdata Output 32
add_interface_port avalon_slave slave_writedata writedata Input 32
add_interface_port avalon_slave slave_address address Input 4
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


