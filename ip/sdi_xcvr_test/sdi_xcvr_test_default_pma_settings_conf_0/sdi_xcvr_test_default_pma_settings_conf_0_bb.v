module sdi_xcvr_test_default_pma_settings_conf_0 (
		input  wire        clock,            //         clock.clk
		input  wire        reset_n,          //         reset.reset_n
		output wire        master_wen,       // avalon_master.write_n
		output wire        master_oen,       //              .read_n
		output wire [3:0]  master_be,        //              .byteenable
		output wire [31:0] master_address,   //              .address
		output wire [31:0] master_wdata,     //              .writedata
		input  wire [31:0] master_rdata,     //              .readdata
		input  wire        readdatavalid_in, //              .readdatavalid
		input  wire        waitrequest_in,   //              .waitrequest
		input  wire        slave_read,       //  avalon_slave.read
		input  wire        slave_write,      //              .write
		output wire [31:0] slave_readdata,   //              .readdata
		input  wire [31:0] slave_writedata,  //              .writedata
		input  wire [3:0]  slave_address     //              .address
	);
endmodule

