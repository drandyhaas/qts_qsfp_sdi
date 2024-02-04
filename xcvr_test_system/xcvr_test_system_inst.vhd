	component xcvr_test_system is
		port (
			clk_50_clk                                                                  : in  std_logic                     := 'X';             -- clk
			reset_50_reset_n                                                            : in  std_logic                     := 'X';             -- reset_n
			mm_bridge_0_s0_waitrequest                                                  : out std_logic;                                        -- waitrequest
			mm_bridge_0_s0_readdata                                                     : out std_logic_vector(31 downto 0);                    -- readdata
			mm_bridge_0_s0_readdatavalid                                                : out std_logic;                                        -- readdatavalid
			mm_bridge_0_s0_burstcount                                                   : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			mm_bridge_0_s0_writedata                                                    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			mm_bridge_0_s0_address                                                      : in  std_logic_vector(12 downto 0) := (others => 'X'); -- address
			mm_bridge_0_s0_write                                                        : in  std_logic                     := 'X';             -- write
			mm_bridge_0_s0_read                                                         : in  std_logic                     := 'X';             -- read
			mm_bridge_0_s0_byteenable                                                   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			mm_bridge_0_s0_debugaccess                                                  : in  std_logic                     := 'X';             -- debugaccess
			xcvr_tx_rx_clkout2_converter_0_rx_clkout2_clk                               : in  std_logic                     := 'X';             -- clk
			xcvr_tx_rx_clkout2_converter_0_tx_clkout2_clk                               : in  std_logic                     := 'X';             -- clk
			xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_export        : in  std_logic_vector(63 downto 0) := (others => 'X'); -- export
			xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk_export    : in  std_logic                     := 'X';             -- export
			xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_export     : out std_logic_vector(63 downto 0);                    -- export
			xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk_export : in  std_logic                     := 'X'              -- export
		);
	end component xcvr_test_system;

	u0 : component xcvr_test_system
		port map (
			clk_50_clk                                                                  => CONNECTED_TO_clk_50_clk,                                                                  --                                                               clk_50.clk
			reset_50_reset_n                                                            => CONNECTED_TO_reset_50_reset_n,                                                            --                                                             reset_50.reset_n
			mm_bridge_0_s0_waitrequest                                                  => CONNECTED_TO_mm_bridge_0_s0_waitrequest,                                                  --                                                       mm_bridge_0_s0.waitrequest
			mm_bridge_0_s0_readdata                                                     => CONNECTED_TO_mm_bridge_0_s0_readdata,                                                     --                                                                     .readdata
			mm_bridge_0_s0_readdatavalid                                                => CONNECTED_TO_mm_bridge_0_s0_readdatavalid,                                                --                                                                     .readdatavalid
			mm_bridge_0_s0_burstcount                                                   => CONNECTED_TO_mm_bridge_0_s0_burstcount,                                                   --                                                                     .burstcount
			mm_bridge_0_s0_writedata                                                    => CONNECTED_TO_mm_bridge_0_s0_writedata,                                                    --                                                                     .writedata
			mm_bridge_0_s0_address                                                      => CONNECTED_TO_mm_bridge_0_s0_address,                                                      --                                                                     .address
			mm_bridge_0_s0_write                                                        => CONNECTED_TO_mm_bridge_0_s0_write,                                                        --                                                                     .write
			mm_bridge_0_s0_read                                                         => CONNECTED_TO_mm_bridge_0_s0_read,                                                         --                                                                     .read
			mm_bridge_0_s0_byteenable                                                   => CONNECTED_TO_mm_bridge_0_s0_byteenable,                                                   --                                                                     .byteenable
			mm_bridge_0_s0_debugaccess                                                  => CONNECTED_TO_mm_bridge_0_s0_debugaccess,                                                  --                                                                     .debugaccess
			xcvr_tx_rx_clkout2_converter_0_rx_clkout2_clk                               => CONNECTED_TO_xcvr_tx_rx_clkout2_converter_0_rx_clkout2_clk,                               --                            xcvr_tx_rx_clkout2_converter_0_rx_clkout2.clk
			xcvr_tx_rx_clkout2_converter_0_tx_clkout2_clk                               => CONNECTED_TO_xcvr_tx_rx_clkout2_converter_0_tx_clkout2_clk,                               --                            xcvr_tx_rx_clkout2_converter_0_tx_clkout2.clk
			xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_export        => CONNECTED_TO_xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_export,        --        xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in.export
			xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk_export    => CONNECTED_TO_xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk_export,    --    xcvr_user_rx_fifo_converter_0_data_pattern_checker_pattern_in_clk.export
			xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_export     => CONNECTED_TO_xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_export,     --     xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out.export
			xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk_export => CONNECTED_TO_xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk_export  -- xcvr_user_tx_fifo_converter_0_data_pattern_generator_pattern_out_clk.export
		);

