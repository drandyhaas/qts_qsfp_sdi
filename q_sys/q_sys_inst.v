	q_sys u0 (
		.clk_100_clk                                                      (_connected_to_clk_100_clk_),                                                      //   input,  width = 1,                                           clk_100.clk
		.reset_100_reset_n                                                (_connected_to_reset_100_reset_n_),                                                //   input,  width = 1,                                         reset_100.reset_n
		.clk_50_clk                                                       (_connected_to_clk_50_clk_),                                                       //   input,  width = 1,                                            clk_50.clk
		.reset_50_reset_n                                                 (_connected_to_reset_50_reset_n_),                                                 //   input,  width = 1,                                          reset_50.reset_n
		.q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked         (_connected_to_q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked_),         //  output,  width = 1,     q_sys_pll_status_interconnect_qsfp_pll_locked.pll_locked
		.q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked        (_connected_to_q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked_),        //  output,  width = 1,    q_sys_pll_status_interconnect_qsfp_pll_locked1.pll_locked
		.qsfp_xcvr_atx_pll_refclk_in_clk_clk                              (_connected_to_qsfp_xcvr_atx_pll_refclk_in_clk_clk_),                              //   input,  width = 1,                   qsfp_xcvr_atx_pll_refclk_in_clk.clk
		.qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data (_connected_to_qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data_), //  output,  width = 1, qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		.qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data (_connected_to_qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data_), //   input,  width = 1, qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		.qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data (_connected_to_qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data_), //  output,  width = 1, qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		.qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data (_connected_to_qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data_), //   input,  width = 1, qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		.qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data (_connected_to_qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data_), //  output,  width = 1, qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		.qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data (_connected_to_qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data_), //   input,  width = 1, qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		.qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data (_connected_to_qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data_), //  output,  width = 1, qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		.qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data (_connected_to_qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data_)  //   input,  width = 1, qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data.rx_serial_data
	);

