	component q_sys is
		port (
			clk_100_clk                                                      : in  std_logic                    := 'X';             -- clk
			reset_100_reset_n                                                : in  std_logic                    := 'X';             -- reset_n
			clk_50_clk                                                       : in  std_logic                    := 'X';             -- clk
			reset_50_reset_n                                                 : in  std_logic                    := 'X';             -- reset_n
			q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked         : out std_logic_vector(0 downto 0);                    -- pll_locked
			q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked        : out std_logic_vector(0 downto 0);                    -- pll_locked
			qsfp_xcvr_atx_pll_refclk_in_clk_clk                              : in  std_logic                    := 'X';             -- clk
			qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data : in  std_logic_vector(0 downto 0) := (others => 'X')  -- rx_serial_data
		);
	end component q_sys;

	u0 : component q_sys
		port map (
			clk_100_clk                                                      => CONNECTED_TO_clk_100_clk,                                                      --                                           clk_100.clk
			reset_100_reset_n                                                => CONNECTED_TO_reset_100_reset_n,                                                --                                         reset_100.reset_n
			clk_50_clk                                                       => CONNECTED_TO_clk_50_clk,                                                       --                                            clk_50.clk
			reset_50_reset_n                                                 => CONNECTED_TO_reset_50_reset_n,                                                 --                                          reset_50.reset_n
			q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked         => CONNECTED_TO_q_sys_pll_status_interconnect_qsfp_pll_locked_pll_locked,         --     q_sys_pll_status_interconnect_qsfp_pll_locked.pll_locked
			q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked        => CONNECTED_TO_q_sys_pll_status_interconnect_qsfp_pll_locked1_pll_locked,        --    q_sys_pll_status_interconnect_qsfp_pll_locked1.pll_locked
			qsfp_xcvr_atx_pll_refclk_in_clk_clk                              => CONNECTED_TO_qsfp_xcvr_atx_pll_refclk_in_clk_clk,                              --                   qsfp_xcvr_atx_pll_refclk_in_clk.clk
			qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data => CONNECTED_TO_qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data_tx_serial_data, -- qsfp_xcvr_test_0_xcvr_native_s10_0_tx_serial_data.tx_serial_data
			qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data => CONNECTED_TO_qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data_rx_serial_data, -- qsfp_xcvr_test_0_xcvr_native_s10_0_rx_serial_data.rx_serial_data
			qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data => CONNECTED_TO_qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data_tx_serial_data, -- qsfp_xcvr_test_1_xcvr_native_s10_0_tx_serial_data.tx_serial_data
			qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data => CONNECTED_TO_qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data_rx_serial_data, -- qsfp_xcvr_test_1_xcvr_native_s10_0_rx_serial_data.rx_serial_data
			qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data => CONNECTED_TO_qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data_tx_serial_data, -- qsfp_xcvr_test_3_xcvr_native_s10_0_tx_serial_data.tx_serial_data
			qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data => CONNECTED_TO_qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data_rx_serial_data, -- qsfp_xcvr_test_3_xcvr_native_s10_0_rx_serial_data.rx_serial_data
			qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data => CONNECTED_TO_qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data_tx_serial_data, -- qsfp_xcvr_test_4_xcvr_native_s10_0_tx_serial_data.tx_serial_data
			qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data => CONNECTED_TO_qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data_rx_serial_data  -- qsfp_xcvr_test_4_xcvr_native_s10_0_rx_serial_data.rx_serial_data
		);

