# TCL File Generated by Component Editor 17.1
# Wed Jul 05 16:33:26 CST 2017
# DO NOT MODIFY


# 
# xcvr_user_rx_fifo_converter "xcvr_user_rx_fifo_converter" v1.0
#  2017.07.05.16:33:26
# 
# 

# 
# request TCL package from ACDS 17.1
# 
package require -exact qsys 13.1


# 
# module xcvr_user_rx_fifo_converter
# 
set_module_property DESCRIPTION ""
set_module_property NAME xcvr_user_rx_fifo_converter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME xcvr_user_rx_fifo_converter
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL xcvr_user_rx_fifo_converter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file xcvr_user_rx_fifo_converter.v VERILOG PATH xcvr_user_rx_fifo_converter.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL xcvr_user_rx_fifo_converter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file xcvr_user_rx_fifo_converter.v VERILOG PATH xcvr_user_rx_fifo_converter.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point data_pattern_checker_pattern_in
# 
add_interface data_pattern_checker_pattern_in conduit end
set_interface_property data_pattern_checker_pattern_in associatedClock ""
set_interface_property data_pattern_checker_pattern_in associatedReset ""
set_interface_property data_pattern_checker_pattern_in ENABLED true
set_interface_property data_pattern_checker_pattern_in EXPORT_OF ""
set_interface_property data_pattern_checker_pattern_in PORT_NAME_MAP ""
set_interface_property data_pattern_checker_pattern_in CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_pattern_in SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_pattern_in data_pattern_checker_pattern_in export Input 64


# 
# connection point data_pattern_checker_pattern_in_clk
# 
add_interface data_pattern_checker_pattern_in_clk conduit end
set_interface_property data_pattern_checker_pattern_in_clk associatedClock ""
set_interface_property data_pattern_checker_pattern_in_clk associatedReset ""
set_interface_property data_pattern_checker_pattern_in_clk ENABLED true
set_interface_property data_pattern_checker_pattern_in_clk EXPORT_OF ""
set_interface_property data_pattern_checker_pattern_in_clk PORT_NAME_MAP ""
set_interface_property data_pattern_checker_pattern_in_clk CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_pattern_in_clk SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_pattern_in_clk data_pattern_checker_pattern_in_clk export Input 1


# 
# connection point data_pattern_checker_pattern_in_fifo_read
# 
add_interface data_pattern_checker_pattern_in_fifo_read conduit end
set_interface_property data_pattern_checker_pattern_in_fifo_read associatedClock ""
set_interface_property data_pattern_checker_pattern_in_fifo_read associatedReset ""
set_interface_property data_pattern_checker_pattern_in_fifo_read ENABLED true
set_interface_property data_pattern_checker_pattern_in_fifo_read EXPORT_OF ""
set_interface_property data_pattern_checker_pattern_in_fifo_read PORT_NAME_MAP ""
set_interface_property data_pattern_checker_pattern_in_fifo_read CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_pattern_in_fifo_read SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_pattern_in_fifo_read data_pattern_checker_pattern_in_fifo_read export Output 128


# 
# connection point data_pattern_checker_pattern_in_fifo_read_clk
# 
add_interface data_pattern_checker_pattern_in_fifo_read_clk conduit end
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk associatedClock ""
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk associatedReset ""
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk ENABLED true
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk EXPORT_OF ""
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk PORT_NAME_MAP ""
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_pattern_in_fifo_read_clk SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_pattern_in_fifo_read_clk data_pattern_checker_pattern_in_fifo_read_clk export Input 1


# 
# connection point data_pattern_checker_rx_fifo_rdempty
# 
add_interface data_pattern_checker_rx_fifo_rdempty conduit end
set_interface_property data_pattern_checker_rx_fifo_rdempty associatedClock ""
set_interface_property data_pattern_checker_rx_fifo_rdempty associatedReset ""
set_interface_property data_pattern_checker_rx_fifo_rdempty ENABLED true
set_interface_property data_pattern_checker_rx_fifo_rdempty EXPORT_OF ""
set_interface_property data_pattern_checker_rx_fifo_rdempty PORT_NAME_MAP ""
set_interface_property data_pattern_checker_rx_fifo_rdempty CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_rx_fifo_rdempty SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_rx_fifo_rdempty data_pattern_checker_rx_fifo_rdempty export Output 1


# 
# connection point data_pattern_checker_rx_fifo_wrfull
# 
add_interface data_pattern_checker_rx_fifo_wrfull conduit end
set_interface_property data_pattern_checker_rx_fifo_wrfull associatedClock ""
set_interface_property data_pattern_checker_rx_fifo_wrfull associatedReset ""
set_interface_property data_pattern_checker_rx_fifo_wrfull ENABLED true
set_interface_property data_pattern_checker_rx_fifo_wrfull EXPORT_OF ""
set_interface_property data_pattern_checker_rx_fifo_wrfull PORT_NAME_MAP ""
set_interface_property data_pattern_checker_rx_fifo_wrfull CMSIS_SVD_VARIABLES ""
set_interface_property data_pattern_checker_rx_fifo_wrfull SVD_ADDRESS_GROUP ""

add_interface_port data_pattern_checker_rx_fifo_wrfull data_pattern_checker_rx_fifo_wrfull export Output 1


# 
# connection point fifo_input
# 
add_interface fifo_input conduit end
set_interface_property fifo_input associatedClock ""
set_interface_property fifo_input associatedReset ""
set_interface_property fifo_input ENABLED true
set_interface_property fifo_input EXPORT_OF ""
set_interface_property fifo_input PORT_NAME_MAP ""
set_interface_property fifo_input CMSIS_SVD_VARIABLES ""
set_interface_property fifo_input SVD_ADDRESS_GROUP ""

add_interface_port fifo_input data datain Output 64
add_interface_port fifo_input wrreq wrreq Output 1
add_interface_port fifo_input rdreq rdreq Output 1
add_interface_port fifo_input wrclk wrclk Output 1
add_interface_port fifo_input rdclk rdclk Output 1


# 
# connection point fifo_output
# 
add_interface fifo_output conduit end
set_interface_property fifo_output associatedClock ""
set_interface_property fifo_output associatedReset ""
set_interface_property fifo_output ENABLED true
set_interface_property fifo_output EXPORT_OF ""
set_interface_property fifo_output PORT_NAME_MAP ""
set_interface_property fifo_output CMSIS_SVD_VARIABLES ""
set_interface_property fifo_output SVD_ADDRESS_GROUP ""

add_interface_port fifo_output q dataout Input 128
add_interface_port fifo_output rdempty rdempty Input 1
add_interface_port fifo_output wrfull wrfull Input 1

