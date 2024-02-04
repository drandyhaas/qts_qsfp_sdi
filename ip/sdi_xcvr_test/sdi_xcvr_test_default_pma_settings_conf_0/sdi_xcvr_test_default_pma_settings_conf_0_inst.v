	sdi_xcvr_test_default_pma_settings_conf_0 u0 (
		.clock            (_connected_to_clock_),            //   input,   width = 1,         clock.clk
		.reset_n          (_connected_to_reset_n_),          //   input,   width = 1,         reset.reset_n
		.master_wen       (_connected_to_master_wen_),       //  output,   width = 1, avalon_master.write_n
		.master_oen       (_connected_to_master_oen_),       //  output,   width = 1,              .read_n
		.master_be        (_connected_to_master_be_),        //  output,   width = 4,              .byteenable
		.master_address   (_connected_to_master_address_),   //  output,  width = 32,              .address
		.master_wdata     (_connected_to_master_wdata_),     //  output,  width = 32,              .writedata
		.master_rdata     (_connected_to_master_rdata_),     //   input,  width = 32,              .readdata
		.readdatavalid_in (_connected_to_readdatavalid_in_), //   input,   width = 1,              .readdatavalid
		.waitrequest_in   (_connected_to_waitrequest_in_),   //   input,   width = 1,              .waitrequest
		.slave_read       (_connected_to_slave_read_),       //   input,   width = 1,  avalon_slave.read
		.slave_write      (_connected_to_slave_write_),      //   input,   width = 1,              .write
		.slave_readdata   (_connected_to_slave_readdata_),   //  output,  width = 32,              .readdata
		.slave_writedata  (_connected_to_slave_writedata_),  //   input,  width = 32,              .writedata
		.slave_address    (_connected_to_slave_address_)     //   input,   width = 4,              .address
	);

