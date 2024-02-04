source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_pll_status_interconnect_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_master_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_clk_100/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_pll_status_interconnect_2/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../qsfp_xcvr_test/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_clk_50/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_pll_status_interconnect_4/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_2/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_clock_bridge_1/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../sdi_xcvr_test/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_1/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_product_info_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/q_sys/q_sys_clock_bridge_0/sim/common/vcs_files.tcl]

namespace eval q_sys {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    set memory_files [concat $memory_files [q_sys_pll_status_interconnect_0::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_0/sim/"]]
    set memory_files [concat $memory_files [q_sys_master_0::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_master_0/sim/"]]
    set memory_files [concat $memory_files [q_sys_clk_100::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_100/sim/"]]
    set memory_files [concat $memory_files [q_sys_pll_status_interconnect_2::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_2/sim/"]]
    set memory_files [concat $memory_files [qsfp_xcvr_test::get_memory_files "$QSYS_SIMDIR/../../qsfp_xcvr_test/sim/"]]
    set memory_files [concat $memory_files [q_sys_clk_50::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_50/sim/"]]
    set memory_files [concat $memory_files [q_sys_pll_status_interconnect_4::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_4/sim/"]]
    set memory_files [concat $memory_files [q_sys_xcvr_atx_pll_s10_htile_2::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_2/sim/"]]
    set memory_files [concat $memory_files [q_sys_clock_bridge_1::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_1/sim/"]]
    set memory_files [concat $memory_files [sdi_xcvr_test::get_memory_files "$QSYS_SIMDIR/../../sdi_xcvr_test/sim/"]]
    set memory_files [concat $memory_files [q_sys_xcvr_atx_pll_s10_htile_1::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_1/sim/"]]
    set memory_files [concat $memory_files [q_sys_xcvr_atx_pll_s10_htile_0::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_0/sim/"]]
    set memory_files [concat $memory_files [q_sys_product_info_0::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_product_info_0/sim/"]]
    set memory_files [concat $memory_files [q_sys_clock_bridge_0::get_memory_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_0/sim/"]]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_0::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_master_0::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_master_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_clk_100::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_100/sim/"]]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_2::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_2/sim/"]]
    set design_files [dict merge $design_files [qsfp_xcvr_test::get_common_design_files "$QSYS_SIMDIR/../../qsfp_xcvr_test/sim/"]]
    set design_files [dict merge $design_files [q_sys_clk_50::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_50/sim/"]]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_4::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_4/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_2::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_2/sim/"]]
    set design_files [dict merge $design_files [q_sys_clock_bridge_1::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_1/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test::get_common_design_files "$QSYS_SIMDIR/../../sdi_xcvr_test/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_1::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_1/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_0::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_product_info_0::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_product_info_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_clock_bridge_0::get_common_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_0/sim/"]]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_0::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_master_0::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_master_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_clk_100::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_100/sim/"]]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_2::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_2/sim/"]]
    set design_files [dict merge $design_files [qsfp_xcvr_test::get_design_files "$QSYS_SIMDIR/../../qsfp_xcvr_test/sim/"]]
    set design_files [dict merge $design_files [q_sys_clk_50::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_50/sim/"]]
    set design_files [dict merge $design_files [q_sys_pll_status_interconnect_4::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_4/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_2::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_2/sim/"]]
    set design_files [dict merge $design_files [q_sys_clock_bridge_1::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_1/sim/"]]
    set design_files [dict merge $design_files [sdi_xcvr_test::get_design_files "$QSYS_SIMDIR/../../sdi_xcvr_test/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_1::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_1/sim/"]]
    set design_files [dict merge $design_files [q_sys_xcvr_atx_pll_s10_htile_0::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_product_info_0::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_product_info_0/sim/"]]
    set design_files [dict merge $design_files [q_sys_clock_bridge_0::get_design_files "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_0/sim/"]]
    dict set design_files "q_sys_altera_merlin_master_translator_192_lykd4la.sv"                    "$QSYS_SIMDIR/../altera_merlin_master_translator_192/sim/q_sys_altera_merlin_master_translator_192_lykd4la.sv"                 
    dict set design_files "q_sys_altera_merlin_slave_translator_191_x56fcki.sv"                     "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/q_sys_altera_merlin_slave_translator_191_x56fcki.sv"                   
    dict set design_files "q_sys_altera_merlin_master_agent_1921_2inlndi.sv"                        "$QSYS_SIMDIR/../altera_merlin_master_agent_1921/sim/q_sys_altera_merlin_master_agent_1921_2inlndi.sv"                         
    dict set design_files "q_sys_altera_merlin_slave_agent_1921_b6r3djy.sv"                         "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/q_sys_altera_merlin_slave_agent_1921_b6r3djy.sv"                           
    dict set design_files "altera_merlin_burst_uncompressor.sv"                                     "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/altera_merlin_burst_uncompressor.sv"                                       
    dict set design_files "q_sys_altera_avalon_sc_fifo_1931_fzgstwy.v"                              "$QSYS_SIMDIR/../altera_avalon_sc_fifo_1931/sim/q_sys_altera_avalon_sc_fifo_1931_fzgstwy.v"                                    
    dict set design_files "q_sys_altera_merlin_router_1921_lnketcy.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/q_sys_altera_merlin_router_1921_lnketcy.sv"                                     
    dict set design_files "q_sys_altera_merlin_router_1921_ww4g4ya.sv"                              "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/q_sys_altera_merlin_router_1921_ww4g4ya.sv"                                     
    dict set design_files "q_sys_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_191_blu76ua.v" "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/q_sys_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_191_blu76ua.v"
    dict set design_files "altera_merlin_reorder_memory.sv"                                         "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_merlin_reorder_memory.sv"                                        
    dict set design_files "altera_avalon_st_pipeline_base.v"                                        "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/altera_avalon_st_pipeline_base.v"                                       
    dict set design_files "q_sys_altera_merlin_traffic_limiter_191_kcba44q.sv"                      "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_191/sim/q_sys_altera_merlin_traffic_limiter_191_kcba44q.sv"                     
    dict set design_files "q_sys_altera_merlin_demultiplexer_1921_tbc4z7i.sv"                       "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/q_sys_altera_merlin_demultiplexer_1921_tbc4z7i.sv"                       
    dict set design_files "q_sys_altera_merlin_multiplexer_1922_2wwphby.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/q_sys_altera_merlin_multiplexer_1922_2wwphby.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                             "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                               
    dict set design_files "q_sys_altera_merlin_demultiplexer_1921_457fupy.sv"                       "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/q_sys_altera_merlin_demultiplexer_1921_457fupy.sv"                       
    dict set design_files "q_sys_altera_merlin_multiplexer_1922_veanixq.sv"                         "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/q_sys_altera_merlin_multiplexer_1922_veanixq.sv"                           
    dict set design_files "altera_merlin_arbitrator.sv"                                             "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                               
    dict set design_files "q_sys_hs_clk_xer_1940_suurwgi.v"                                         "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/q_sys_hs_clk_xer_1940_suurwgi.v"                                                          
    dict set design_files "altera_reset_synchronizer.v"                                             "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_reset_synchronizer.v"                                                              
    dict set design_files "altera_avalon_st_clock_crosser.v"                                        "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_avalon_st_clock_crosser.v"                                                         
    dict set design_files "altera_avalon_st_pipeline_base.v"                                        "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_avalon_st_pipeline_base.v"                                                         
    dict set design_files "altera_std_synchronizer_nocut.v"                                         "$QSYS_SIMDIR/../hs_clk_xer_1940/sim/altera_std_synchronizer_nocut.v"                                                          
    dict set design_files "q_sys_altera_avalon_st_pipeline_stage_1930_bv2ucky.sv"                   "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/q_sys_altera_avalon_st_pipeline_stage_1930_bv2ucky.sv"               
    dict set design_files "altera_avalon_st_pipeline_base.v"                                        "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/altera_avalon_st_pipeline_base.v"                                    
    dict set design_files "q_sys_altera_mm_interconnect_1920_57nh4yy.v"                             "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/q_sys_altera_mm_interconnect_1920_57nh4yy.v"                                  
    dict set design_files "q_sys.v"                                                                 "$QSYS_SIMDIR/q_sys.v"                                                                                                         
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    append ELAB_OPTIONS [q_sys_pll_status_interconnect_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_master_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_clk_100::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_pll_status_interconnect_2::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsfp_xcvr_test::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_clk_50::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_pll_status_interconnect_4::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_2::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_clock_bridge_1::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [sdi_xcvr_test::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_1::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_product_info_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [q_sys_clock_bridge_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    append SIM_OPTIONS [q_sys_pll_status_interconnect_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_master_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_clk_100::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_pll_status_interconnect_2::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsfp_xcvr_test::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_clk_50::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_pll_status_interconnect_4::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_2::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_clock_bridge_1::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [sdi_xcvr_test::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_1::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_xcvr_atx_pll_s10_htile_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_product_info_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [q_sys_clock_bridge_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_pll_status_interconnect_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_master_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_clk_100::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_pll_status_interconnect_2::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsfp_xcvr_test::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_clk_50::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_pll_status_interconnect_4::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_xcvr_atx_pll_s10_htile_2::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_clock_bridge_1::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [sdi_xcvr_test::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_xcvr_atx_pll_s10_htile_1::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_xcvr_atx_pll_s10_htile_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_product_info_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [q_sys_clock_bridge_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    set libraries [dict merge $libraries [q_sys_pll_status_interconnect_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_0/sim/"]]
    set libraries [dict merge $libraries [q_sys_master_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_master_0/sim/"]]
    set libraries [dict merge $libraries [q_sys_clk_100::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_100/sim/"]]
    set libraries [dict merge $libraries [q_sys_pll_status_interconnect_2::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_2/sim/"]]
    set libraries [dict merge $libraries [qsfp_xcvr_test::get_dpi_libraries "$QSYS_SIMDIR/../../qsfp_xcvr_test/sim/"]]
    set libraries [dict merge $libraries [q_sys_clk_50::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clk_50/sim/"]]
    set libraries [dict merge $libraries [q_sys_pll_status_interconnect_4::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_pll_status_interconnect_4/sim/"]]
    set libraries [dict merge $libraries [q_sys_xcvr_atx_pll_s10_htile_2::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_2/sim/"]]
    set libraries [dict merge $libraries [q_sys_clock_bridge_1::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_1/sim/"]]
    set libraries [dict merge $libraries [sdi_xcvr_test::get_dpi_libraries "$QSYS_SIMDIR/../../sdi_xcvr_test/sim/"]]
    set libraries [dict merge $libraries [q_sys_xcvr_atx_pll_s10_htile_1::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_1/sim/"]]
    set libraries [dict merge $libraries [q_sys_xcvr_atx_pll_s10_htile_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_xcvr_atx_pll_s10_htile_0/sim/"]]
    set libraries [dict merge $libraries [q_sys_product_info_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_product_info_0/sim/"]]
    set libraries [dict merge $libraries [q_sys_clock_bridge_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/q_sys/q_sys_clock_bridge_0/sim/"]]
    
    return $libraries
  }
  
}
