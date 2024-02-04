// xcvr_test_system_xcvr_user_rx_fifo_converter_0.v

// Generated using ACDS version 23.3 104

`timescale 1 ps / 1 ps
module xcvr_test_system_xcvr_user_rx_fifo_converter_0 (
		input  wire [63:0]  data_pattern_checker_pattern_in,               //               data_pattern_checker_pattern_in.export
		input  wire         data_pattern_checker_pattern_in_clk,           //           data_pattern_checker_pattern_in_clk.export
		output wire [127:0] data_pattern_checker_pattern_in_fifo_read,     //     data_pattern_checker_pattern_in_fifo_read.export
		input  wire         data_pattern_checker_pattern_in_fifo_read_clk, // data_pattern_checker_pattern_in_fifo_read_clk.export
		output wire         data_pattern_checker_rx_fifo_rdempty,          //          data_pattern_checker_rx_fifo_rdempty.export
		output wire         data_pattern_checker_rx_fifo_wrfull,           //           data_pattern_checker_rx_fifo_wrfull.export
		output wire [63:0]  data,                                          //                                    fifo_input.datain
		output wire         wrreq,                                         //                                              .wrreq
		output wire         rdreq,                                         //                                              .rdreq
		output wire         wrclk,                                         //                                              .wrclk
		output wire         rdclk,                                         //                                              .rdclk
		input  wire [127:0] q,                                             //                                   fifo_output.dataout
		input  wire         rdempty,                                       //                                              .rdempty
		input  wire         wrfull                                         //                                              .wrfull
	);

	xcvr_user_rx_fifo_converter xcvr_test_system_xcvr_user_rx_fifo_converter_0 (
		.data_pattern_checker_pattern_in               (data_pattern_checker_pattern_in),               //   input,   width = 64,               data_pattern_checker_pattern_in.export
		.data_pattern_checker_pattern_in_clk           (data_pattern_checker_pattern_in_clk),           //   input,    width = 1,           data_pattern_checker_pattern_in_clk.export
		.data_pattern_checker_pattern_in_fifo_read     (data_pattern_checker_pattern_in_fifo_read),     //  output,  width = 128,     data_pattern_checker_pattern_in_fifo_read.export
		.data_pattern_checker_pattern_in_fifo_read_clk (data_pattern_checker_pattern_in_fifo_read_clk), //   input,    width = 1, data_pattern_checker_pattern_in_fifo_read_clk.export
		.data_pattern_checker_rx_fifo_rdempty          (data_pattern_checker_rx_fifo_rdempty),          //  output,    width = 1,          data_pattern_checker_rx_fifo_rdempty.export
		.data_pattern_checker_rx_fifo_wrfull           (data_pattern_checker_rx_fifo_wrfull),           //  output,    width = 1,           data_pattern_checker_rx_fifo_wrfull.export
		.data                                          (data),                                          //  output,   width = 64,                                    fifo_input.datain
		.wrreq                                         (wrreq),                                         //  output,    width = 1,                                              .wrreq
		.rdreq                                         (rdreq),                                         //  output,    width = 1,                                              .rdreq
		.wrclk                                         (wrclk),                                         //  output,    width = 1,                                              .wrclk
		.rdclk                                         (rdclk),                                         //  output,    width = 1,                                              .rdclk
		.q                                             (q),                                             //   input,  width = 128,                                   fifo_output.dataout
		.rdempty                                       (rdempty),                                       //   input,    width = 1,                                              .rdempty
		.wrfull                                        (wrfull)                                         //   input,    width = 1,                                              .wrfull
	);

endmodule