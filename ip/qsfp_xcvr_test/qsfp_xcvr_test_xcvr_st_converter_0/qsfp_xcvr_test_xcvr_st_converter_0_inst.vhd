	component qsfp_xcvr_test_xcvr_st_converter_0 is
		port (
			tx_parallel_data   : out std_logic_vector(63 downto 0);                    -- tx_parallel_data
			tx_clkout          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			rx_parallel_data   : in  std_logic_vector(63 downto 0) := (others => 'X'); -- rx_parallel_data
			rx_clkout          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			rx_is_lockedtodata : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_is_lockedtodata
			tx_data_a          : in  std_logic_vector(63 downto 0) := (others => 'X'); -- export
			tx_clkout_a        : out std_logic;                                        -- export
			rx_data_a          : out std_logic_vector(63 downto 0);                    -- export
			rx_clkout_a        : out std_logic;                                        -- export
			test_reset_n_a     : out std_logic;                                        -- reset_n
			tx_clkout_a_output : out std_logic;                                        -- clk
			rx_clkout_a_output : out std_logic                                         -- clk
		);
	end component qsfp_xcvr_test_xcvr_st_converter_0;

	u0 : component qsfp_xcvr_test_xcvr_st_converter_0
		port map (
			tx_parallel_data   => CONNECTED_TO_tx_parallel_data,   --   tx_parallel_data.tx_parallel_data
			tx_clkout          => CONNECTED_TO_tx_clkout,          --          tx_clkout.clk
			rx_parallel_data   => CONNECTED_TO_rx_parallel_data,   --   rx_parallel_data.rx_parallel_data
			rx_clkout          => CONNECTED_TO_rx_clkout,          --          rx_clkout.clk
			rx_is_lockedtodata => CONNECTED_TO_rx_is_lockedtodata, -- rx_is_lockedtodata.rx_is_lockedtodata
			tx_data_a          => CONNECTED_TO_tx_data_a,          --          tx_data_a.export
			tx_clkout_a        => CONNECTED_TO_tx_clkout_a,        --        tx_clkout_a.export
			rx_data_a          => CONNECTED_TO_rx_data_a,          --          rx_data_a.export
			rx_clkout_a        => CONNECTED_TO_rx_clkout_a,        --        rx_clkout_a.export
			test_reset_n_a     => CONNECTED_TO_test_reset_n_a,     --     test_reset_n_a.reset_n
			tx_clkout_a_output => CONNECTED_TO_tx_clkout_a_output, -- tx_clkout_a_output.clk
			rx_clkout_a_output => CONNECTED_TO_rx_clkout_a_output  -- rx_clkout_a_output.clk
		);

