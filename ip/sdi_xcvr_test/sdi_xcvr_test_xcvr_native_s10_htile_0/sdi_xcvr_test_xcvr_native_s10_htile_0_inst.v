	sdi_xcvr_test_xcvr_native_s10_htile_0 u0 (
		.tx_analogreset          (_connected_to_tx_analogreset_),          //   input,   width = 1,          tx_analogreset.tx_analogreset
		.rx_analogreset          (_connected_to_rx_analogreset_),          //   input,   width = 1,          rx_analogreset.rx_analogreset
		.tx_digitalreset         (_connected_to_tx_digitalreset_),         //   input,   width = 1,         tx_digitalreset.tx_digitalreset
		.rx_digitalreset         (_connected_to_rx_digitalreset_),         //   input,   width = 1,         rx_digitalreset.rx_digitalreset
		.tx_analogreset_stat     (_connected_to_tx_analogreset_stat_),     //  output,   width = 1,     tx_analogreset_stat.tx_analogreset_stat
		.rx_analogreset_stat     (_connected_to_rx_analogreset_stat_),     //  output,   width = 1,     rx_analogreset_stat.rx_analogreset_stat
		.tx_digitalreset_stat    (_connected_to_tx_digitalreset_stat_),    //  output,   width = 1,    tx_digitalreset_stat.tx_digitalreset_stat
		.rx_digitalreset_stat    (_connected_to_rx_digitalreset_stat_),    //  output,   width = 1,    rx_digitalreset_stat.rx_digitalreset_stat
		.tx_cal_busy             (_connected_to_tx_cal_busy_),             //  output,   width = 1,             tx_cal_busy.tx_cal_busy
		.rx_cal_busy             (_connected_to_rx_cal_busy_),             //  output,   width = 1,             rx_cal_busy.rx_cal_busy
		.tx_serial_clk0          (_connected_to_tx_serial_clk0_),          //   input,   width = 1,          tx_serial_clk0.clk
		.rx_cdr_refclk0          (_connected_to_rx_cdr_refclk0_),          //   input,   width = 1,          rx_cdr_refclk0.clk
		.tx_serial_data          (_connected_to_tx_serial_data_),          //  output,   width = 1,          tx_serial_data.tx_serial_data
		.rx_serial_data          (_connected_to_rx_serial_data_),          //   input,   width = 1,          rx_serial_data.rx_serial_data
		.rx_seriallpbken         (_connected_to_rx_seriallpbken_),         //   input,   width = 1,         rx_seriallpbken.rx_seriallpbken
		.rx_is_lockedtoref       (_connected_to_rx_is_lockedtoref_),       //  output,   width = 1,       rx_is_lockedtoref.rx_is_lockedtoref
		.rx_is_lockedtodata      (_connected_to_rx_is_lockedtodata_),      //  output,   width = 1,      rx_is_lockedtodata.rx_is_lockedtodata
		.tx_coreclkin            (_connected_to_tx_coreclkin_),            //   input,   width = 1,            tx_coreclkin.clk
		.rx_coreclkin            (_connected_to_rx_coreclkin_),            //   input,   width = 1,            rx_coreclkin.clk
		.tx_clkout               (_connected_to_tx_clkout_),               //  output,   width = 1,               tx_clkout.clk
		.tx_clkout2              (_connected_to_tx_clkout2_),              //  output,   width = 1,              tx_clkout2.clk
		.rx_clkout               (_connected_to_rx_clkout_),               //  output,   width = 1,               rx_clkout.clk
		.rx_clkout2              (_connected_to_rx_clkout2_),              //  output,   width = 1,              rx_clkout2.clk
		.tx_parallel_data        (_connected_to_tx_parallel_data_),        //   input,  width = 64,        tx_parallel_data.tx_parallel_data
		.unused_tx_parallel_data (_connected_to_unused_tx_parallel_data_), //   input,  width = 16, unused_tx_parallel_data.unused_tx_parallel_data
		.rx_parallel_data        (_connected_to_rx_parallel_data_),        //  output,  width = 64,        rx_parallel_data.rx_parallel_data
		.unused_rx_parallel_data (_connected_to_unused_rx_parallel_data_), //  output,  width = 16, unused_rx_parallel_data.unused_rx_parallel_data
		.reconfig_clk            (_connected_to_reconfig_clk_),            //   input,   width = 1,            reconfig_clk.clk
		.reconfig_reset          (_connected_to_reconfig_reset_),          //   input,   width = 1,          reconfig_reset.reset
		.reconfig_write          (_connected_to_reconfig_write_),          //   input,   width = 1,           reconfig_avmm.write
		.reconfig_read           (_connected_to_reconfig_read_),           //   input,   width = 1,                        .read
		.reconfig_address        (_connected_to_reconfig_address_),        //   input,  width = 11,                        .address
		.reconfig_writedata      (_connected_to_reconfig_writedata_),      //   input,  width = 32,                        .writedata
		.reconfig_readdata       (_connected_to_reconfig_readdata_),       //  output,  width = 32,                        .readdata
		.reconfig_waitrequest    (_connected_to_reconfig_waitrequest_)     //  output,   width = 1,                        .waitrequest
	);

