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
endmodule

