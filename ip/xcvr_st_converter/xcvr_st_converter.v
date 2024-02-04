/*
This module is to convert XCVR native PHY signals to Qsys capable signals.
Converts conduit to Avalon-Streaming signals.



*/

module  xcvr_st_converter( 
	
	//local side
	input  [DATAWIDTH-1 : 0]tx_data_a,
	output reg [DATAWIDTH-1 : 0]rx_data_a,
	output tx_clkout_a,
	output rx_clkout_a,
	output test_reset_n_a,
	output tx_clkout_a_output,
	output rx_clkout_a_output,

	input  [DATAWIDTH-1 : 0]tx_data_b,
	output reg [DATAWIDTH-1 : 0]rx_data_b,
	output tx_clkout_b,
	output rx_clkout_b,
	output test_reset_n_b,
	output tx_clkout_b_output,
	output rx_clkout_b_output,

	input  [DATAWIDTH-1 : 0]tx_data_c,
	output reg [DATAWIDTH-1 : 0]rx_data_c,
	output tx_clkout_c,
	output rx_clkout_c,
	output test_reset_n_c,
	output tx_clkout_c_output,
	output rx_clkout_c_output,

	input  [DATAWIDTH-1 : 0]tx_data_d,
	output reg [DATAWIDTH-1 : 0]rx_data_d,
	output tx_clkout_d,
	output rx_clkout_d,
	output test_reset_n_d,
	output tx_clkout_d_output,
	output rx_clkout_d_output,

	input  [DATAWIDTH-1 : 0]tx_data_e,
	output reg [DATAWIDTH-1 : 0]rx_data_e,
	output tx_clkout_e,
	output rx_clkout_e,
	output test_reset_n_e,
	output tx_clkout_e_output,
	output rx_clkout_e_output,

	input  [DATAWIDTH-1 : 0]tx_data_f,
	output reg [DATAWIDTH-1 : 0]rx_data_f,
	output tx_clkout_f,
	output rx_clkout_f,
	output test_reset_n_f,
	output tx_clkout_f_output,
	output rx_clkout_f_output,

	input  [DATAWIDTH-1 : 0]tx_data_g,
	output reg [DATAWIDTH-1 : 0]rx_data_g,
	output tx_clkout_g,
	output rx_clkout_g,
	output test_reset_n_g,
	output tx_clkout_g_output,
	output rx_clkout_g_output,

	input  [DATAWIDTH-1 : 0]tx_data_h,
	output reg [DATAWIDTH-1 : 0]rx_data_h,
	output tx_clkout_h,
	output rx_clkout_h,
	output test_reset_n_h,
	output tx_clkout_h_output,
	output rx_clkout_h_output,

	
	//XCVR side
	input [NUM_OF_CH-1:0]tx_clkout,
	output reg [DATAWIDTH * NUM_OF_CH-1 : 0]tx_parallel_data,
	input [NUM_OF_CH-1:0]rx_clkout,
	input [DATAWIDTH * NUM_OF_CH-1 : 0]rx_parallel_data,
	input [NUM_OF_CH-1:0] rx_is_lockedtodata
	
);
	parameter DATAWIDTH = 40;
	parameter NUM_OF_CH = 1;

	always @(posedge tx_clkout[0])begin
		tx_parallel_data[DATAWIDTH-1:0] <= tx_data_a;
	end
	always @(posedge rx_clkout[0])begin
		rx_data_a <= rx_parallel_data[DATAWIDTH-1:0];
	end
	
	assign tx_clkout_a = tx_clkout[0];
	assign rx_clkout_a = rx_clkout[0];
	assign test_reset_n_a = rx_is_lockedtodata[0];
	assign tx_clkout_a_output = tx_clkout[0];
	assign rx_clkout_a_output = rx_clkout[0];

	generate
	if (NUM_OF_CH >= 2) begin
		always @(posedge tx_clkout[1])begin
			tx_parallel_data[DATAWIDTH*2-1:DATAWIDTH*1] <= tx_data_b;
		end
		always @(posedge rx_clkout[1])begin
			rx_data_b <= rx_parallel_data[DATAWIDTH*2-1:DATAWIDTH*1];
		end
		assign tx_clkout_b = tx_clkout[1];
		assign rx_clkout_b = rx_clkout[1];
		assign test_reset_n_b = rx_is_lockedtodata[1];
		assign tx_clkout_b_output = tx_clkout[1];
		assign rx_clkout_b_output = rx_clkout[1];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 3) begin
		always @(posedge tx_clkout[2])begin
			tx_parallel_data[DATAWIDTH*3-1:DATAWIDTH*2] <= tx_data_c;
		end
		always @(posedge rx_clkout[2])begin
			rx_data_c <= rx_parallel_data[DATAWIDTH*3-1:DATAWIDTH*2];
		end
		assign tx_clkout_c = tx_clkout[2];
		assign rx_clkout_c = rx_clkout[2];
		assign test_reset_n_c = rx_is_lockedtodata[2];
		assign tx_clkout_c_output = tx_clkout[2];
		assign rx_clkout_c_output = rx_clkout[2];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 4) begin
		always @(posedge tx_clkout[3])begin
			tx_parallel_data[DATAWIDTH*4-1:DATAWIDTH*3] <= tx_data_d;
		end
		always @(posedge rx_clkout[3])begin
			rx_data_d <= rx_parallel_data[DATAWIDTH*4-1:DATAWIDTH*3];
		end
		assign tx_clkout_d = tx_clkout[3];
		assign rx_clkout_d = rx_clkout[3];
		assign test_reset_n_d = rx_is_lockedtodata[3];
		assign tx_clkout_d_output = tx_clkout[3];
		assign rx_clkout_d_output = rx_clkout[3];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 5) begin
		always @(posedge tx_clkout[4])begin
			tx_parallel_data[DATAWIDTH*5-1:DATAWIDTH*4] <= tx_data_e;
		end
		always @(posedge rx_clkout[4])begin
			rx_data_e <= rx_parallel_data[DATAWIDTH*5-1:DATAWIDTH*4];
		end
		assign tx_clkout_e = tx_clkout[4];
		assign rx_clkout_e = rx_clkout[4];
		assign test_reset_n_e = rx_is_lockedtodata[4];
		assign tx_clkout_e_output = tx_clkout[4];
		assign rx_clkout_e_output = rx_clkout[4];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 6) begin
		always @(posedge tx_clkout[5])begin
			tx_parallel_data[DATAWIDTH*6-1:DATAWIDTH*5] <= tx_data_f;
		end
		always @(posedge rx_clkout[5])begin
			rx_data_f <= rx_parallel_data[DATAWIDTH*6-1:DATAWIDTH*5];
		end
		assign tx_clkout_f = tx_clkout[5];
		assign rx_clkout_f = rx_clkout[5];
		assign test_reset_n_f = rx_is_lockedtodata[5];
		assign tx_clkout_f_output = tx_clkout[5];
		assign rx_clkout_f_output = rx_clkout[5];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 7) begin
		always @(posedge tx_clkout[6])begin
			tx_parallel_data[DATAWIDTH*7-1:DATAWIDTH*6] <= tx_data_g;
		end
		always @(posedge rx_clkout[6])begin
			rx_data_g <= rx_parallel_data[DATAWIDTH*7-1:DATAWIDTH*6];
		end
		assign tx_clkout_g = tx_clkout[6];
		assign rx_clkout_g = rx_clkout[6];
		assign test_reset_n_g = rx_is_lockedtodata[6];
		assign tx_clkout_g_output = tx_clkout[6];
		assign rx_clkout_g_output = rx_clkout[6];
	end
	endgenerate

	generate
	if (NUM_OF_CH >= 8) begin
		always @(posedge tx_clkout[7])begin
			tx_parallel_data[DATAWIDTH*8-1:DATAWIDTH*7] <= tx_data_h;
		end
		always @(posedge rx_clkout[7])begin
			rx_data_h <= rx_parallel_data[DATAWIDTH*8-1:DATAWIDTH*7];
		end
		assign tx_clkout_h = tx_clkout[7];
		assign rx_clkout_h = rx_clkout[7];
		assign test_reset_n_h = rx_is_lockedtodata[7];
		assign tx_clkout_h_output = tx_clkout[7];
		assign rx_clkout_h_output = rx_clkout[7];
	end
	endgenerate

endmodule


