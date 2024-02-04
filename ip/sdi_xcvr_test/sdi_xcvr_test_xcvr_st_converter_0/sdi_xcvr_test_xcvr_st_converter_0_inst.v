	sdi_xcvr_test_xcvr_st_converter_0 u0 (
		.tx_parallel_data   (_connected_to_tx_parallel_data_),   //  output,  width = 64,   tx_parallel_data.tx_parallel_data
		.tx_clkout          (_connected_to_tx_clkout_),          //   input,   width = 1,          tx_clkout.clk
		.rx_parallel_data   (_connected_to_rx_parallel_data_),   //   input,  width = 64,   rx_parallel_data.rx_parallel_data
		.rx_clkout          (_connected_to_rx_clkout_),          //   input,   width = 1,          rx_clkout.clk
		.rx_is_lockedtodata (_connected_to_rx_is_lockedtodata_), //   input,   width = 1, rx_is_lockedtodata.rx_is_lockedtodata
		.tx_data_a          (_connected_to_tx_data_a_),          //   input,  width = 64,          tx_data_a.export
		.tx_clkout_a        (_connected_to_tx_clkout_a_),        //  output,   width = 1,        tx_clkout_a.export
		.rx_data_a          (_connected_to_rx_data_a_),          //  output,  width = 64,          rx_data_a.export
		.rx_clkout_a        (_connected_to_rx_clkout_a_),        //  output,   width = 1,        rx_clkout_a.export
		.test_reset_n_a     (_connected_to_test_reset_n_a_),     //  output,   width = 1,     test_reset_n_a.reset_n
		.tx_clkout_a_output (_connected_to_tx_clkout_a_output_), //  output,   width = 1, tx_clkout_a_output.clk
		.rx_clkout_a_output (_connected_to_rx_clkout_a_output_)  //  output,   width = 1, rx_clkout_a_output.clk
	);

