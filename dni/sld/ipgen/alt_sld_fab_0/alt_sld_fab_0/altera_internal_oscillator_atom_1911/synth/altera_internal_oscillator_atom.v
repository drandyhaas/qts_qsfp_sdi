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


// $Id: //acds/main/ip/pgm/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap.sv#2 $
// $Revision: #2 $
// $Date: 2015/10/19 $
// $Author: tgngo $

`timescale 1 ps / 1 ps
(*altera_attribute = "-name INTERFACES \"\
{\
    'version' : '1',\
    'interfaces' : [\
        {\
            'type' : 'altera:instrumentation:generic_bp_promote:1.0',\
            'ports' : [\
                {\
                    'name' : 'clk',\
                    'role' : 's10_osc_clk'\
                }\
            ],\
            'parameters' : [\
                {\
                    'name' : 'SECTION_ID',\
                    'value' : '***reserved_s10_xcvr***'\
                }\
            ]\
        }\
    ]\
}\
\" -to |" *)
module  altera_internal_oscillator_atom
    ( 
    clk
    );

    parameter DEVICE_FAMILY   = " Stratix 10";
    output   clk;
    wire  wire_clk;
    assign clk = wire_clk;
        
    // -----------------------------------
    // Instantiate wysiwyg for oscillator
    // -----------------------------------
    fourteennm_sdm_oscillator oscillator_dut ( 
        .clkout(wire_clk),
        .clkout1()
    );
    
endmodule //altera_int_osc
//VALID FILE
