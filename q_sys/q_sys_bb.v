module q_sys (
		input  wire       clk_100_clk,                                                      //                                           clk_100.clk
		input  wire       reset_100_reset_n,                                                //                                         reset_100.reset_n
		input  wire       clk_50_clk,                                                       //                                            clk_50.clk
		input  wire       reset_50_reset_n,                                                 //                                          reset_50.reset_n
		output wire [0:0] q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked,         //     q_sys_pll_status_interconnect_qsfp_pll_locked.pll_locked
		output wire [0:0] q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked,        //    q_sys_pll_status_interconnect_qsfp_pll_locked1.pll_locked
		output wire [0:0] q_sys_pll_status_interconnect_sdi_pll_locked_pll_locked,          //      q_sys_pll_status_interconnect_sdi_pll_locked.pll_locked
		input  wire       qsfp_xcvr_atx_pll_refclk_in_clk_clk,                              //                   qsfp_xcvr_atx_pll_refclk_in_clk.clk
		input  wire       sdi_xcvr_atx_pll_refclk_in_clk_clk,                               //                    sdi_xcvr_atx_pll_refclk_in_clk.clk
		output wire [0:0] qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data, // qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data, // qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		output wire [0:0] qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data, // qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data, // qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		output wire [0:0] qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data, // qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data, // qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		output wire [0:0] qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data, // qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data, // qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		output wire [0:0] sdi_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data,  //  sdi_xcvr_test_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] sdi_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data,  //  sdi_xcvr_test_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		output wire [0:0] sdi_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data,  //  sdi_xcvr_test_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0] sdi_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data   //  sdi_xcvr_test_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
	);
endmodule

