	xcvr_test_system_xcvr_user_rx_fifo_converter_0 u0 (
		.data_pattern_checker_pattern_in               (_connected_to_data_pattern_checker_pattern_in_),               //   input,   width = 64,               data_pattern_checker_pattern_in.export
		.data_pattern_checker_pattern_in_clk           (_connected_to_data_pattern_checker_pattern_in_clk_),           //   input,    width = 1,           data_pattern_checker_pattern_in_clk.export
		.data_pattern_checker_pattern_in_fifo_read     (_connected_to_data_pattern_checker_pattern_in_fifo_read_),     //  output,  width = 128,     data_pattern_checker_pattern_in_fifo_read.export
		.data_pattern_checker_pattern_in_fifo_read_clk (_connected_to_data_pattern_checker_pattern_in_fifo_read_clk_), //   input,    width = 1, data_pattern_checker_pattern_in_fifo_read_clk.export
		.data_pattern_checker_rx_fifo_rdempty          (_connected_to_data_pattern_checker_rx_fifo_rdempty_),          //  output,    width = 1,          data_pattern_checker_rx_fifo_rdempty.export
		.data_pattern_checker_rx_fifo_wrfull           (_connected_to_data_pattern_checker_rx_fifo_wrfull_),           //  output,    width = 1,           data_pattern_checker_rx_fifo_wrfull.export
		.data                                          (_connected_to_data_),                                          //  output,   width = 64,                                    fifo_input.datain
		.wrreq                                         (_connected_to_wrreq_),                                         //  output,    width = 1,                                              .wrreq
		.rdreq                                         (_connected_to_rdreq_),                                         //  output,    width = 1,                                              .rdreq
		.wrclk                                         (_connected_to_wrclk_),                                         //  output,    width = 1,                                              .wrclk
		.rdclk                                         (_connected_to_rdclk_),                                         //  output,    width = 1,                                              .rdclk
		.q                                             (_connected_to_q_),                                             //   input,  width = 128,                                   fifo_output.dataout
		.rdempty                                       (_connected_to_rdempty_),                                       //   input,    width = 1,                                              .rdempty
		.wrfull                                        (_connected_to_wrfull_)                                         //   input,    width = 1,                                              .wrfull
	);

