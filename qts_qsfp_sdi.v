module qts_qsfp_sdi (
        //System clock and reset
//---------------clk---------------
    input           clk_fpga_100m,
    input           clk_50,

//---------------i2c---------------  
    output          lt_io_scl,
    inout           lt_io_sda,

//------------cpu_reset------------
    input           cpu_resetn,
  
//--------user_led_dip_pb----------
    output [ 3:0]   user_led_g,
    output [ 3:0]   user_led_r,
    input  [ 3:0]   user_dipsw,
    input  [ 2:0]   user_pb,  

//---------------ref---------------
    input           refclk_qsfp_p,
    input           refclk_sdi_p,
 
//---------------sdi---------------    
    input   [ 1:0]  sdi_rx_p,
    output  [ 1:0]  sdi_tx_p,

    output          sdi_tx_sd_hdn,
    output          sdi_mf0_bypass,
    output          sdi_mf1_auto_sleep,
    output          sdi_mf2_mute,
    output          sdi_clk148_up,
    output          sdi_clk148_down,

//---------------qsfp--------------     
    input  [ 3:0]   qsfp_rx_p,
    output [ 3:0]   qsfp_tx_p, 
 
    input           qsfp_interruptn,
    input           qsfp_mod_prsn,
    output          qsfp_scl,
    inout           qsfp_sda,
    output          qsfp_mod_seln,     
    output          qsfp_lp_mode,
    output          qsfp_rstn
);

    wire            qsfp_xcvr_atx_pll_locked;
  wire            qsfp_xcvr_atx_pll_locked1;
    wire  [ 3:0]    qsfp_test_xcvr_rx_is_lockedtoref;
    wire            sdi_xcvr_atx_pll_locked;
    wire            sdi_test_0_xcvr_rx_is_lockedtoref;
  
    reg   [26:0]    heart_beat_cnt;
   reg[26:0] cnt_1s         ;
   reg[26:0] system_reset_n ;


    //cnt logic
    always @(posedge clk_50 or negedge cpu_resetn)
            if (!cpu_resetn)
                cnt_1s <= 27'h0; //0x7FF_FFFF
            else if(cnt_1s <= 27'h700_0000) //2.3s
                cnt_1s <= cnt_1s + 1'b1;
    
    //reset logic
    always @(posedge clk_50 or negedge cpu_resetn)
            if (!cpu_resetn)
                system_reset_n <= 1'h0; //0x7FF_FFFF
            else if(cnt_1s == 27'h700_0000) //2.3s
                system_reset_n <= 1'b1;
    
   //glue logic for heart beat
    always @(posedge clk_50 or negedge cpu_resetn)
        if (!cpu_resetn)
            heart_beat_cnt <= 27'h0;
        else
            heart_beat_cnt <= heart_beat_cnt + 1'b1;
    
    q_sys q_sys_i  (
        .qsfp_xcvr_atx_pll_refclk_in_clk_clk                              (refclk_qsfp_p           ), //                                    atx_pll_1k_refclk_in_clk.clk
        .sdi_xcvr_atx_pll_refclk_in_clk_clk                               (refclk_sdi_p            ), //                                    atx_pll_1n_refclk_in_clk.clk
        .clk_100_clk                                                      (clk_fpga_100m           ), //                                                     clk_100.clk
        .reset_100_reset_n                                                (system_reset_n          ), //                                               clk_100_reset.reset_n
        .clk_50_clk                                                       (clk_50                  ), //                                                      clk_50.clk
        .reset_50_reset_n                                                 (system_reset_n          ), //                                                clk_50_reset.reset_n
        .qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data (qsfp_rx_p[0]            ), // qsfp_xcvr_system_bank_1k_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data (qsfp_tx_p[0]            ), // qsfp_xcvr_system_bank_1k_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data (qsfp_rx_p[3]            ), // qsfp_xcvr_system_bank_1k_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data (qsfp_tx_p[3]            ), // qsfp_xcvr_system_bank_1k_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data (qsfp_rx_p[2]            ), // qsfp_xcvr_system_bank_1k_3_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data (qsfp_tx_p[2]            ), // qsfp_xcvr_system_bank_1k_3_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data (qsfp_rx_p[1]            ), // qsfp_xcvr_system_bank_1k_4_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data (qsfp_tx_p[1]            ), // qsfp_xcvr_system_bank_1k_4_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked        (qsfp_xcvr_atx_pll_locked1),
        .q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked         (qsfp_xcvr_atx_pll_locked), //               qsfp_xcvr_system_pll_status_pll_locked_output.pll_locked
        .sdi_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data  (sdi_rx_p[0]             ), //  sdi_xcvr_system_bank_1n_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .sdi_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data  (sdi_tx_p[0]             ), //  sdi_xcvr_system_bank_1n_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .sdi_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data  (sdi_rx_p[1]             ), //  sdi_xcvr_system_bank_1n_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
        .sdi_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data  (sdi_tx_p[1]             ), //  sdi_xcvr_system_bank_1n_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
        .q_sys_pll_status_interconnect_sdi_pll_locked_pll_locked          (sdi_xcvr_atx_pll_locked )  //                sdi_xcvr_system_pll_status_pll_locked_output.pll_locked
    );

    assign qsfp_lp_mode        = 0;
    assign qsfp_mod_seln       = 1'b1;
    assign qsfp_rstn           = cpu_resetn;
    assign qsfp_sda            = 1'bz;
    assign qsfp_scl            = 1'bz;
    
    assign sdi_tx_sd_hdn       = 1'b0;
    assign sdi_mf0_bypass      = 1'b0;
    assign sdi_mf1_auto_sleep  = 1'b0;
    assign sdi_mf2_mute        = 1'b0;
    assign sdi_clk148_up       = 1'b1;
    assign sdi_clk148_down     = 1'b1; 
    
    assign lt_io_scl           =  1'bz;
    assign lt_io_sda           =  1'bz;
    
    assign user_led_g[0]       =  !qsfp_xcvr_atx_pll_locked;
    assign user_led_g[1]       =  !sdi_xcvr_atx_pll_locked;
    assign user_led_g[2]       =  !qsfp_xcvr_atx_pll_locked1;
    assign user_led_g[3]       =  heart_beat_cnt[26];
                               
    assign user_led_r[3:0]     =  8'hFF;

endmodule

