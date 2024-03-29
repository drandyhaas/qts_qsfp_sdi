// xcvr_test_system_data_pattern_generator_0.v

// Generated using ACDS version 23.3 104

`timescale 1 ps / 1 ps
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

	xcvr_test_system_data_pattern_generator_0_data_pattern_generator_10_utzxrya #(
		.ST_DATA_W            (128),
		.BYPASS_ENABLED       (0),
		.AVALON_ENABLED       (0),
		.CROSS_CLK_SYNC_DEPTH (4)
	) data_pattern_generator_0 (
		.csr_clk_clk                    (csr_clk_clk),                    //   input,    width = 1,                 csr_clk.clk
		.reset_reset                    (reset_reset),                    //   input,    width = 1,                   reset.reset
		.csr_slave_address              (csr_slave_address),              //   input,    width = 3,               csr_slave.address
		.csr_slave_write                (csr_slave_write),                //   input,    width = 1,                        .write
		.csr_slave_read                 (csr_slave_read),                 //   input,    width = 1,                        .read
		.csr_slave_byteenable           (csr_slave_byteenable),           //   input,    width = 4,                        .byteenable
		.csr_slave_writedata            (csr_slave_writedata),            //   input,   width = 32,                        .writedata
		.csr_slave_readdata             (csr_slave_readdata),             //  output,   width = 32,                        .readdata
		.conduit_pattern_out_clk_export (conduit_pattern_out_clk_export), //   input,    width = 1, conduit_pattern_out_clk.export
		.aso_data                       (aso_data)                        //  output,  width = 128,     conduit_pattern_out.export
	);

endmodule
