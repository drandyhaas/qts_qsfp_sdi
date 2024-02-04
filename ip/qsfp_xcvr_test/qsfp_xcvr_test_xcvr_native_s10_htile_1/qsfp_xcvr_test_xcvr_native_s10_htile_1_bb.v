module qsfp_xcvr_test_xcvr_native_s10_htile_1 (
		input  wire [0:0]  tx_analogreset,          //          tx_analogreset.tx_analogreset
		input  wire [0:0]  rx_analogreset,          //          rx_analogreset.rx_analogreset
		input  wire [0:0]  tx_digitalreset,         //         tx_digitalreset.tx_digitalreset
		input  wire [0:0]  rx_digitalreset,         //         rx_digitalreset.rx_digitalreset
		output wire [0:0]  tx_analogreset_stat,     //     tx_analogreset_stat.tx_analogreset_stat
		output wire [0:0]  rx_analogreset_stat,     //     rx_analogreset_stat.rx_analogreset_stat
		output wire [0:0]  tx_digitalreset_stat,    //    tx_digitalreset_stat.tx_digitalreset_stat
		output wire [0:0]  rx_digitalreset_stat,    //    rx_digitalreset_stat.rx_digitalreset_stat
		output wire [0:0]  tx_cal_busy,             //             tx_cal_busy.tx_cal_busy
		output wire [0:0]  rx_cal_busy,             //             rx_cal_busy.rx_cal_busy
		input  wire [0:0]  tx_serial_clk0,          //          tx_serial_clk0.clk
		input  wire        rx_cdr_refclk0,          //          rx_cdr_refclk0.clk
		output wire [0:0]  tx_serial_data,          //          tx_serial_data.tx_serial_data
		input  wire [0:0]  rx_serial_data,          //          rx_serial_data.rx_serial_data
		input  wire [0:0]  rx_seriallpbken,         //         rx_seriallpbken.rx_seriallpbken
		output wire [0:0]  rx_is_lockedtoref,       //       rx_is_lockedtoref.rx_is_lockedtoref
		output wire [0:0]  rx_is_lockedtodata,      //      rx_is_lockedtodata.rx_is_lockedtodata
		input  wire [0:0]  tx_coreclkin,            //            tx_coreclkin.clk
		input  wire [0:0]  rx_coreclkin,            //            rx_coreclkin.clk
		output wire [0:0]  tx_clkout,               //               tx_clkout.clk
		output wire [0:0]  tx_clkout2,              //              tx_clkout2.clk
		output wire [0:0]  rx_clkout,               //               rx_clkout.clk
		output wire [0:0]  rx_clkout2,              //              rx_clkout2.clk
		output wire [0:0]  rx_pma_iqtxrx_clkout,    //    rx_pma_iqtxrx_clkout.clk
		input  wire [63:0] tx_parallel_data,        //        tx_parallel_data.tx_parallel_data
		input  wire [15:0] unused_tx_parallel_data, // unused_tx_parallel_data.unused_tx_parallel_data
		output wire [63:0] rx_parallel_data,        //        rx_parallel_data.rx_parallel_data
		output wire [15:0] unused_rx_parallel_data, // unused_rx_parallel_data.unused_rx_parallel_data
		input  wire [0:0]  reconfig_clk,            //            reconfig_clk.clk
		input  wire [0:0]  reconfig_reset,          //          reconfig_reset.reset
		input  wire [0:0]  reconfig_write,          //           reconfig_avmm.write
		input  wire [0:0]  reconfig_read,           //                        .read
		input  wire [10:0] reconfig_address,        //                        .address
		input  wire [31:0] reconfig_writedata,      //                        .writedata
		output wire [31:0] reconfig_readdata,       //                        .readdata
		output wire [0:0]  reconfig_waitrequest     //                        .waitrequest
	);
endmodule

