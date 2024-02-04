source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_clk_50/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_data_pattern_checker_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_data_pattern_generator_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_tx_fifo_converter_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_tx_fifo/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_rx_fifo_converter_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_rx_fifo/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_freq_counter_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_mm_bridge_0/sim/common/modelsim_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/xcvr_test_system/xcvr_test_system_xcvr_tx_rx_clkout2_converter_0/sim/common/modelsim_files.tcl]

namespace eval xcvr_test_system {
  proc get_design_libraries {} {
    set libraries [dict create]
    set libraries [dict merge $libraries [xcvr_test_system_clk_50::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_data_pattern_checker_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_data_pattern_generator_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_tx_fifo::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_rx_fifo::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_freq_counter_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_mm_bridge_0::get_design_libraries]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_design_libraries]]
    dict set libraries altera_merlin_master_translator_192  1
    dict set libraries altera_merlin_slave_translator_191   1
    dict set libraries altera_merlin_master_agent_1921      1
    dict set libraries altera_merlin_slave_agent_1921       1
    dict set libraries altera_avalon_sc_fifo_1931           1
    dict set libraries altera_merlin_router_1921            1
    dict set libraries altera_merlin_traffic_limiter_191    1
    dict set libraries altera_merlin_demultiplexer_1921     1
    dict set libraries altera_merlin_multiplexer_1922       1
    dict set libraries altera_avalon_st_pipeline_stage_1930 1
    dict set libraries altera_mm_interconnect_1920          1
    dict set libraries altera_reset_controller_1922         1
    dict set libraries xcvr_test_system                     1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    set memory_files [concat $memory_files [xcvr_test_system_clk_50::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_clk_50/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_data_pattern_checker_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_checker_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_data_pattern_generator_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_generator_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_tx_fifo_converter_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_tx_fifo::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_tx_fifo/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_rx_fifo_converter_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_rx_fifo::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_rx_fifo/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_freq_counter_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_freq_counter_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_mm_bridge_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_mm_bridge_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_memory_files "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_tx_rx_clkout2_converter_0/sim/"]]
    return $memory_files
  }
  
  proc get_common_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [xcvr_test_system_clk_50::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_clk_50/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_data_pattern_checker_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_checker_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_data_pattern_generator_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_generator_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_tx_fifo_converter_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_tx_fifo::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_tx_fifo/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_rx_fifo_converter_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_rx_fifo::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_rx_fifo/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_freq_counter_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_freq_counter_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_mm_bridge_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_mm_bridge_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_tx_rx_clkout2_converter_0/sim/"]]
    return $design_files
  }
  
  proc get_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [list]
    set design_files [concat $design_files [xcvr_test_system_clk_50::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_clk_50/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_data_pattern_checker_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_checker_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_data_pattern_generator_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_generator_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_tx_fifo_converter_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_tx_fifo::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_tx_fifo/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_rx_fifo_converter_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_rx_fifo::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_rx_fifo/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_freq_counter_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_freq_counter_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_mm_bridge_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_mm_bridge_0/sim/"]]
    set design_files [concat $design_files [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_tx_rx_clkout2_converter_0/sim/"]]
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_master_translator_192/sim/xcvr_test_system_altera_merlin_master_translator_192_lykd4la.sv"]\"  -work altera_merlin_master_translator_192"           
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/xcvr_test_system_altera_merlin_slave_translator_191_x56fcki.sv"]\"  -work altera_merlin_slave_translator_191"              
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_master_agent_1921/sim/xcvr_test_system_altera_merlin_master_agent_1921_2inlndi.sv"]\"  -work altera_merlin_master_agent_1921"                       
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/xcvr_test_system_altera_merlin_slave_agent_1921_b6r3djy.sv"]\"  -work altera_merlin_slave_agent_1921"                          
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/altera_merlin_burst_uncompressor.sv"]\"  -work altera_merlin_slave_agent_1921"                                                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_sc_fifo_1931/sim/xcvr_test_system_altera_avalon_sc_fifo_1931_fzgstwy.v"]\"  -work altera_avalon_sc_fifo_1931"                                           
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/xcvr_test_system_altera_merlin_router_1921_rvqh52q.sv"]\"  -work altera_merlin_router_1921"                                         
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/xcvr_test_system_altera_merlin_router_1921_22lk4la.sv"]\"  -work altera_merlin_router_1921"                                         
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/xcvr_test_system_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_191_dvli2oa.v"]\"  -work altera_merlin_traffic_limiter_191"
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_merlin_reorder_memory.sv"]\"  -work altera_merlin_traffic_limiter_191"                                               
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_avalon_st_pipeline_base.v"]\"  -work altera_merlin_traffic_limiter_191"                                              
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/xcvr_test_system_altera_merlin_traffic_limiter_191_kcba44q.sv"]\"  -work altera_merlin_traffic_limiter_191"                 
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/xcvr_test_system_altera_merlin_demultiplexer_1921_gaw4kza.sv"]\"  -work altera_merlin_demultiplexer_1921"                    
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/xcvr_test_system_altera_merlin_multiplexer_1922_caxee3y.sv"]\"  -work altera_merlin_multiplexer_1922"                          
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"]\"  -work altera_merlin_multiplexer_1922"                                                         
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/xcvr_test_system_altera_merlin_demultiplexer_1921_7oucsfq.sv"]\"  -work altera_merlin_demultiplexer_1921"                    
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/xcvr_test_system_altera_merlin_multiplexer_1922_fin6qia.sv"]\"  -work altera_merlin_multiplexer_1922"                          
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"]\"  -work altera_merlin_multiplexer_1922"                                                         
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/xcvr_test_system_altera_avalon_st_pipeline_stage_1930_bv2ucky.sv"]\"  -work altera_avalon_st_pipeline_stage_1930"        
    lappend design_files "vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/altera_avalon_st_pipeline_base.v"]\"  -work altera_avalon_st_pipeline_stage_1930"                                        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/xcvr_test_system_altera_mm_interconnect_1920_zd6ql4a.v"]\"  -work altera_mm_interconnect_1920"                                        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_controller.v"]\"  -work altera_reset_controller_1922"                                                                   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_synchronizer.v"]\"  -work altera_reset_controller_1922"                                                                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/xcvr_test_system.v"]\"  -work xcvr_test_system"                                                                                                                          
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    append ELAB_OPTIONS [xcvr_test_system_clk_50::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_data_pattern_checker_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_data_pattern_generator_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_tx_fifo::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_rx_fifo::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_freq_counter_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_mm_bridge_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    append SIM_OPTIONS [xcvr_test_system_clk_50::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_data_pattern_checker_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_data_pattern_generator_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_tx_fifo::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_rx_fifo::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_freq_counter_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_mm_bridge_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_clk_50::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_data_pattern_checker_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_data_pattern_generator_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_tx_fifo::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_rx_fifo::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_freq_counter_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_mm_bridge_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    set libraries [dict merge $libraries [xcvr_test_system_clk_50::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_clk_50/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_data_pattern_checker_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_checker_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_data_pattern_generator_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_data_pattern_generator_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_user_tx_fifo_converter_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_tx_fifo_converter_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_tx_fifo::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_tx_fifo/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_user_rx_fifo_converter_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_user_rx_fifo_converter_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_rx_fifo::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_rx_fifo/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_freq_counter_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_freq_counter_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_mm_bridge_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_mm_bridge_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system_xcvr_tx_rx_clkout2_converter_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/xcvr_test_system/xcvr_test_system_xcvr_tx_rx_clkout2_converter_0/sim/"]]
    
    return $libraries
  }
  
}
