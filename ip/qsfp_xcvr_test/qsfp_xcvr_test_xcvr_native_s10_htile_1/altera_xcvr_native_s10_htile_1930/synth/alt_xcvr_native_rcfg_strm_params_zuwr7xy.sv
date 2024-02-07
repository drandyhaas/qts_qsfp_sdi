// Parameters for embedded reconfiguration streamer

package alt_xcvr_native_rcfg_strm_params_zuwr7xy;

  localparam rom_data_width = 27; // ROM data width 
  localparam rom_depth = 90; // Depth of reconfiguration rom
  localparam rcfg_cfg_depths = "30,30,30"; // Depths of individual configuration profiles in rom

  // Reconfiguration rom containing all profiles in order
  localparam reg [26:0] config_rom [0:89] = '{
    27'h001060800,
    27'h001082020,
    27'h0011AFF44,
    27'h0011EA020,
    27'h0011F7110,
    27'h001213030,
    27'h0012D2000,
    27'h0012EF050,
    27'h00130C040,
    27'h001320F05,
    27'h001350302,
    27'h001360F0C,
    27'h001373C08,
    27'h001390702,
    27'h0013A3818,
    27'h0013BFF10,
    27'h001448080,
    27'h001458080,
    27'h001518080,
    27'h00154C000,
    27'h00159FF95,
    27'h001600F0B,
    27'h001623000,
    27'h001651E0E,
    27'h001670301,
    27'h0022E0404,
    27'h002301800,
    27'h0032C0404,
    27'h0032E1800,
    27'h007FFFFFF,
    27'h001060808,
    27'h001082000,
    27'h0011AFFC0,
    27'h0011EA080,
    27'h0011F7171,
    27'h001213020,
    27'h0012D2020,
    27'h0012EF0F0,
    27'h00130C000,
    27'h001320F07,
    27'h001350303,
    27'h001360F08,
    27'h001373C00,
    27'h001390701,
    27'h0013A3808,
    27'h0013BFF14,
    27'h001448000,
    27'h001458000,
    27'h001518000,
    27'h00154C040,
    27'h00159FF95,
    27'h001600F0C,
    27'h001623020,
    27'h001651E18,
    27'h001670303,
    27'h0022E0400,
    27'h002301818,
    27'h0032C0400,
    27'h0032E1818,
    27'h007FFFFFF,
    27'h001060800,
    27'h001082020,
    27'h0011AFF44,
    27'h0011EA020,
    27'h0011F7110,
    27'h001213030,
    27'h0012D2000,
    27'h0012EF050,
    27'h00130C040,
    27'h001320F05,
    27'h001350302,
    27'h001360F00,
    27'h001373C08,
    27'h001390702,
    27'h0013A3818,
    27'h0013BFF10,
    27'h001448080,
    27'h001458080,
    27'h001518080,
    27'h00154C000,
    27'h00159FF8D,
    27'h001600F0B,
    27'h001623000,
    27'h001651E0E,
    27'h001670301,
    27'h0022E0404,
    27'h002301800,
    27'h0032C0404,
    27'h0032E1800,
    27'h007FFFFFF
  };
endpackage