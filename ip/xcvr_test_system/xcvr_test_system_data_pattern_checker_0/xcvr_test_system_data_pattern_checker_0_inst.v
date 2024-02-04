	xcvr_test_system_data_pattern_checker_0 u0 (
		.csr_clk_clk                   (_connected_to_csr_clk_clk_),                   //   input,    width = 1,                csr_clk.clk
		.reset_reset                   (_connected_to_reset_reset_),                   //   input,    width = 1,                  reset.reset
		.csr_slave_address             (_connected_to_csr_slave_address_),             //   input,    width = 3,              csr_slave.address
		.csr_slave_write               (_connected_to_csr_slave_write_),               //   input,    width = 1,                       .write
		.csr_slave_read                (_connected_to_csr_slave_read_),                //   input,    width = 1,                       .read
		.csr_slave_byteenable          (_connected_to_csr_slave_byteenable_),          //   input,    width = 4,                       .byteenable
		.csr_slave_writedata           (_connected_to_csr_slave_writedata_),           //   input,   width = 32,                       .writedata
		.csr_slave_readdata            (_connected_to_csr_slave_readdata_),            //  output,   width = 32,                       .readdata
		.conduit_pattern_in_clk_export (_connected_to_conduit_pattern_in_clk_export_), //   input,    width = 1, conduit_pattern_in_clk.export
		.asi_data                      (_connected_to_asi_data_)                       //   input,  width = 128,     conduit_pattern_in.export
	);

