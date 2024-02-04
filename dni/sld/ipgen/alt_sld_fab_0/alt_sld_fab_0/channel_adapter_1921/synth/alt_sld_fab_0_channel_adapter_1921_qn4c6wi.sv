// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

 
// $Id: //acds/rel/13.1/ip/.../avalon-st_channel_adapter.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/09/09 $
// $Author: dmunday $

// --------------------------------------------------------------------------------
//| Avalon Streaming Channel Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps

// ------------------------------------------
// Generation parameters:
//   output_name:         alt_sld_fab_0_channel_adapter_1921_qn4c6wi
//   in_channel_width:    8
//   in_max_channel:      255
//   out_channel_width:   1
//   out_max_channel:     1
//   data_width:          1
//   error_width:         0
//   use_ready:           true
//   use_packets:         false
//   use_empty:           0
//   empty_width:         0

// ------------------------------------------

// altera message_off 13469

module alt_sld_fab_0_channel_adapter_1921_qn4c6wi 
(
 // Interface: in
 output reg         in_ready,
 input              in_valid,
 input              in_data,
 input [8-1: 0] in_channel,
 // Interface: out
 input               out_ready,
 output reg          out_valid,
 output reg          out_data,
 output reg          out_channel,
  // Interface: clk
 input              clk,
 // Interface: reset
 input              reset_n
 
 
);


   // ---------------------------------------------------------------------
   //| Payload Mapping
   // ---------------------------------------------------------------------
   always @* begin
      in_ready = out_ready;
      out_valid = in_valid;
      out_data = in_data;

      out_channel = in_channel[0];

      // Suppress channels that are higher than the destination's max_channel.
      if (in_channel > 1) begin
         out_valid = 0;
         // Simulation Message goes here.
      end
   end

endmodule

