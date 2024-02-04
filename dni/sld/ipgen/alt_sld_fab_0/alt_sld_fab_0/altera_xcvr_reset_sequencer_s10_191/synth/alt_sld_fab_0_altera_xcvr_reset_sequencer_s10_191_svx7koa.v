
(*altera_attribute = "-name SDC_STATEMENT \"if {[get_collection_size [get_clocks altera_int_osc_clk -nowarn]] == 0} {create_clock -name altera_int_osc_clk -period 4.000 [get_nodes [get_entity_instances {altera_internal_oscillator_atom}]*|oscillator_dut~oscillator_clock]}; set alt_xcvr_reset_seq_entity_inst [get_entity_instances {altera_xcvr_reset_sequencer_s10}]; set alt_xcvr_reset_seq_entity_inst_list [split $alt_xcvr_reset_seq_entity_inst |]; set alt_xcvr_reset_seq_entity_inst_list  [lreplace $alt_xcvr_reset_seq_entity_inst_list end end]; set alt_xcvr_reset_seq_entity_inst_final_name [join $alt_xcvr_reset_seq_entity_inst_list |]; if { [get_collection_size [get_nodes -nowarn $alt_xcvr_reset_seq_entity_inst_final_name*alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk]] > 0 } { create_generated_clock -name ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk -divide_by 2 -source [get_nodes [get_entity_instances {altera_internal_oscillator_atom}]*|oscillator_dut~oscillator_clock] [get_pins -compat -nowarn $alt_xcvr_reset_seq_entity_inst_final_name*alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk|q] }\"" *)
module alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa (
    input wire osc_clk_in,
    output wire clk_out_0,
    output wire clk_out_1,
    input wire reset_req_2,
    output wire reset_ack_2,
    output wire clk_out_2,
    input wire reset_req_3,
    output wire reset_ack_3,
    output wire clk_out_3,
    input wire reset_req_4,
    output wire reset_ack_4,
    output wire clk_out_4,
    input wire reset_req_5,
    output wire reset_ack_5,
    output wire clk_out_5,
    output wire clk_out_6,
    output wire clk_out_7,
    input wire reset_req_8,
    output wire reset_ack_8,
    output wire clk_out_8,
    input wire reset_req_9,
    output wire reset_ack_9,
    output wire clk_out_9,
    input wire reset_req_10,
    output wire reset_ack_10,
    output wire clk_out_10,
    input wire reset_req_11,
    output wire reset_ack_11,
    output wire clk_out_11,
    output wire clk_out_12,
    output wire clk_out_13,
    input wire reset_req_14,
    output wire reset_ack_14,
    output wire clk_out_14,
    input wire reset_req_15,
    output wire reset_ack_15,
    output wire clk_out_15,
    input wire reset_req_16,
    output wire reset_ack_16,
    output wire clk_out_16,
    input wire reset_req_17,
    output wire reset_ack_17,
    output wire clk_out_17,
    output wire clk_out_18,
    output wire clk_out_19,
    input wire reset_req_20,
    output wire reset_ack_20,
    output wire clk_out_20,
    input wire reset_req_21,
    output wire reset_ack_21,
    output wire clk_out_21,
    input wire reset_req_22,
    output wire reset_ack_22,
    output wire clk_out_22,
    input wire reset_req_23,
    output wire reset_ack_23,
    output wire clk_out_23,
    output wire clk_out_24,
    input wire reset_req_25,
    output wire reset_ack_25,
    output wire clk_out_25,
    input wire reset_req_26,
    output wire reset_ack_26,
    output wire clk_out_26,
    input wire reset_req_27,
    output wire reset_ack_27,
    output wire clk_out_27,
    input wire reset_req_28,
    output wire reset_ack_28,
    output wire clk_out_28,
    output wire clk_out_29,
    input wire reset_req_30,
    output wire reset_ack_30,
    output wire clk_out_30,
    input wire reset_req_31,
    output wire reset_ack_31,
    output wire clk_out_31,
    input wire reset_req_32,
    output wire reset_ack_32,
    output wire clk_out_32,
    input wire reset_req_33,
    output wire reset_ack_33,
    output wire clk_out_33
);


  wire [24-1:0] reset_req;
  wire [24-1:0] reset_ack;

  // Assigning clk sources
  (*altera_attribute = "-name GLOBAL_SIGNAL GLOBAL_CLOCK"*)
  wire osc_clk_in_int /* synthesis keep */;

  wire divided_osc_clk_in /* synthesis keep */;

  // Dividing SDM oscillator clock frequency in half for 125 MHz (100 MHz in ND5 ES)
  reg alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk = 1'b0 /* synthesis preserve */;

  always@(posedge osc_clk_in) begin
   alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk <= ~divided_osc_clk_in;
  end

  assign divided_osc_clk_in = alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk;
  assign osc_clk_in_int = alt_sld_fab_0_altera_xcvr_reset_sequencer_s10_191_svx7koa_divided_osc_clk;


  // Assignments to break apart the bus
  assign clk_out_0 = osc_clk_in_int;
  assign clk_out_1 = osc_clk_in_int;
  assign reset_req[0]  = reset_req_2;
  assign reset_ack_2  = reset_ack[0];
  assign clk_out_2 = osc_clk_in_int;
  assign reset_req[1]  = reset_req_3;
  assign reset_ack_3  = reset_ack[1];
  assign clk_out_3 = osc_clk_in_int;
  assign reset_req[2]  = reset_req_4;
  assign reset_ack_4  = reset_ack[2];
  assign clk_out_4 = osc_clk_in_int;
  assign reset_req[3]  = reset_req_5;
  assign reset_ack_5  = reset_ack[3];
  assign clk_out_5 = osc_clk_in_int;
  assign clk_out_6 = osc_clk_in_int;
  assign clk_out_7 = osc_clk_in_int;
  assign reset_req[4]  = reset_req_8;
  assign reset_ack_8  = reset_ack[4];
  assign clk_out_8 = osc_clk_in_int;
  assign reset_req[5]  = reset_req_9;
  assign reset_ack_9  = reset_ack[5];
  assign clk_out_9 = osc_clk_in_int;
  assign reset_req[6]  = reset_req_10;
  assign reset_ack_10  = reset_ack[6];
  assign clk_out_10 = osc_clk_in_int;
  assign reset_req[7]  = reset_req_11;
  assign reset_ack_11  = reset_ack[7];
  assign clk_out_11 = osc_clk_in_int;
  assign clk_out_12 = osc_clk_in_int;
  assign clk_out_13 = osc_clk_in_int;
  assign reset_req[8]  = reset_req_14;
  assign reset_ack_14  = reset_ack[8];
  assign clk_out_14 = osc_clk_in_int;
  assign reset_req[9]  = reset_req_15;
  assign reset_ack_15  = reset_ack[9];
  assign clk_out_15 = osc_clk_in_int;
  assign reset_req[10]  = reset_req_16;
  assign reset_ack_16  = reset_ack[10];
  assign clk_out_16 = osc_clk_in_int;
  assign reset_req[11]  = reset_req_17;
  assign reset_ack_17  = reset_ack[11];
  assign clk_out_17 = osc_clk_in_int;
  assign clk_out_18 = osc_clk_in_int;
  assign clk_out_19 = osc_clk_in_int;
  assign reset_req[12]  = reset_req_20;
  assign reset_ack_20  = reset_ack[12];
  assign clk_out_20 = osc_clk_in_int;
  assign reset_req[13]  = reset_req_21;
  assign reset_ack_21  = reset_ack[13];
  assign clk_out_21 = osc_clk_in_int;
  assign reset_req[14]  = reset_req_22;
  assign reset_ack_22  = reset_ack[14];
  assign clk_out_22 = osc_clk_in_int;
  assign reset_req[15]  = reset_req_23;
  assign reset_ack_23  = reset_ack[15];
  assign clk_out_23 = osc_clk_in_int;
  assign clk_out_24 = osc_clk_in_int;
  assign reset_req[16]  = reset_req_25;
  assign reset_ack_25  = reset_ack[16];
  assign clk_out_25 = osc_clk_in_int;
  assign reset_req[17]  = reset_req_26;
  assign reset_ack_26  = reset_ack[17];
  assign clk_out_26 = osc_clk_in_int;
  assign reset_req[18]  = reset_req_27;
  assign reset_ack_27  = reset_ack[18];
  assign clk_out_27 = osc_clk_in_int;
  assign reset_req[19]  = reset_req_28;
  assign reset_ack_28  = reset_ack[19];
  assign clk_out_28 = osc_clk_in_int;
  assign clk_out_29 = osc_clk_in_int;
  assign reset_req[20]  = reset_req_30;
  assign reset_ack_30  = reset_ack[20];
  assign clk_out_30 = osc_clk_in_int;
  assign reset_req[21]  = reset_req_31;
  assign reset_ack_31  = reset_ack[21];
  assign clk_out_31 = osc_clk_in_int;
  assign reset_req[22]  = reset_req_32;
  assign reset_ack_32  = reset_ack[22];
  assign clk_out_32 = osc_clk_in_int;
  assign reset_req[23]  = reset_req_33;
  assign reset_ack_33  = reset_ack[23];
  assign clk_out_33 = osc_clk_in_int;


  altera_xcvr_reset_sequencer_s10
  #(
    .CLK_FREQ_IN_HZ              ( 125000000 ),
    .RESET_SEPARATION_NS         ( 200       ),
    .NUM_RESETS                  ( 24       )        // total number of resets to sequence
                                                            // rx/tx_analog, pll_powerdown
  ) altera_reset_sequencer (
    // Input clock
    .osc_clk_in                  ( osc_clk_in_int ),       // Connect to OSC_CLK_1
    // Reset requests and acknowledgements
    .reset_req                   ( reset_req      ),
    .reset_ack                   ( reset_ack      )
  );
endmodule

