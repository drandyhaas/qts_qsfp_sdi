module xcvr_test_system_data_pattern_checker_0 (
		input  wire         csr_clk_clk,                   //                csr_clk.clk
		input  wire         reset_reset,                   //                  reset.reset
		input  wire [2:0]   csr_slave_address,             //              csr_slave.address
		input  wire         csr_slave_write,               //                       .write
		input  wire         csr_slave_read,                //                       .read
		input  wire [3:0]   csr_slave_byteenable,          //                       .byteenable
		input  wire [31:0]  csr_slave_writedata,           //                       .writedata
		output wire [31:0]  csr_slave_readdata,            //                       .readdata
		input  wire         conduit_pattern_in_clk_export, // conduit_pattern_in_clk.export
		input  wire [127:0] asi_data                       //     conduit_pattern_in.export
	);
endmodule

