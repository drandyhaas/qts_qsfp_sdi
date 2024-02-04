# TCL File Generated by Component Editor 17.1ir.2
# Wed Jul 05 19:17:46 CST 2017
# DO NOT MODIFY


# 
# xcvr_tx_rx_clkout2_converter "xcvr_tx_rx_clkout2_converter" v1.0
#  2017.07.05.19:17:46
# 
# 

# 
# request TCL package from ACDS 17.1
# 
package require -exact qsys 13.1


# 
# module xcvr_tx_rx_clkout2_converter
# 
set_module_property DESCRIPTION ""
set_module_property NAME xcvr_tx_rx_clkout2_converter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME xcvr_tx_rx_clkout2_converter
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property GROUP Devkit_IPs

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL xcvr_tx_rx_clkout2_converter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file xcvr_tx_rx_clkout2_converter.v VERILOG PATH xcvr_tx_rx_clkout2_converter.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL xcvr_tx_rx_clkout2_converter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file xcvr_tx_rx_clkout2_converter.v VERILOG PATH xcvr_tx_rx_clkout2_converter.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point rx_clkout2
# 
add_interface rx_clkout2 clock end
set_interface_property rx_clkout2 clockRate 0
set_interface_property rx_clkout2 ENABLED true
set_interface_property rx_clkout2 EXPORT_OF ""
set_interface_property rx_clkout2 PORT_NAME_MAP ""
set_interface_property rx_clkout2 CMSIS_SVD_VARIABLES ""
set_interface_property rx_clkout2 SVD_ADDRESS_GROUP ""

add_interface_port rx_clkout2 rx_clkout2 clk Input 1


# 
# connection point rx_clkout2_a
# 
add_interface rx_clkout2_a conduit end
set_interface_property rx_clkout2_a associatedClock ""
set_interface_property rx_clkout2_a associatedReset ""
set_interface_property rx_clkout2_a ENABLED true
set_interface_property rx_clkout2_a EXPORT_OF ""
set_interface_property rx_clkout2_a PORT_NAME_MAP ""
set_interface_property rx_clkout2_a CMSIS_SVD_VARIABLES ""
set_interface_property rx_clkout2_a SVD_ADDRESS_GROUP ""

add_interface_port rx_clkout2_a rx_clkout2_a export Output 1


# 
# connection point rx_clkout2_b
# 
add_interface rx_clkout2_b conduit end
set_interface_property rx_clkout2_b associatedClock ""
set_interface_property rx_clkout2_b associatedReset ""
set_interface_property rx_clkout2_b ENABLED true
set_interface_property rx_clkout2_b EXPORT_OF ""
set_interface_property rx_clkout2_b PORT_NAME_MAP ""
set_interface_property rx_clkout2_b CMSIS_SVD_VARIABLES ""
set_interface_property rx_clkout2_b SVD_ADDRESS_GROUP ""

add_interface_port rx_clkout2_b rx_clkout2_b export Output 1


# 
# connection point tx_clkout2
# 
add_interface tx_clkout2 clock end
set_interface_property tx_clkout2 clockRate 0
set_interface_property tx_clkout2 ENABLED true
set_interface_property tx_clkout2 EXPORT_OF ""
set_interface_property tx_clkout2 PORT_NAME_MAP ""
set_interface_property tx_clkout2 CMSIS_SVD_VARIABLES ""
set_interface_property tx_clkout2 SVD_ADDRESS_GROUP ""

add_interface_port tx_clkout2 tx_clkout2 clk Input 1


# 
# connection point tx_clkout2_a
# 
add_interface tx_clkout2_a conduit end
set_interface_property tx_clkout2_a associatedClock ""
set_interface_property tx_clkout2_a associatedReset ""
set_interface_property tx_clkout2_a ENABLED true
set_interface_property tx_clkout2_a EXPORT_OF ""
set_interface_property tx_clkout2_a PORT_NAME_MAP ""
set_interface_property tx_clkout2_a CMSIS_SVD_VARIABLES ""
set_interface_property tx_clkout2_a SVD_ADDRESS_GROUP ""

add_interface_port tx_clkout2_a tx_clkout2_a export Output 1


# 
# connection point tx_clkout2_b
# 
add_interface tx_clkout2_b conduit end
set_interface_property tx_clkout2_b associatedClock ""
set_interface_property tx_clkout2_b associatedReset ""
set_interface_property tx_clkout2_b ENABLED true
set_interface_property tx_clkout2_b EXPORT_OF ""
set_interface_property tx_clkout2_b PORT_NAME_MAP ""
set_interface_property tx_clkout2_b CMSIS_SVD_VARIABLES ""
set_interface_property tx_clkout2_b SVD_ADDRESS_GROUP ""

add_interface_port tx_clkout2_b tx_clkout2_b export Output 1


# 
# connection point tx_clkout2_sample
# 
add_interface tx_clkout2_sample clock start
set_interface_property tx_clkout2_sample associatedDirectClock ""
set_interface_property tx_clkout2_sample clockRate 0
set_interface_property tx_clkout2_sample clockRateKnown false
set_interface_property tx_clkout2_sample ENABLED true
set_interface_property tx_clkout2_sample EXPORT_OF ""
set_interface_property tx_clkout2_sample PORT_NAME_MAP ""
set_interface_property tx_clkout2_sample CMSIS_SVD_VARIABLES ""
set_interface_property tx_clkout2_sample SVD_ADDRESS_GROUP ""

add_interface_port tx_clkout2_sample tx_clkout2_sample clk Output 1

