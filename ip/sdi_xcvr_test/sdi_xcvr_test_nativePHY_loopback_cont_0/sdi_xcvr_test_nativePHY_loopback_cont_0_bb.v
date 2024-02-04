module sdi_xcvr_test_nativePHY_loopback_cont_0 (
		input  wire        reset_n,             //               reset.reset_n
		input  wire        clk,                 //               clock.clk
		input  wire [3:0]  csr_address,         //                 csr.address
		input  wire        csr_read,            //                    .read
		input  wire        csr_write,           //                    .write
		output wire [31:0] csr_readdata,        //                    .readdata
		input  wire [31:0] csr_writedata,       //                    .writedata
		input  wire [0:0]  pll_locked,          //          pll_locked.pll_locked
		input  wire [0:0]  rx_is_lockedtoref,   //   rx_is_lockedtoref.rx_is_lockedtoref
		output wire [0:0]  rx_seriallpbken,     //     rx_seriallpbken.rx_seriallpbken
		output wire [0:0]  rx_seriallpbken_mon  // rx_seriallpbken_mon.export
	);
endmodule

