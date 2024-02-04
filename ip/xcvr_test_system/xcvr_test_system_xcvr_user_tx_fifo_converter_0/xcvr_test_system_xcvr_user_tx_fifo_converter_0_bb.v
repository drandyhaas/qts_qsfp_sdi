module xcvr_test_system_xcvr_user_tx_fifo_converter_0 (
		output wire [63:0]  data_pattern_generator_pattern_out,                //                data_pattern_generator_pattern_out.export
		input  wire         data_pattern_generator_pattern_out_clk,            //            data_pattern_generator_pattern_out_clk.export
		input  wire         data_pattern_generator_pattern_out_fifo_write_clk, // data_pattern_generator_pattern_out_fifo_write_clk.export
		input  wire [127:0] data_pattern_generator_pattern_out_fifo_write,     //     data_pattern_generator_pattern_out_fifo_write.export
		output wire         data_pattern_generator_tx_fifo_rdempty,            //            data_pattern_generator_tx_fifo_rdempty.export
		output wire         data_pattern_generator_tx_fifo_wrfull,             //             data_pattern_generator_tx_fifo_wrfull.export
		output wire [127:0] data,                                              //                                        fifo_input.datain
		output wire         wrreq,                                             //                                                  .wrreq
		output wire         rdreq,                                             //                                                  .rdreq
		output wire         wrclk,                                             //                                                  .wrclk
		output wire         rdclk,                                             //                                                  .rdclk
		input  wire [63:0]  q,                                                 //                                       fifo_output.dataout
		input  wire         rdempty,                                           //                                                  .rdempty
		input  wire         wrfull                                             //                                                  .wrfull
	);
endmodule

