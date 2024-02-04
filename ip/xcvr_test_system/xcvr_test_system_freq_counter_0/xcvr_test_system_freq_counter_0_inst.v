	xcvr_test_system_freq_counter_0 u0 (
		.reset_n      (_connected_to_reset_n_),      //   input,   width = 1,        reset.reset_n
		.clk          (_connected_to_clk_),          //   input,   width = 1,        clock.clk
		.csr_address  (_connected_to_csr_address_),  //   input,   width = 4,          csr.address
		.csr_read     (_connected_to_csr_read_),     //   input,   width = 1,             .read
		.csr_readdata (_connected_to_csr_readdata_), //  output,  width = 32,             .readdata
		.sample_clk   (_connected_to_sample_clk_)    //   input,   width = 1, sample_clock.clk
	);

