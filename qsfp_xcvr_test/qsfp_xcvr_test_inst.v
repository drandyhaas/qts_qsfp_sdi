	qsfp_xcvr_test u0 (
		.clk_100_clk                                     (_connected_to_clk_100_clk_),                                     //   input,   width = 1,                          clk_100.clk
		.reset_100_reset_n                               (_connected_to_reset_100_reset_n_),                               //   input,   width = 1,                        reset_100.reset_n
		.clk_50_clk                                      (_connected_to_clk_50_clk_),                                      //   input,   width = 1,                           clk_50.clk
		.reset_50_reset_n                                (_connected_to_reset_50_reset_n_),                                //   input,   width = 1,                         reset_50.reset_n
		.mm_bridge_0_s0_waitrequest                      (_connected_to_mm_bridge_0_s0_waitrequest_),                      //  output,   width = 1,                   mm_bridge_0_s0.waitrequest
		.mm_bridge_0_s0_readdata                         (_connected_to_mm_bridge_0_s0_readdata_),                         //  output,  width = 32,                                 .readdata
		.mm_bridge_0_s0_readdatavalid                    (_connected_to_mm_bridge_0_s0_readdatavalid_),                    //  output,   width = 1,                                 .readdatavalid
		.mm_bridge_0_s0_burstcount                       (_connected_to_mm_bridge_0_s0_burstcount_),                       //   input,   width = 1,                                 .burstcount
		.mm_bridge_0_s0_writedata                        (_connected_to_mm_bridge_0_s0_writedata_),                        //   input,  width = 32,                                 .writedata
		.mm_bridge_0_s0_address                          (_connected_to_mm_bridge_0_s0_address_),                          //   input,  width = 15,                                 .address
		.mm_bridge_0_s0_write                            (_connected_to_mm_bridge_0_s0_write_),                            //   input,   width = 1,                                 .write
		.mm_bridge_0_s0_read                             (_connected_to_mm_bridge_0_s0_read_),                             //   input,   width = 1,                                 .read
		.mm_bridge_0_s0_byteenable                       (_connected_to_mm_bridge_0_s0_byteenable_),                       //   input,   width = 4,                                 .byteenable
		.mm_bridge_0_s0_debugaccess                      (_connected_to_mm_bridge_0_s0_debugaccess_),                      //   input,   width = 1,                                 .debugaccess
		.pll_locked_pll_locked_pll_locked                (_connected_to_pll_locked_pll_locked_pll_locked_),                //   input,   width = 1,            pll_locked_pll_locked.pll_locked
		.xcvr_native_s10_0_tx_serial_clk0_clk            (_connected_to_xcvr_native_s10_0_tx_serial_clk0_clk_),            //   input,   width = 1, xcvr_native_s10_0_tx_serial_clk0.clk
		.xcvr_native_s10_0_tx_serial_clk1_clk            (_connected_to_xcvr_native_s10_0_tx_serial_clk1_clk_),            //   input,   width = 1, xcvr_native_s10_0_tx_serial_clk1.clk
		.xcvr_native_s10_0_rx_cdr_refclk0_clk            (_connected_to_xcvr_native_s10_0_rx_cdr_refclk0_clk_),            //   input,   width = 1, xcvr_native_s10_0_rx_cdr_refclk0.clk
		.xcvr_native_s10_0_tx_serial_data_tx_serial_data (_connected_to_xcvr_native_s10_0_tx_serial_data_tx_serial_data_), //  output,   width = 1, xcvr_native_s10_0_tx_serial_data.tx_serial_data
		.xcvr_native_s10_0_rx_serial_data_rx_serial_data (_connected_to_xcvr_native_s10_0_rx_serial_data_rx_serial_data_)  //   input,   width = 1, xcvr_native_s10_0_rx_serial_data.rx_serial_data
	);

