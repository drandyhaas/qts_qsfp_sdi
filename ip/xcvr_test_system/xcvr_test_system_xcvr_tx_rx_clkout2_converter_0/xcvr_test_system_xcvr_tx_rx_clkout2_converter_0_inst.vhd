	component xcvr_test_system_xcvr_tx_rx_clkout2_converter_0 is
		port (
			rx_clkout2        : in  std_logic := 'X'; -- clk
			rx_clkout2_a      : out std_logic;        -- export
			rx_clkout2_b      : out std_logic;        -- export
			tx_clkout2        : in  std_logic := 'X'; -- clk
			tx_clkout2_a      : out std_logic;        -- export
			tx_clkout2_b      : out std_logic;        -- export
			tx_clkout2_sample : out std_logic         -- clk
		);
	end component xcvr_test_system_xcvr_tx_rx_clkout2_converter_0;

	u0 : component xcvr_test_system_xcvr_tx_rx_clkout2_converter_0
		port map (
			rx_clkout2        => CONNECTED_TO_rx_clkout2,        --        rx_clkout2.clk
			rx_clkout2_a      => CONNECTED_TO_rx_clkout2_a,      --      rx_clkout2_a.export
			rx_clkout2_b      => CONNECTED_TO_rx_clkout2_b,      --      rx_clkout2_b.export
			tx_clkout2        => CONNECTED_TO_tx_clkout2,        --        tx_clkout2.clk
			tx_clkout2_a      => CONNECTED_TO_tx_clkout2_a,      --      tx_clkout2_a.export
			tx_clkout2_b      => CONNECTED_TO_tx_clkout2_b,      --      tx_clkout2_b.export
			tx_clkout2_sample => CONNECTED_TO_tx_clkout2_sample  -- tx_clkout2_sample.clk
		);

