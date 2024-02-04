	sdi_xcvr_test_nativePHY_loopback_cont_0 u0 (
		.reset_n             (_connected_to_reset_n_),             //   input,   width = 1,               reset.reset_n
		.clk                 (_connected_to_clk_),                 //   input,   width = 1,               clock.clk
		.csr_address         (_connected_to_csr_address_),         //   input,   width = 4,                 csr.address
		.csr_read            (_connected_to_csr_read_),            //   input,   width = 1,                    .read
		.csr_write           (_connected_to_csr_write_),           //   input,   width = 1,                    .write
		.csr_readdata        (_connected_to_csr_readdata_),        //  output,  width = 32,                    .readdata
		.csr_writedata       (_connected_to_csr_writedata_),       //   input,  width = 32,                    .writedata
		.pll_locked          (_connected_to_pll_locked_),          //   input,   width = 1,          pll_locked.pll_locked
		.rx_is_lockedtoref   (_connected_to_rx_is_lockedtoref_),   //   input,   width = 1,   rx_is_lockedtoref.rx_is_lockedtoref
		.rx_seriallpbken     (_connected_to_rx_seriallpbken_),     //  output,   width = 1,     rx_seriallpbken.rx_seriallpbken
		.rx_seriallpbken_mon (_connected_to_rx_seriallpbken_mon_)  //  output,   width = 1, rx_seriallpbken_mon.export
	);

