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


module intel_configuration_reset_release_for_debug
#(
   parameter DEVICE_FAMILY_ID = 2
)
(
   output wire conf_reset
);
   if(DEVICE_FAMILY_ID == 2) begin: s10 //stratix 10
      fourteennm_lsm_gpio_out 
      #(
         .bitpos       (19),
         .role         ("postuser"),
         .timingseq    (0)
      ) 
      lsm_gpo_out_user_reset 
      (
         .gpio_o        (conf_reset)
      );
   end
   else if(DEVICE_FAMILY_ID == 3) begin: ag //agilex
        fourteennm_sdm_gpio_out 
        #(
           .bitpos       (14),
           .role         ("USER_RESET")
        ) 
        sdm_gpo_out_user_reset 
        (
           .gpio_o        (conf_reset)
        );
   end
   else begin: universal
      lcell lc
      ( 
         .in(1'b0), 
         .out(conf_reset) 
      )/* synthesis altera_attribute = "-name PRESERVE_FANOUT_FREE_WYSIWYG ON" */;
   end
endmodule
