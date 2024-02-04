//Description:  
//
//Register map:
//Address 0 = status&contrl                     bit0 --- set default pma parameters. This bit self clears.    bit1 --- done 
//Address 4 = vod      
//Address 8 = pre_1st      
//Address 12= pre_2nd    
//Address 16= post_1st    
//Address 20= post_2nd    
//Address 24= ctle_1s_enable  
//Address 28= ctle_1s 
//Address 32= ctle_4s 
//Address 36= dcgain_l8
//Address 40= dcgain_h4        
//Address 44= vga      

module default_pma_settings_conf (
  input               clock,
  input               reset_n,  
  input      [ 3:0]   slave_address,
  input               slave_read,
  input               slave_write,
  output reg [31:0]   slave_readdata,
  input      [31:0]   slave_writedata,
//output              slave_waitrequest,

  input               readdatavalid_in,
  input               waitrequest_in,
  output reg          master_wen,
  output reg          master_oen,
  output reg [ 3:0]   master_be,
  output reg [31:0]   master_address,
  output reg [31:0]   master_wdata,
  input      [31:0]   master_rdata 
);

  parameter  XCVR_RECONFIG_BASE_ADDR      = 32'h00000000;
  parameter  XCVR_VOD_ADDR                = 32'h424;
  parameter  XCVR_PRE_1ST_ADDR            = 32'h41C;
  parameter  XCVR_PRE_2ND_ADDR            = 32'h420;
  parameter  XCVR_POST_1ST_ADDR           = 32'h414;
  parameter  XCVR_POST_2ND_ADDR           = 32'h418;
  parameter  XCVR_CTLE_1S_ENABLE_ADDR     = 32'h46C;
  parameter  XCVR_CTLE_1S_ADDR            = 32'h598;
  parameter  XCVR_CTLE_4S_ADDR            = 32'h59C;
  parameter  XCVR_DCGAIN_L8_ADDR          = 32'h468;
  parameter  XCVR_DCGAIN_H4_ADDR          = 32'h470;
  parameter  XCVR_VGA_ADDR                = 32'h580;

  reg        process_start                = 1'b0;
  reg [31:0] vod;      
  reg [31:0] pre_1st                      = 32'b0;      
  reg [31:0] pre_2nd                      = 32'b0;    
  reg [31:0] post_1st                     = 32'b0;    
  reg [31:0] post_2nd                     = 32'b0;    
  reg [31:0] ctle_1s_enable               = 32'b0;  
  reg [31:0] ctle_1s                      = 32'b0; 
  reg [31:0] ctle_4s                      = 32'b0; 
  reg [31:0] dcgain_l8                    = 32'b0;     
  reg [31:0] dcgain_h4                    = 32'b0;   
  reg [31:0] vga                          = 32'b0;
  reg        process_done                 = 1'b0;     
  reg        r_master_wen;
  reg        r_master_oen;
  reg [ 3:0] r_master_be;
  reg [31:0] r_master_address;
  reg [31:0] r_master_wdata;
  
  localparam P_VOD            = 150;
  localparam P_PRE_1ST        = 180;
  localparam P_PRE_2ND        = 210;
  localparam P_POST_1ST       = 240;
  localparam P_POST_2ND       = 270; 
  localparam P_CTLE_1S_ENABLE = 300; 
  localparam P_CTLE_1S        = 330;
  localparam P_CTLE_4S        = 360; 
  localparam P_DCGAIN_L8      = 390; 
  localparam P_DCGAIN_H4      = 420; 
  localparam P_VGA            = 450;
  localparam P_PROC_END       = 611;  

  reg [9:0]  count                        = 10'b0;  
  
  always @ (posedge clock or negedge reset_n)begin
    if (reset_n == 0)begin
      slave_readdata <= 0;
    end else if(slave_read == 1)begin
      case(slave_address)
        0 :slave_readdata <= {30'b0, process_done, process_start};
        1 :slave_readdata <= vod;
        2 :slave_readdata <= pre_1st;
        3 :slave_readdata <= pre_2nd;
        4 :slave_readdata <= post_1st;
        5 :slave_readdata <= post_2nd;
        6 :slave_readdata <= ctle_1s_enable;
        7 :slave_readdata <= ctle_1s;
        8 :slave_readdata <= ctle_4s;
		9 :slave_readdata <= dcgain_l8;
		10:slave_readdata <= dcgain_h4;		
		11:slave_readdata <= vga;
        default:slave_readdata <= 0;
      endcase
    end
  end   
  
  always @(posedge clock )begin
	if (count == P_PROC_END) begin
 	  process_done  <= 1'b1;
	end
  end   
  
  always @(posedge clock)begin
    if(readdatavalid_in == 0 && master_oen == 0)begin
      count <= count;
    end else if (count != P_PROC_END) begin
      count <= count + 1;
    end
  end
  
  always @(posedge clock or negedge reset_n)begin
    if(reset_n == 0)begin
      master_wen       <= 1'b1;
      master_oen       <= 1'b1;
      master_address   <= 32'b0;
      master_wdata     <= 32'b0;
      master_be        <= 4'b0;
    end else begin
      case (count)  
      P_VOD, P_VOD+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_VOD_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          vod          <= master_rdata;
        end		
      end

      P_PRE_1ST, P_PRE_1ST+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_PRE_1ST_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          pre_1st      <= master_rdata;
        end	
      end
	  
      P_PRE_2ND, P_PRE_2ND+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_PRE_2ND_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          pre_2nd      <= master_rdata;
        end	
      end	  

      P_POST_1ST, P_POST_1ST+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_POST_1ST_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          post_1st     <= master_rdata;
        end	
      end
	  
      P_POST_2ND, P_POST_2ND+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_POST_2ND_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          post_2nd     <= master_rdata;
        end	
      end
	  
      P_CTLE_1S_ENABLE, P_CTLE_1S_ENABLE+1:begin
        master_wen       <= 1'b1;
        master_oen       <= 1'b0;
        master_address   <= XCVR_RECONFIG_BASE_ADDR + XCVR_CTLE_1S_ENABLE_ADDR;
        master_be        <= 4'b1111;
        if(readdatavalid_in == 1)begin
          ctle_1s_enable <= master_rdata;
        end	
      end	  
	  
      P_CTLE_1S, P_CTLE_1S+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_CTLE_1S_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          ctle_1s      <= master_rdata;
        end	
      end	  
	  
      P_CTLE_4S, P_CTLE_4S+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_CTLE_4S_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          ctle_4s      <= master_rdata;
        end	
      end	  
	  
      P_DCGAIN_L8, P_DCGAIN_L8+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_DCGAIN_L8_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          dcgain_l8    <= master_rdata;
        end	
      end	  
	  
      P_DCGAIN_H4, P_DCGAIN_H4+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_DCGAIN_H4_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          dcgain_h4    <= master_rdata;
        end	
      end	  
	  
      P_VGA, P_VGA+1:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b0;
        master_address <= XCVR_RECONFIG_BASE_ADDR + XCVR_VGA_ADDR;
        master_be      <= 4'b1111;
        if(readdatavalid_in == 1)begin
          vga          <= master_rdata;
        end	
      end	  

      default:begin
        master_wen     <= 1'b1;
        master_oen     <= 1'b1;
        master_address <= {32{1'b0}};
        master_wdata   <= {32{1'b0}};
        master_be      <= 4'b0;
      end
      endcase
    end
  end
  
endmodule





