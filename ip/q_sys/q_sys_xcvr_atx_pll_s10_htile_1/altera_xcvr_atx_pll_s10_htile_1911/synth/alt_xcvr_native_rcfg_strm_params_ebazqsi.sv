// Parameters for embedded reconfiguration streamer

package alt_xcvr_native_rcfg_strm_params_ebazqsi;

  localparam rom_data_width = 27; // ROM data width 
  localparam rom_depth = 18; // Depth of reconfiguration rom
  localparam rcfg_cfg_depths = "6,6,6"; // Depths of individual configuration profiles in rom

  // Reconfiguration rom containing all profiles in order
  localparam reg [26:0] config_rom [0:17] = '{
    27'h001021F0C,
    27'h001054000,
    27'h001080701,
    27'h00109FF08,
    27'h0011B2020,
    27'h007FFFFFF,
    27'h001021F15,
    27'h001054040,
    27'h001080700,
    27'h00109FF0A,
    27'h0011B2000,
    27'h007FFFFFF,
    27'h001021F0D,
    27'h001054000,
    27'h001080701,
    27'h00109FF08,
    27'h0011B2020,
    27'h007FFFFFF
  };
endpackage