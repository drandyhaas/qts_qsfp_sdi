	component sdi_xcvr_test_nativePHY_loopback_cont_0 is
		port (
			reset_n             : in  std_logic                     := 'X';             -- reset_n
			clk                 : in  std_logic                     := 'X';             -- clk
			csr_address         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			csr_read            : in  std_logic                     := 'X';             -- read
			csr_write           : in  std_logic                     := 'X';             -- write
			csr_readdata        : out std_logic_vector(31 downto 0);                    -- readdata
			csr_writedata       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			pll_locked          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- pll_locked
			rx_is_lockedtoref   : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_is_lockedtoref
			rx_seriallpbken     : out std_logic_vector(0 downto 0);                     -- rx_seriallpbken
			rx_seriallpbken_mon : out std_logic_vector(0 downto 0)                      -- export
		);
	end component sdi_xcvr_test_nativePHY_loopback_cont_0;

	u0 : component sdi_xcvr_test_nativePHY_loopback_cont_0
		port map (
			reset_n             => CONNECTED_TO_reset_n,             --               reset.reset_n
			clk                 => CONNECTED_TO_clk,                 --               clock.clk
			csr_address         => CONNECTED_TO_csr_address,         --                 csr.address
			csr_read            => CONNECTED_TO_csr_read,            --                    .read
			csr_write           => CONNECTED_TO_csr_write,           --                    .write
			csr_readdata        => CONNECTED_TO_csr_readdata,        --                    .readdata
			csr_writedata       => CONNECTED_TO_csr_writedata,       --                    .writedata
			pll_locked          => CONNECTED_TO_pll_locked,          --          pll_locked.pll_locked
			rx_is_lockedtoref   => CONNECTED_TO_rx_is_lockedtoref,   --   rx_is_lockedtoref.rx_is_lockedtoref
			rx_seriallpbken     => CONNECTED_TO_rx_seriallpbken,     --     rx_seriallpbken.rx_seriallpbken
			rx_seriallpbken_mon => CONNECTED_TO_rx_seriallpbken_mon  -- rx_seriallpbken_mon.export
		);

