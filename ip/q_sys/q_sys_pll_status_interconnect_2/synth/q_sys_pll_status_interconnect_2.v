// q_sys_pll_status_interconnect_2.v

// Generated using ACDS version 23.3 104

`timescale 1 ps / 1 ps
module q_sys_pll_status_interconnect_2 (
		input  wire [0:0] pll_locked,        //        pll_locked.pll_locked
		output wire [0:0] pll_powerdown,     //     pll_powerdown.pll_powerdown
		output wire [0:0] mcgb_rst,          //          mcgb_rst.mcgb_rst
		output wire [0:0] pll_locked_output, // pll_locked_output.pll_locked
		output wire [0:0] pll_locked_a,      //      pll_locked_a.pll_locked
		input  wire [0:0] pll_powerdown_a,   //   pll_powerdown_a.pll_powerdown
		output wire [0:0] pll_locked_b,      //      pll_locked_b.pll_locked
		input  wire [0:0] pll_powerdown_b    //   pll_powerdown_b.pll_powerdown
	);

	pll_status_interconnect #(
		.DATAWIDTH (1),
		.NUM_OF_CH (2)
	) q_sys_pll_status_interconnect_0 (
		.pll_locked        (pll_locked),        //   input,  width = 1,        pll_locked.pll_locked
		.pll_powerdown     (pll_powerdown),     //  output,  width = 1,     pll_powerdown.pll_powerdown
		.mcgb_rst          (mcgb_rst),          //  output,  width = 1,          mcgb_rst.mcgb_rst
		.pll_locked_output (pll_locked_output), //  output,  width = 1, pll_locked_output.pll_locked
		.pll_locked_a      (pll_locked_a),      //  output,  width = 1,      pll_locked_a.pll_locked
		.pll_powerdown_a   (pll_powerdown_a),   //   input,  width = 1,   pll_powerdown_a.pll_powerdown
		.pll_locked_b      (pll_locked_b),      //  output,  width = 1,      pll_locked_b.pll_locked
		.pll_powerdown_b   (pll_powerdown_b)    //   input,  width = 1,   pll_powerdown_b.pll_powerdown
	);

endmodule
