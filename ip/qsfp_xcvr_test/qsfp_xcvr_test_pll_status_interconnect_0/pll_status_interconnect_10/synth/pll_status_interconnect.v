/*
This module is to interconnect pll status of conduit attribute in Qsys platform
*/

module  pll_status_interconnect( 
	input  [DATAWIDTH-1 : 0] pll_locked,
	output [DATAWIDTH-1 : 0] pll_powerdown,
	output [DATAWIDTH-1 : 0] mcgb_rst,
	output [DATAWIDTH-1 : 0] pll_locked_a,
	output [DATAWIDTH-1 : 0] pll_locked_b,
	output [DATAWIDTH-1 : 0] pll_locked_c,
	output [DATAWIDTH-1 : 0] pll_locked_d,
	output [DATAWIDTH-1 : 0] pll_locked_e,
	output [DATAWIDTH-1 : 0] pll_locked_f,
	output [DATAWIDTH-1 : 0] pll_locked_g,
	output [DATAWIDTH-1 : 0] pll_locked_h,
	output [DATAWIDTH-1 : 0] pll_locked_i,
	output [DATAWIDTH-1 : 0] pll_locked_j,
	output [DATAWIDTH-1 : 0] pll_locked_k,
	output [DATAWIDTH-1 : 0] pll_locked_l,
	output [DATAWIDTH-1 : 0] pll_locked_m,
	output [DATAWIDTH-1 : 0] pll_locked_n,
	output [DATAWIDTH-1 : 0] pll_locked_o,
	output [DATAWIDTH-1 : 0] pll_locked_p,
	input  [DATAWIDTH-1 : 0] pll_powerdown_a,
	input  [DATAWIDTH-1 : 0] pll_powerdown_b,
	input  [DATAWIDTH-1 : 0] pll_powerdown_c,
	input  [DATAWIDTH-1 : 0] pll_powerdown_d,
	input  [DATAWIDTH-1 : 0] pll_powerdown_e,
	input  [DATAWIDTH-1 : 0] pll_powerdown_f,
	input  [DATAWIDTH-1 : 0] pll_powerdown_g,
	input  [DATAWIDTH-1 : 0] pll_powerdown_h,
	input  [DATAWIDTH-1 : 0] pll_powerdown_i,
	input  [DATAWIDTH-1 : 0] pll_powerdown_j,
	input  [DATAWIDTH-1 : 0] pll_powerdown_k,
	input  [DATAWIDTH-1 : 0] pll_powerdown_l,
	input  [DATAWIDTH-1 : 0] pll_powerdown_m,
	input  [DATAWIDTH-1 : 0] pll_powerdown_n,
	input  [DATAWIDTH-1 : 0] pll_powerdown_o,
	input  [DATAWIDTH-1 : 0] pll_powerdown_p,
	output [DATAWIDTH-1 : 0] pll_locked_output
);
	parameter DATAWIDTH = 1;
	parameter NUM_OF_CH = 1;

	assign pll_locked_output = pll_locked;
	assign mcgb_rst          = pll_powerdown;
	
	generate
	if (NUM_OF_CH >= 1) begin
		assign pll_locked_a = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 2) begin
		assign pll_locked_b = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 3) begin
		assign pll_locked_c = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 4) begin
		assign pll_locked_d = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 5) begin
		assign pll_locked_e = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 6) begin
		assign pll_locked_f = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 7) begin
		assign pll_locked_g = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 8) begin
		assign pll_locked_h = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 9) begin
		assign pll_locked_i = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 10) begin
		assign pll_locked_j = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 11) begin
		assign pll_locked_k = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 12) begin
		assign pll_locked_l = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 13) begin
		assign pll_locked_m = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 14) begin
		assign pll_locked_n = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 15) begin
		assign pll_locked_o = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 16) begin
		assign pll_locked_p = pll_locked;
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 16)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k | pll_powerdown_l | pll_powerdown_m | pll_powerdown_n | pll_powerdown_o | pll_powerdown_p;
	else if (NUM_OF_CH >= 15)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k | pll_powerdown_l | pll_powerdown_m | pll_powerdown_n | pll_powerdown_o;
	else if (NUM_OF_CH >= 14)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k | pll_powerdown_l | pll_powerdown_m | pll_powerdown_n;
	else if (NUM_OF_CH >= 13)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k | pll_powerdown_l | pll_powerdown_m;
	else if (NUM_OF_CH >= 12)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k | pll_powerdown_l;
	else if (NUM_OF_CH >= 11)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j | pll_powerdown_k;
	else if (NUM_OF_CH >= 10)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i | pll_powerdown_j;
	else if (NUM_OF_CH >= 9)
        assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h | pll_powerdown_i;
    else if (NUM_OF_CH >= 8)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g | pll_powerdown_h;
	else if (NUM_OF_CH >= 7)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f | pll_powerdown_g;
	else if (NUM_OF_CH >= 6)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e | pll_powerdown_f;
	else if (NUM_OF_CH >= 5)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d | pll_powerdown_e;
	else if (NUM_OF_CH >= 4)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c | pll_powerdown_d;
	else if (NUM_OF_CH >= 3)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b | pll_powerdown_c;
	else if (NUM_OF_CH >= 2)
		assign pll_powerdown = pll_powerdown_a | pll_powerdown_b;
	else if (NUM_OF_CH >= 1)
		assign pll_powerdown = pll_powerdown_a;
	endgenerate

endmodule


