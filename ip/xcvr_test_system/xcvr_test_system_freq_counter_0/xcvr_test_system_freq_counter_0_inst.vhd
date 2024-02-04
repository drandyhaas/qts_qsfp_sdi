	component xcvr_test_system_freq_counter_0 is
		port (
			reset_n      : in  std_logic                     := 'X';             -- reset_n
			clk          : in  std_logic                     := 'X';             -- clk
			csr_address  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			csr_read     : in  std_logic                     := 'X';             -- read
			csr_readdata : out std_logic_vector(31 downto 0);                    -- readdata
			sample_clk   : in  std_logic                     := 'X'              -- clk
		);
	end component xcvr_test_system_freq_counter_0;

	u0 : component xcvr_test_system_freq_counter_0
		port map (
			reset_n      => CONNECTED_TO_reset_n,      --        reset.reset_n
			clk          => CONNECTED_TO_clk,          --        clock.clk
			csr_address  => CONNECTED_TO_csr_address,  --          csr.address
			csr_read     => CONNECTED_TO_csr_read,     --             .read
			csr_readdata => CONNECTED_TO_csr_readdata, --             .readdata
			sample_clk   => CONNECTED_TO_sample_clk    -- sample_clock.clk
		);

