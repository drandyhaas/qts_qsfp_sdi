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

master_driver_com.v


Description:  
This component is simple sequencer to test out a communication interfaces.
It works with a set of Altera avalon data pattern generator/checker, which is packaged as sub Qsys module.

This components set pattern generator and checker, issue the transactions, checks the timer values and calculate the performance.

				0:csr_readdata <= { lock, status_int[1], 1'b0, error_status, system_status, process_start};
				1:csr_readdata <= contrl;
				2:csr_readdata <= data_ptn;
				3:csr_readdata <= transaction_counter[31:0];
				4:csr_readdata <= transaction_counter[63:32];
				5:csr_readdata <= freq;  // local side frequency
				6:csr_readdata <= freq_physical; // physycal side frequency
				7:csr_readdata <= MBps;
				8:csr_readdata <= timer_ns;
				9:csr_readdata <= error_counter[31:0];

Register map:
Address 0 = status			bit 5  lock status  bit 4 status_int[1]  bit 3  not in use  bit 2 error status  	bit 1  system running status	bit 0 process start/stop
Address 4 = contrl			bit 31  start/stop bit  	bit 8 issue reset bit(self clear)	bit 1  clear error bit 	bit 0 insert error 
Address 8 = data_ptn			bit5 Hi	bit4 Lo	bit3 PRBS31	bit2 PRBS23	bit1 PRBS15	bit0 PRBS7
Address 12= transaction_counter[31:0]		transaction counter low bit
Address 16= transaction_counter[63:32]		transaction counter high bit
Address 20= target_freq		Local bus side frequency   Kilo Herz
Address 24= freq_physical	Calculated physical side frequency baesd on the local frequency times factor of parallel  Kilo Herz
Address 28= MBps				Calculated Mega Byte per Sec  with 2 decimal points
Address 32= timer_ns			time that has used to process
Address 36= error_counter	error counter



There are 3 conduit signals that can be used for LED to indicate status.
lock 
error_mon 
status_mon 


Initial release 	1.0: 2013/2
						2.0: 2013/4/18	Comment added
						3.0: 2013/4/30 waitrequest_in changed to readdatavalid_in
											process_start is now controling the counter
						3.1: 2013/5/01 csr_waitrequest has dropped
						4.0: 2013/9/18 each read operation has to have more than 20 counts aptart
						4.1: 2013/9/19 added error reset right after all setup
						5.0: 2013/11/05 adding xcvr rx_lock to stop the counter

*/


module master_driver_com(
	input	reset_n,
	input	clk,
	
	input		[3:0]	csr_address,
	input				csr_read,
	input				csr_write,
	output reg[31:0]csr_readdata,
	input		[31:0]csr_writedata,
//	output			csr_waitrequest,

	input readdatavalid_in,
	input waitrequest_in,
//	output	reg master_csn,
	output	reg master_wen,
	output reg master_oen,
	output	reg [3:0]master_be,
	output	reg [31:0]master_address,
	output	reg [31:0]master_wdata,
	input [31:0] master_rdata,
	
	input		lock,
	output	error_mon,
	output	status_mon
	
	
);

	parameter CHECKER_BASE = 32'h00000020;
	parameter GENERATOR_BASE = 32'h00000000;
	parameter TIMER_BASE = 32'h00000100;
	parameter FREQ_BASE = 32'h00000200;
	parameter DESERIALIZATION_FACTOR = 32'h00000008;
	parameter NUM_OF_CH = 32'h000000010;
	parameter ENABLE_PER_INFO = 1;
	reg [19:0] count;



	reg [31:0] status;	
	reg [31:0] status_int;	
	reg [31:0] contrl;	
	reg [63:0] transaction_counter;	
	reg [63:0] error_counter;
	reg [63:0] pre_counter;	
	reg [63:0] delta_counter;	
	reg [63:0] delta_counter_int;
	reg [64:0] timer_int;	
	reg [64:0] timer;	
	reg [64:0] timer_diff;	
	reg [64:0] pre_timer;	
	reg [31:0] timer_ns;	
	reg [31:0] MBps;
	reg [63:0] MBps_int;
	reg [31:0] freq;
//	reg [31:0] freq_unit;
//	reg [63:0] max_perf;
//	reg [31:0] percent;
//	reg [63:0] processed_cycle;
	reg calc_start;
	reg [31:0] freq_physical;
	reg [31:0] data_ptn;
	reg [31:0] pre_data_ptn;
	reg data_change;
	reg power_on_enable;

	

	localparam ENABLE_CHECKER = 1;
	localparam ENABLE_GENERATOR = 20;
	localparam START_TIMER = 40; // 22 cycle
	localparam STOP_DATA = 100;
	localparam SNAP = 110;  // 6 cycles
	localparam CHECK_TEST = 120;  // 20 cycles
	localparam CHECK_TIMER = 160;
	localparam TIMER_READ = 210; // 40 cycle
	localparam ERROR_READ = 400; // 11 cycle
	localparam FREQ_READ = 500; //  cycle
	localparam ERROR_INS = 560; //  cycle	// error insertion or clear
	localparam DATA_CHNG = 580; //  cycle	// change data pattern
	localparam CONT = 600; //  cycle			// start/stop
	localparam CALC_START = 700; //+150


	
	
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			data_ptn <= 1;
		end else if(csr_write == 1)begin
			case(csr_address)
				2:data_ptn 	<= csr_writedata;
				default:
					;
			endcase
		end
	end

	
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			csr_readdata <= 0;
		end else if(csr_read == 1)begin
			case(csr_address)
				0:csr_readdata <= { lock, status_int[1], 1'b0, error_status, system_status, process_start};
				1:csr_readdata <= contrl;
				2:csr_readdata <= data_ptn;
				3:csr_readdata <= transaction_counter[31:0];
				4:csr_readdata <= transaction_counter[63:32];
				5:csr_readdata <= freq;  // local side frequency
				6:csr_readdata <= freq_physical; // physycal side frequency
				7:csr_readdata <= MBps;
				8:csr_readdata <= timer_ns;
				9:csr_readdata <= error_counter[31:0];
				10:csr_readdata <= count;
				default:csr_readdata <= 0;
			endcase
		end
	end
	
	
	always @(posedge clk or negedge reset_n)begin
		if(reset_n == 0)begin
			contrl <= 32'h00000000;
		end else begin
			if(count == ERROR_INS+6)begin
				contrl <= contrl & 32'hFFFFFFFC; // clear the ins/clear commands
			end else if(csr_write == 1 && csr_address == 1)begin
				contrl <= csr_writedata;			
			end
		end
	end

	always @(posedge clk or negedge reset_n)begin
		if(reset_n == 0)begin
			data_change <= 1; // default value is PRBS7
		end else begin
			if(pre_data_ptn == data_ptn)begin
				data_change <= 0;
			end else begin
				data_change <= 1;
			end
		end
	end

	always @(posedge clk or negedge reset_n)begin
		if(reset_n == 0)begin
			power_on_enable <= 0;
		end else begin
			if(process_start == 1)begin
				power_on_enable <= 1; 			
			end
		end
	end	
	
	always @(posedge clk or negedge reset_n)begin
		if(reset_n == 0)begin
			count <= 0;
		end
		else begin
			if(lock == 0 || power_on_enable == 0)begin
				count <= 0;
			end else if(count == 625000 && delta_counter == 0)begin // just to prevent synthesize away....
				count <= 97;
			end else if(count == 625000 && timer == 0)begin // just to prevent synthesize away....
				count <= 98;
//			end else if(count == 625000 && MBps == 0 && percent == 0 && processed_cycle == 0 && freq == 0 && error_counter == 0)begin // just to prevent synthesize away....
			end else if(count == 625000 && MBps == 0 && freq == 0 && error_counter == 0)begin // just to prevent synthesize away....
				count <= 98;
			end else if(count == 625000)begin
				if(process_start == 0)begin
					count <= 625000;
				end else begin 
					count <= 99;
				end
//			end else if(readdatavalid_in == 1 && master_csn == 0)begin
			end else if(readdatavalid_in == 0 && master_oen == 0)begin
				count <= count;
			end else begin
				count <= count + 1;
			end
		end
	end


	
	reg error_status;
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			error_status <= 0;
		end else if (error_counter != 0) begin
			error_status <= 1;
		end else begin
		  error_status <= 0;
		end
	end	

	reg system_status;
	reg [30:0] timeout_counter;
	always @ (posedge clk or negedge reset_n)begin
		if (reset_n == 0)begin
			timeout_counter <= 0;
			system_status <= 1;
		end else begin
			if(count == 99)begin
				timeout_counter <= 0;
				system_status <= 1;
			end else if(timeout_counter == 6250000)begin
				timeout_counter <= timeout_counter;
				system_status <= 0;
			end else begin
				timeout_counter <= timeout_counter + 1;
				system_status <= 1;
			end
		end
	end
	
	wire process_start;
	assign process_start = contrl[31];
	assign error_mon = error_status;		// goes to LED
	assign status_mon = !system_status;	// goes to LED
	
	
	
	generate
	
	reg [4:0] slow_clk_int;
	reg [3:0] slow_sequencer;
	wire slow_clk;
	
	if (ENABLE_PER_INFO==1) begin
		always @(posedge clk or negedge reset_n)begin
			if(reset_n == 0)begin
				slow_clk_int <= 0;
			end
			else begin
				if(slow_clk_int == 31)begin
					slow_clk_int <= 0;
				end else begin
					slow_clk_int <= slow_clk_int + 1;
				end
			end
		end	
	  
	  assign slow_clk = slow_clk_int[4];
	  
		always @(posedge slow_clk or negedge reset_n)begin
			if(reset_n == 0)begin
				slow_sequencer   <= 15;
			end
			else begin
				if(calc_start == 1)begin
					slow_sequencer   <= 0;
				end else if(slow_sequencer   == 15)begin
					slow_sequencer   <= 15;
				end else begin
					slow_sequencer   <= slow_sequencer   + 1;
				end
			end
		end	

	  
		always @(posedge slow_clk or negedge reset_n)begin
			if(reset_n == 0)begin
				delta_counter_int <= 0;
				delta_counter <= 0;
				pre_counter <= 0;
				timer <= 0;
				timer_ns <= 0;
				pre_timer <= 0;
				MBps_int <= 0;
				MBps <= 0;
//				freq_unit <= 0;
//				max_perf <= 0;
//				processed_cycle <= 0;
//				percent <= 0;
			end
			else begin
				if(slow_sequencer == 1)begin
					delta_counter_int <= (transaction_counter - pre_counter); // still in bit
				end else if(slow_sequencer == 2)begin
//					delta_counter <= delta_counter_int * 1000 / 8; // make it Bytes
					delta_counter <= delta_counter_int * 100000 / 8; // make it Bytes   to get 2 more decimal points in MBps
				end else if(slow_sequencer == 3)begin 
					pre_counter <= transaction_counter;
				end else if(slow_sequencer == 4)begin
					timer <= 64'hffffffffffffffff - timer_int;
				end else if(slow_sequencer == 5)begin
					timer_diff <= (timer - pre_timer);
				end else if(slow_sequencer == 6)begin
					timer_ns <= timer_diff * 20;
				end else if(slow_sequencer == 7)begin
					pre_timer <= timer;
				end else if(slow_sequencer == 8)begin
					MBps_int <= delta_counter / timer_ns;
				end else if(slow_sequencer == 9)begin
					MBps <= MBps_int;
				end else if(slow_sequencer == 10)begin
					freq_physical <= freq * DESERIALIZATION_FACTOR;
				end
			end
		end	
	end
	endgenerate
	




	
	
	always @(posedge clk or negedge reset_n)begin
		if(reset_n == 0)begin
//			master_csn <= 1'b1;
			master_wen <= 1'b1;
			master_oen <= 1'b1;
			master_address <= 0;
			master_wdata <= 0;
			master_be <= 0;
			transaction_counter <= 0;
			timer_int <= 0;
			freq <= 0;
			calc_start <= 0;
		end else begin
			case (count)

		
			ENABLE_CHECKER+8, ENABLE_CHECKER+9:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= CHECKER_BASE;
				master_wdata <= 32'h00000001;
				master_be <= 4'b1111;
			end

			ENABLE_GENERATOR, ENABLE_GENERATOR+1:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= GENERATOR_BASE;
				master_wdata <= 32'h00000001;
				master_be <= 4'b1111;
			end

			START_TIMER, START_TIMER+1:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 0;
				master_wdata <= 32'h0;
				master_be <= 4'b1111;
			end

			START_TIMER+5, START_TIMER+6:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 4;
				master_wdata <= 32'hA;
				master_be <= 4'b1111;
			end

			START_TIMER+10, START_TIMER+11:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 8;
				master_wdata <= 32'hFFFFFFFF;
				master_be <= 4'b1111;
			end

			START_TIMER+15, START_TIMER+16:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 12;
				master_wdata <= 32'hFFFFFFFF;
				master_be <= 4'b1111;
			end
			START_TIMER+18, START_TIMER+19:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 16;
				master_wdata <= 32'hFFFFFFFF;
				master_be <= 4'b1111;
			end

			START_TIMER+21, START_TIMER+22:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 20;
				master_wdata <= 32'hFFFFFFFF;
				master_be <= 4'b1111;
			end

			START_TIMER+24, START_TIMER+25:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 4;
				master_wdata <= 32'h6;
				master_be <= 4'b1111;
			end

			// need to clear out the error counter now.
			START_TIMER+27, START_TIMER+28:begin
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 8;
					master_wdata <= 32'h00000002;
					master_be <= 4'b1111;
			end
			
			STOP_DATA+0, STOP_DATA+1:begin
					//master_csn <= 1'b0;
					if(data_change == 1)begin 
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= GENERATOR_BASE + 0;
					master_wdata <= 0;
					master_be <= 4'b1111;
					end
			end
			STOP_DATA+3, STOP_DATA+4:begin
					//master_csn <= 1'b0;
					if(data_change == 1)begin 
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 0;
					master_wdata <= 0;
					master_be <= 4'b1111;
					end
			end						
			
			// issue SNAP command at here to capture the snap shot of result
			SNAP+0, SNAP+1:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= CHECKER_BASE + 8;
				master_wdata <= 32'h00000001;
				master_be <= 4'b1111;
			end
			SNAP+3, SNAP+4:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b0;
				master_oen <= 1'b1;
				master_address <= TIMER_BASE + 24; // write dummy data to take snapshot  64bit counter mode
				master_wdata <= 32'h00; // dummy
				master_be <= 4'b1111;
			end

			

//			CHECK_TEST+5,CHECK_TEST+6:begin
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= CHECKER_BASE;
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			CHECK_TEST+8,CHECK_TEST+9:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= CHECKER_BASE;
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					status_int[31:0] <= master_rdata[31:0];
				end
			end
			

//			CHECK_TEST+10,CHECK_TEST+11:begin
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= CHECKER_BASE + 12;
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			CHECK_TEST+28,CHECK_TEST+29:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= CHECKER_BASE + 12;
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					transaction_counter[31:0] <= master_rdata[31:0];
				end
			end
			
			
//			CHECK_TEST+15,CHECK_TEST+16:begin
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= CHECKER_BASE + 16;
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			CHECK_TEST+18,CHECK_TEST+19:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= CHECKER_BASE + 16;
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					transaction_counter[63:32] <= master_rdata[31:0];
				end
			end

			
			
//			TIMER_READ+10,TIMER_READ+11:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= TIMER_BASE + 24; // get timer data
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			TIMER_READ+3,TIMER_READ+4:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= TIMER_BASE + 24; // get timer data
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					timer_int[15:0] <= master_rdata[15:0];
				end
			end

//			TIMER_READ+20,TIMER_READ+21:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= TIMER_BASE + 28; // get timer data
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			TIMER_READ+23,TIMER_READ+24:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= TIMER_BASE + 28; // get timer data
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					timer_int[31:16] <= master_rdata[15:0];
				end
			end

//			TIMER_READ+26,TIMER_READ+27:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= TIMER_BASE + 32; // get timer data
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			TIMER_READ+43,TIMER_READ+44:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= TIMER_BASE + 32; // get timer data
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					timer_int[47:32] <= master_rdata[15:0];
				end
			end

//			TIMER_READ+32,TIMER_READ+33:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= TIMER_BASE + 36; // get timer data
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			TIMER_READ+63,TIMER_READ+64:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= TIMER_BASE + 36; // get timer data
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					timer_int[63:48] <= master_rdata[15:0];
				end
			end

			
//			ERROR_READ+0,ERROR_READ+1:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= CHECKER_BASE + 20; // get error count
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			ERROR_READ+3,ERROR_READ+4:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= CHECKER_BASE + 20; // get error count
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					error_counter[31:0] <= master_rdata[31:0];
				end
			end
//			ERROR_READ+6,ERROR_READ+7:begin // read takes more time, so assigning 3 stages
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_address <= CHECKER_BASE + 24; // get error count
//				master_be <= 4'b1111;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			ERROR_READ+23,ERROR_READ+24:begin // read takes more time, so assigning 3 stages
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_address <= CHECKER_BASE + 24; // get error count
				master_be <= 4'b1111;
				if(readdatavalid_in == 1)begin
					error_counter[63:32] <= master_rdata[31:0];
				end
			end

		
//			FREQ_READ+0, FREQ_READ+1:begin
//				//master_csn <= 1'b0;
//				master_wen <= 1'b1;
//				master_oen <= 1'b0;
//				master_be <= 4'b1111;
//				master_address <= FREQ_BASE;
//				if(readdatavalid_in != 1)begin
//					;
//				end
//			end
			FREQ_READ+3, FREQ_READ+4:begin
				//master_csn <= 1'b0;
				master_wen <= 1'b1;
				master_oen <= 1'b0;
				master_be <= 4'b1111;
				master_address <= FREQ_BASE;
				if(readdatavalid_in == 1)begin
					freq <= master_rdata;
				end
			end
			
			ERROR_INS+0, ERROR_INS+1:begin
				if(contrl[0] == 1)begin // insert error bit
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= GENERATOR_BASE + 8;
					master_wdata <= 32'h00000001;
					master_be <= 4'b1111;
				end
			end

			ERROR_INS+3, ERROR_INS+4:begin
				if(contrl[1] == 1)begin // clear error bit
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 8;
					master_wdata <= 32'h00000002;
					master_be <= 4'b1111;
				end
			end

			// change the data pattern
			DATA_CHNG+0, DATA_CHNG+1:begin
				if(data_change == 1)begin // clear error bit
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 4;
					master_wdata <= data_ptn;
					master_be <= 4'b1111;
				end
			end

			DATA_CHNG+3, DATA_CHNG+4:begin
				if(data_change == 1)begin // clear error bit
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= GENERATOR_BASE + 4;
					master_wdata <= data_ptn;
					master_be <= 4'b1111;
				end
			end
			DATA_CHNG+6, DATA_CHNG+7:begin
				if(data_change == 1)begin // clear error bit
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 8;
					master_wdata <= 32'h00000002;
					master_be <= 4'b1111;
				end
			end
			
			DATA_CHNG+8:begin
				pre_data_ptn <= data_ptn;
			end			

			CONT+0, CONT+1:begin
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= GENERATOR_BASE + 0;
					master_wdata <= contrl[31];
					master_be <= 4'b1111;
			end
			CONT+3, CONT+4:begin
					//master_csn <= 1'b0;
					master_wen <= 1'b0;
					master_oen <= 1'b1;
					master_address <= CHECKER_BASE + 0;
					master_wdata <= contrl[31];
					master_be <= 4'b1111;
			end

			CALC_START:begin
				calc_start <= 1;
			end
			CALC_START + 100:begin
				calc_start <= 0;
			end

			default:begin
				//master_csn <= 1'b1;
				master_wen <= 1'b1;
				master_oen <= 1'b1;
				master_address <= 0;
				master_wdata <= 0;
				master_be <= 4'b0000;
			end

			endcase
		end
	end
endmodule





