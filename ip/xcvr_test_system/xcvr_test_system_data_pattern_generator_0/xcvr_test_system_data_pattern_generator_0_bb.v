module xcvr_test_system_data_pattern_generator_0 (
		input  wire         csr_clk_clk,                    //                 csr_clk.clk
		input  wire         reset_reset,                    //                   reset.reset
		input  wire [2:0]   csr_slave_address,              //               csr_slave.address
		input  wire         csr_slave_write,                //                        .write
		input  wire         csr_slave_read,                 //                        .read
		input  wire [3:0]   csr_slave_byteenable,           //                        .byteenable
		input  wire [31:0]  csr_slave_writedata,            //                        .writedata
		output wire [31:0]  csr_slave_readdata,             //                        .readdata
		input  wire         conduit_pattern_out_clk_export, // conduit_pattern_out_clk.export
		output wire [127:0] aso_data                        //     conduit_pattern_out.export
	);
endmodule

