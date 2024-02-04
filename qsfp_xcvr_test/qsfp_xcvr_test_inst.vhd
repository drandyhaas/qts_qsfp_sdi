	component qsfp_xcvr_test is
		port (
			clk_100_clk                                     : in  std_logic                     := 'X';             -- clk
			reset_100_reset_n                               : in  std_logic                     := 'X';             -- reset_n
			clk_50_clk                                      : in  std_logic                     := 'X';             -- clk
			reset_50_reset_n                                : in  std_logic                     := 'X';             -- reset_n
			mm_bridge_0_s0_waitrequest                      : out std_logic;                                        -- waitrequest
			mm_bridge_0_s0_readdata                         : out std_logic_vector(31 downto 0);                    -- readdata
			mm_bridge_0_s0_readdatavalid                    : out std_logic;                                        -- readdatavalid
			mm_bridge_0_s0_burstcount                       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			mm_bridge_0_s0_writedata                        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			mm_bridge_0_s0_address                          : in  std_logic_vector(14 downto 0) := (others => 'X'); -- address
			mm_bridge_0_s0_write                            : in  std_logic                     := 'X';             -- write
			mm_bridge_0_s0_read                             : in  std_logic                     := 'X';             -- read
			mm_bridge_0_s0_byteenable                       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			mm_bridge_0_s0_debugaccess                      : in  std_logic                     := 'X';             -- debugaccess
			pll_locked_pll_locked_pll_locked                : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- pll_locked
			xcvr_native_s10_0_tx_serial_clk0_clk            : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			xcvr_native_s10_0_tx_serial_clk1_clk            : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			xcvr_native_s10_0_rx_cdr_refclk0_clk            : in  std_logic                     := 'X';             -- clk
			xcvr_native_s10_0_tx_serial_data_tx_serial_data : out std_logic_vector(0 downto 0);                     -- tx_serial_data
			xcvr_native_s10_0_rx_serial_data_rx_serial_data : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- rx_serial_data
		);
	end component qsfp_xcvr_test;

	u0 : component qsfp_xcvr_test
		port map (
			clk_100_clk                                     => CONNECTED_TO_clk_100_clk,                                     --                          clk_100.clk
			reset_100_reset_n                               => CONNECTED_TO_reset_100_reset_n,                               --                        reset_100.reset_n
			clk_50_clk                                      => CONNECTED_TO_clk_50_clk,                                      --                           clk_50.clk
			reset_50_reset_n                                => CONNECTED_TO_reset_50_reset_n,                                --                         reset_50.reset_n
			mm_bridge_0_s0_waitrequest                      => CONNECTED_TO_mm_bridge_0_s0_waitrequest,                      --                   mm_bridge_0_s0.waitrequest
			mm_bridge_0_s0_readdata                         => CONNECTED_TO_mm_bridge_0_s0_readdata,                         --                                 .readdata
			mm_bridge_0_s0_readdatavalid                    => CONNECTED_TO_mm_bridge_0_s0_readdatavalid,                    --                                 .readdatavalid
			mm_bridge_0_s0_burstcount                       => CONNECTED_TO_mm_bridge_0_s0_burstcount,                       --                                 .burstcount
			mm_bridge_0_s0_writedata                        => CONNECTED_TO_mm_bridge_0_s0_writedata,                        --                                 .writedata
			mm_bridge_0_s0_address                          => CONNECTED_TO_mm_bridge_0_s0_address,                          --                                 .address
			mm_bridge_0_s0_write                            => CONNECTED_TO_mm_bridge_0_s0_write,                            --                                 .write
			mm_bridge_0_s0_read                             => CONNECTED_TO_mm_bridge_0_s0_read,                             --                                 .read
			mm_bridge_0_s0_byteenable                       => CONNECTED_TO_mm_bridge_0_s0_byteenable,                       --                                 .byteenable
			mm_bridge_0_s0_debugaccess                      => CONNECTED_TO_mm_bridge_0_s0_debugaccess,                      --                                 .debugaccess
			pll_locked_pll_locked_pll_locked                => CONNECTED_TO_pll_locked_pll_locked_pll_locked,                --            pll_locked_pll_locked.pll_locked
			xcvr_native_s10_0_tx_serial_clk0_clk            => CONNECTED_TO_xcvr_native_s10_0_tx_serial_clk0_clk,            -- xcvr_native_s10_0_tx_serial_clk0.clk
			xcvr_native_s10_0_tx_serial_clk1_clk            => CONNECTED_TO_xcvr_native_s10_0_tx_serial_clk1_clk,            -- xcvr_native_s10_0_tx_serial_clk1.clk
			xcvr_native_s10_0_rx_cdr_refclk0_clk            => CONNECTED_TO_xcvr_native_s10_0_rx_cdr_refclk0_clk,            -- xcvr_native_s10_0_rx_cdr_refclk0.clk
			xcvr_native_s10_0_tx_serial_data_tx_serial_data => CONNECTED_TO_xcvr_native_s10_0_tx_serial_data_tx_serial_data, -- xcvr_native_s10_0_tx_serial_data.tx_serial_data
			xcvr_native_s10_0_rx_serial_data_rx_serial_data => CONNECTED_TO_xcvr_native_s10_0_rx_serial_data_rx_serial_data  -- xcvr_native_s10_0_rx_serial_data.rx_serial_data
		);

