module sdi_xcvr_test_xcvr_st_converter_0 (
		output wire [63:0] tx_parallel_data,   //   tx_parallel_data.tx_parallel_data
		input  wire [0:0]  tx_clkout,          //          tx_clkout.clk
		input  wire [63:0] rx_parallel_data,   //   rx_parallel_data.rx_parallel_data
		input  wire [0:0]  rx_clkout,          //          rx_clkout.clk
		input  wire [0:0]  rx_is_lockedtodata, // rx_is_lockedtodata.rx_is_lockedtodata
		input  wire [63:0] tx_data_a,          //          tx_data_a.export
		output wire        tx_clkout_a,        //        tx_clkout_a.export
		output wire [63:0] rx_data_a,          //          rx_data_a.export
		output wire        rx_clkout_a,        //        rx_clkout_a.export
		output wire        test_reset_n_a,     //     test_reset_n_a.reset_n
		output wire        tx_clkout_a_output, // tx_clkout_a_output.clk
		output wire        rx_clkout_a_output  // rx_clkout_a_output.clk
	);
endmodule

