source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_default_pma_settings_conf_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../xcvr_test_system/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_nativePHY_loopback_cont_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_mm_bridge_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_pll_status_interconnect_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_st_converter_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_100/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_50/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_reset_control_s10_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_native_s10_htile_0/sim/common/vcs_files.tcl]

namespace eval sdi_xcvr_test {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    set memory_files [concat $memory_files [sdi_xcvr_test_default_pma_settings_conf_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_default_pma_settings_conf_0/sim/"]]
    set memory_files [concat $memory_files [xcvr_test_system::get_memory_files "$QSYS_SIMDIR/../../xcvr_test_system/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_nativePHY_loopback_cont_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_nativePHY_loopback_cont_0/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_mm_bridge_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_mm_bridge_0/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_pll_status_interconnect_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_pll_status_interconnect_0/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_xcvr_st_converter_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_st_converter_0/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_clk_100::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_100/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_clk_50::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_50/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_xcvr_reset_control_s10_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_reset_control_s10_0/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test_xcvr_native_s10_htile_0::get_memory_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_native_s10_htile_0/sim/"]]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [sdi_xcvr_test_default_pma_settings_conf_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_default_pma_settings_conf_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system::get_common_design_files "$QSYS_SIMDIR/../../xcvr_test_system/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_nativePHY_loopback_cont_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_nativePHY_loopback_cont_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_mm_bridge_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_mm_bridge_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_pll_status_interconnect_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_pll_status_interconnect_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_st_converter_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_st_converter_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_clk_100::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_100/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_clk_50::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_50/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_reset_control_s10_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_reset_control_s10_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_native_s10_htile_0::get_common_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_native_s10_htile_0/sim/"]]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [sdi_xcvr_test_default_pma_settings_conf_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_default_pma_settings_conf_0/sim/"]]
    set design_files [dict merge $design_files [xcvr_test_system::get_design_files "$QSYS_SIMDIR/../../xcvr_test_system/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_nativePHY_loopback_cont_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_nativePHY_loopback_cont_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_mm_bridge_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_mm_bridge_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_pll_status_interconnect_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_pll_status_interconnect_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_st_converter_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_st_converter_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_clk_100::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_100/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_clk_50::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_50/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_reset_control_s10_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_reset_control_s10_0/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test_xcvr_native_s10_htile_0::get_design_files "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_native_s10_htile_0/sim/"]]
    dict set design_files "sdi_xcvr_test_altera_merlin_master_translator_192_lykd4la.sv"                    "$QSYS_SIMDIR/../altera_merlin_master_translator_192/sim/sdi_xcvr_test_altera_merlin_master_translator_192_lykd4la.sv"                 
    dict set design_files "sdi_xcvr_test_altera_merlin_slave_translator_191_x56fcki.sv"                     "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/sdi_xcvr_test_altera_merlin_slave_translator_191_x56fcki.sv"                   
    dict set design_files "sdi_xcvr_test_altera_merlin_master_agent_1921_2inlndi.sv"                        "$QSYS_SIMDIR/../altera_merlin_master_agent_1921/sim/sdi_xcvr_test_altera_merlin_master_agent_1921_2inlndi.sv"                         
    dict set design_files "sdi_xcvr_test_altera_merlin_slave_agent_1921_b6r3djy.sv"                         "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/sdi_xcvr_test_altera_merlin_slave_agent_1921_b6r3djy.sv"                           
    dict set design_files "altera_merlin_burst_uncompressor.sv"                                             "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/altera_merlin_burst_uncompressor.sv"                                               
    dict set design_files "sdi_xcvr_test_altera_avalon_sc_fifo_1931_fzgstwy.v"                              "$QSYS_SIMDIR/../altera_avalon_sc_fifo_1931/sim/sdi_xcvr_test_altera_avalon_sc_fifo_1931_fzgstwy.v"                                    
    dict set design_files "sdi_xcvr_test_altera_merlin_router_1921_ylon4vq.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/sdi_xcvr_test_altera_merlin_router_1921_ylon4vq.sv"                                     
    dict set design_files "sdi_xcvr_test_altera_merlin_router_1921_cwjx5gy.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/sdi_xcvr_test_altera_merlin_router_1921_cwjx5gy.sv"                                     
    dict set design_files "sdi_xcvr_test_altera_merlin_router_1921_ya7j6xi.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/sdi_xcvr_test_altera_merlin_router_1921_ya7j6xi.sv"                                     
    dict set design_files "sdi_xcvr_test_altera_merlin_router_1921_7loa6ei.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/sdi_xcvr_test_altera_merlin_router_1921_7loa6ei.sv"                                     
    dict set design_files "sdi_xcvr_test_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_191_7trhvuy.v" "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/sdi_xcvr_test_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_191_7trhvuy.v"
    dict set design_files "altera_merlin_reorder_memory.sv"                                                 "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_merlin_reorder_memory.sv"                                                
    dict set design_files "altera_avalon_st_pipeline_base.v"                                                "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_avalon_st_pipeline_base.v"                                               
    dict set design_files "sdi_xcvr_test_altera_merlin_traffic_limiter_191_kcba44q.sv"                      "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/sdi_xcvr_test_altera_merlin_traffic_limiter_191_kcba44q.sv"                     
    dict set design_files "sdi_xcvr_test_altera_merlin_demultiplexer_1921_tpjuufq.sv"                       "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/sdi_xcvr_test_altera_merlin_demultiplexer_1921_tpjuufq.sv"                       
    dict set design_files "sdi_xcvr_test_altera_merlin_demultiplexer_1921_hidmfdy.sv"                       "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/sdi_xcvr_test_altera_merlin_demultiplexer_1921_hidmfdy.sv"                       
    dict set design_files "sdi_xcvr_test_altera_merlin_multiplexer_1922_sx4fypi.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/sdi_xcvr_test_altera_merlin_multiplexer_1922_sx4fypi.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                                     "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                       
    dict set design_files "sdi_xcvr_test_altera_merlin_multiplexer_1922_f3ke5za.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/sdi_xcvr_test_altera_merlin_multiplexer_1922_f3ke5za.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                                     "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                       
    dict set design_files "sdi_xcvr_test_altera_merlin_demultiplexer_1921_vsc72dq.sv"                       "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/sdi_xcvr_test_altera_merlin_demultiplexer_1921_vsc72dq.sv"                       
    dict set design_files "sdi_xcvr_test_altera_merlin_multiplexer_1922_o5h777y.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/sdi_xcvr_test_altera_merlin_multiplexer_1922_o5h777y.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                                     "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                       
    dict set design_files "sdi_xcvr_test_altera_merlin_multiplexer_1922_6c6ivwy.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/sdi_xcvr_test_altera_merlin_multiplexer_1922_6c6ivwy.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                                     "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                       
    dict set design_files "sdi_xcvr_test_hs_clk_xer_1940_gyeivji.v"                                         "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/sdi_xcvr_test_hs_clk_xer_1940_gyeivji.v"                                                          
    dict set design_files "altera_reset_synchronizer.v"                                                     "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_reset_synchronizer.v"                                                                      
    dict set design_files "altera_avalon_st_clock_crosser.v"                                                "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_avalon_st_clock_crosser.v"                                                                 
    dict set design_files "altera_avalon_st_pipeline_base.v"                                                "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_avalon_st_pipeline_base.v"                                                                 
    dict set design_files "altera_std_synchronizer_nocut.v"                                                 "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_std_synchronizer_nocut.v"                                                                  
    dict set design_files "sdi_xcvr_test_altera_mm_interconnect_1920_4ix6v3i.v"                             "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/sdi_xcvr_test_altera_mm_interconnect_1920_4ix6v3i.v"                                  
    dict set design_files "altera_reset_controller.v"                                                       "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_controller.v"                                                           
    dict set design_files "altera_reset_synchronizer.v"                                                     "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_synchronizer.v"                                                         
    dict set design_files "sdi_xcvr_test.v"                                                                 "$QSYS_SIMDIR/sdi_xcvr_test.v"                                                                                                         
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    append ELAB_OPTIONS [sdi_xcvr_test_default_pma_settings_conf_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [xcvr_test_system::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_nativePHY_loopback_cont_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_mm_bridge_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_pll_status_interconnect_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_xcvr_st_converter_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_clk_100::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_clk_50::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_xcvr_reset_control_s10_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test_xcvr_native_s10_htile_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    append SIM_OPTIONS [sdi_xcvr_test_default_pma_settings_conf_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [xcvr_test_system::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_nativePHY_loopback_cont_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_mm_bridge_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_pll_status_interconnect_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_xcvr_st_converter_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_clk_100::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_clk_50::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_xcvr_reset_control_s10_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test_xcvr_native_s10_htile_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_default_pma_settings_conf_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [xcvr_test_system::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_nativePHY_loopback_cont_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_mm_bridge_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_pll_status_interconnect_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_xcvr_st_converter_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_clk_100::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_clk_50::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_xcvr_reset_control_s10_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test_xcvr_native_s10_htile_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    set libraries [dict merge $libraries [sdi_xcvr_test_default_pma_settings_conf_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_default_pma_settings_conf_0/sim/"]]
    set libraries [dict merge $libraries [xcvr_test_system::get_dpi_libraries "$QSYS_SIMDIR/../../xcvr_test_system/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_nativePHY_loopback_cont_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_nativePHY_loopback_cont_0/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_mm_bridge_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_mm_bridge_0/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_pll_status_interconnect_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_pll_status_interconnect_0/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_xcvr_st_converter_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_st_converter_0/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_clk_100::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_100/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_clk_50::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_clk_50/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_xcvr_reset_control_s10_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_reset_control_s10_0/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test_xcvr_native_s10_htile_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/sdi_xcvr_test/sdi_xcvr_test_xcvr_native_s10_htile_0/sim/"]]
    
    return $libraries
  }
  
}
