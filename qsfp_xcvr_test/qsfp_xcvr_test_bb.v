module qsfp_xcvr_test (
		input  wire        clk_100_clk,                                     //                          clk_100.clk
		input  wire        reset_100_reset_n,                               //                        reset_100.reset_n
		input  wire        clk_50_clk,                                      //                           clk_50.clk
		input  wire        reset_50_reset_n,                                //                         reset_50.reset_n
		output wire        mm_bridge_0_s0_waitrequest,                      //                   mm_bridge_0_s0.waitrequest
		output wire [31:0] mm_bridge_0_s0_readdata,                         //                                 .readdata
		output wire        mm_bridge_0_s0_readdatavalid,                    //                                 .readdatavalid
		input  wire [0:0]  mm_bridge_0_s0_burstcount,                       //                                 .burstcount
		input  wire [31:0] mm_bridge_0_s0_writedata,                        //                                 .writedata
		input  wire [14:0] mm_bridge_0_s0_address,                          //                                 .address
		input  wire        mm_bridge_0_s0_write,                            //                                 .write
		input  wire        mm_bridge_0_s0_read,                             //                                 .read
		input  wire [3:0]  mm_bridge_0_s0_byteenable,                       //                                 .byteenable
		input  wire        mm_bridge_0_s0_debugaccess,                      //                                 .debugaccess
		input  wire [0:0]  pll_locked_pll_locked_pll_locked,                //            pll_locked_pll_locked.pll_locked
		input  wire [0:0]  xcvr_native_s10_0_tx_serial_clk0_clk,            // xcvr_native_s10_0_tx_serial_clk0.clk
		input  wire [0:0]  xcvr_native_s10_0_tx_serial_clk1_clk,            // xcvr_native_s10_0_tx_serial_clk1.clk
		input  wire        xcvr_native_s10_0_rx_cdr_refclk0_clk,            // xcvr_native_s10_0_rx_cdr_refclk0.clk
		output wire [0:0]  xcvr_native_s10_0_tx_serial_data_tx_serial_data, // xcvr_native_s10_0_tx_serial_data.tx_serial_data
		input  wire [0:0]  xcvr_native_s10_0_rx_serial_data_rx_serial_data  // xcvr_native_s10_0_rx_serial_data.rx_serial_data
	);
endmodule

