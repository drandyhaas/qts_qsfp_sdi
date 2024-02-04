/*
XCVR TX CLKOUT2 Converter for new XCVR_TEST_SYSTEM module
*/

module  xcvr_tx_rx_clkout2_converter( 
        input  tx_clkout2,
        output tx_clkout2_sample,
        output tx_clkout2_a,
        output tx_clkout2_b,
        input  rx_clkout2,
        output rx_clkout2_a,
        output rx_clkout2_b
);

	assign tx_clkout2_sample = tx_clkout2;
	assign tx_clkout2_a      = tx_clkout2;
	assign tx_clkout2_b      = tx_clkout2;
	assign rx_clkout2_a      = rx_clkout2;
	assign rx_clkout2_b      = rx_clkout2;

endmodule
