module q_sys_xcvr_atx_pll_s10_htile_1 (
		input  wire        pll_refclk0,           //       pll_refclk0.clk
		output wire        tx_serial_clk,         //     tx_serial_clk.clk
		output wire        tx_serial_clk_gxt,     // tx_serial_clk_gxt.clk
		output wire        pll_locked,            //        pll_locked.pll_locked
		input  wire        reconfig_clk0,         //     reconfig_clk0.clk
		input  wire        reconfig_reset0,       //   reconfig_reset0.reset
		input  wire        reconfig_write0,       //    reconfig_avmm0.write
		input  wire        reconfig_read0,        //                  .read
		input  wire [10:0] reconfig_address0,     //                  .address
		input  wire [31:0] reconfig_writedata0,   //                  .writedata
		output wire [31:0] reconfig_readdata0,    //                  .readdata
		output wire        reconfig_waitrequest0, //                  .waitrequest
		output wire        pll_cal_busy           //      pll_cal_busy.pll_cal_busy
	);
endmodule

