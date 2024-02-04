module xcvr_test_system_freq_counter_0 (
		input  wire        reset_n,      //        reset.reset_n
		input  wire        clk,          //        clock.clk
		input  wire [3:0]  csr_address,  //          csr.address
		input  wire        csr_read,     //             .read
		output wire [31:0] csr_readdata, //             .readdata
		input  wire        sample_clk    // sample_clock.clk
	);
endmodule

