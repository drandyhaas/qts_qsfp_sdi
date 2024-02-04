	xcvr_test_system_xcvr_user_tx_fifo_converter_0 u0 (
		.data_pattern_generator_pattern_out                (_connected_to_data_pattern_generator_pattern_out_),                //  output,   width = 64,                data_pattern_generator_pattern_out.export
		.data_pattern_generator_pattern_out_clk            (_connected_to_data_pattern_generator_pattern_out_clk_),            //   input,    width = 1,            data_pattern_generator_pattern_out_clk.export
		.data_pattern_generator_pattern_out_fifo_write_clk (_connected_to_data_pattern_generator_pattern_out_fifo_write_clk_), //   input,    width = 1, data_pattern_generator_pattern_out_fifo_write_clk.export
		.data_pattern_generator_pattern_out_fifo_write     (_connected_to_data_pattern_generator_pattern_out_fifo_write_),     //   input,  width = 128,     data_pattern_generator_pattern_out_fifo_write.export
		.data_pattern_generator_tx_fifo_rdempty            (_connected_to_data_pattern_generator_tx_fifo_rdempty_),            //  output,    width = 1,            data_pattern_generator_tx_fifo_rdempty.export
		.data_pattern_generator_tx_fifo_wrfull             (_connected_to_data_pattern_generator_tx_fifo_wrfull_),             //  output,    width = 1,             data_pattern_generator_tx_fifo_wrfull.export
		.data                                              (_connected_to_data_),                                              //  output,  width = 128,                                        fifo_input.datain
		.wrreq                                             (_connected_to_wrreq_),                                             //  output,    width = 1,                                                  .wrreq
		.rdreq                                             (_connected_to_rdreq_),                                             //  output,    width = 1,                                                  .rdreq
		.wrclk                                             (_connected_to_wrclk_),                                             //  output,    width = 1,                                                  .wrclk
		.rdclk                                             (_connected_to_rdclk_),                                             //  output,    width = 1,                                                  .rdclk
		.q                                                 (_connected_to_q_),                                                 //   input,   width = 64,                                       fifo_output.dataout
		.rdempty                                           (_connected_to_rdempty_),                                           //   input,    width = 1,                                                  .rdempty
		.wrfull                                            (_connected_to_wrfull_)                                             //   input,    width = 1,                                                  .wrfull
	);

