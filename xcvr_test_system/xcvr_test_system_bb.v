module xcvr_test_system (
		input  wire        clk_50_clk,                                                                  //                                                               clk_50.clk
		input  wire        reset_50_reset_n,                                                            //                                                             reset_50.reset_n
		output wire        mm_bridge_0_s0_waitrequest,                                                  //                                                       mm_bridge_0_s0.waitrequest
		output wire [31:0] mm_bridge_0_s0_readdata,                                                     //                                                                     .readdata
		output wire        mm_bridge_0_s0_readdatavalid,                                                //                                                                     .readdatavalid
		input  wire [0:0]  mm_bridge_0_s0_burstcount,                                                   //                                                                     .burstcount
		input  wire [31:0] mm_bridge_0_s0_writedata,                                                    //                                                                     .writedata
		input  wire [12:0] mm_bridge_0_s0_address,                                                      //                                                                     .address
		input  wire        mm_bridge_0_s0_write,                                                        //                                                                     .write
		input  wire        mm_bridge_0_s0_read,                                                         //                                                                     .read
		input  wire [3:0]  mm_bridge_0_s0_byteenable,                                                   //                                                                     .byteenable
		input  wire        mm_bridge_0_s0_debugaccess,                                                  //                                                                     .debugaccess
		input  wire        xcvr_tx_rx_clkout2_converter_0_rx_clkout2_clk,                               //                            xcvr_tx_rx_clkout2_converter_0_rx_clkout2.clk
		input  wire        xcvr_tx_rx_clkout2_converter_0_tx_clkout2_clk,                               //                            xcvr_tx_rx_clkout2_converter_0_tx_clkout2.clk
		input  wire [63:0] xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_export,        //        xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in.export
		input  wire        xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk_export,    //    xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk.export
		output wire [63:0] xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_export,     //     xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out.export
		input  wire        xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk_export  // xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk.export
	);
endmodule

