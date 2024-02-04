/*
  Legal Notice: (C)2013 Altera Corporation. All rights reserved.  Your
  use of Altera Corporation's design tools, logic functions and other
  software and tools, and its AMPP partner logic functions, and any
  output files any of the foregoing (including device programming or
  simulation files), and any associated documentation or information are
  expressly subject to the terms and conditions of the Altera Program
  License Subscription Agreement or other applicable license agreement,
  including, without limitation, that your use is for the sole purpose
  of programming logic devices manufactured by Altera and sold by Altera
  or its authorized distributors.  Please refer to the applicable
  agreement for further details.
*/


/*

nativePHY_loopback_cont.v


Description:  
This component generates CSR to control serial loopback of the NativePHY

				0:csr_readdata <= loopback status in each CH
				1:csr_readdata <= contrl in each CH

Register map:
Address 0 = status			bit 31..0 loopback status      0: default(no loopback)   1:loopback mode
Address 4 = contrl			bit 31..0 serial-loopback control bit   0: default(no loopback)   1:loopback mode

Initial release 	1.0: 2013/8

*/


module nativePHY_loopback_cont(
	input	reset_n,
	input	clk,
	
	input		[3:0]	csr_address,
	input				csr_read,
	input				csr_write,
	output reg[31:0]csr_readdata,
	input		[31:0]csr_writedata,

	input  [NUM_OF_CH-1:0]pll_locked,
	input  [NUM_OF_CH-1:0]rx_is_lockedtoref,
	output [NUM_OF_CH-1:0]rx_seriallpbken,
	output [NUM_OF_CH-1:0]rx_seriallpbken_mon
	
	
);

	parameter NUM_OF_CH = 1;

	reg [31:0] contrl;
	
	assign rx_seriallpbken_mon = rx_seriallpbken;

	
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			contrl <= 0;
		end else if(csr_write == 1)begin
			case(csr_address)
				1:contrl 	<= csr_writedata;
				default:
					;
			endcase
		end
	end
	
	assign rx_seriallpbken = contrl;

	
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			csr_readdata <= 0;
		end else if(csr_read == 1)begin
			case(csr_address)
				0:csr_readdata <= contrl;
				1:csr_readdata <= {{{32-NUM_OF_CH}{1'b0}}, pll_locked};
				2:csr_readdata <= {{{32-NUM_OF_CH}{1'b0}}, rx_is_lockedtoref};
				default:csr_readdata <= 0;
			endcase
		end
	end
	
endmodule





