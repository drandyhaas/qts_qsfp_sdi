	q_sys_pll_status_interconnect_2 u0 (
		.pll_locked        (_connected_to_pll_locked_),        //   input,  width = 1,        pll_locked.pll_locked
		.pll_powerdown     (_connected_to_pll_powerdown_),     //  output,  width = 1,     pll_powerdown.pll_powerdown
		.mcgb_rst          (_connected_to_mcgb_rst_),          //  output,  width = 1,          mcgb_rst.mcgb_rst
		.pll_locked_output (_connected_to_pll_locked_output_), //  output,  width = 1, pll_locked_output.pll_locked
		.pll_locked_a      (_connected_to_pll_locked_a_),      //  output,  width = 1,      pll_locked_a.pll_locked
		.pll_powerdown_a   (_connected_to_pll_powerdown_a_),   //   input,  width = 1,   pll_powerdown_a.pll_powerdown
		.pll_locked_b      (_connected_to_pll_locked_b_),      //  output,  width = 1,      pll_locked_b.pll_locked
		.pll_powerdown_b   (_connected_to_pll_powerdown_b_)    //   input,  width = 1,   pll_powerdown_b.pll_powerdown
	);

