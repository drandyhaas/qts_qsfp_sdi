// conf_reset_src.v

// Generated using ACDS version 23.3 104

`timescale 1 ps / 1 ps
module conf_reset_src (
		output wire  conf_reset  // conf_reset.conf_reset
	);

	intel_configuration_reset_release_for_debug conf_reset_src (
		.conf_reset (conf_reset)  //  output,  width = 1, conf_reset.conf_reset
	);

endmodule
