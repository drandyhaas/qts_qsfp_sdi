	component xcvr_test_system_data_pattern_checker_0 is
		port (
			csr_clk_clk                   : in  std_logic                      := 'X';             -- clk
			reset_reset                   : in  std_logic                      := 'X';             -- reset
			csr_slave_address             : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- address
			csr_slave_write               : in  std_logic                      := 'X';             -- write
			csr_slave_read                : in  std_logic                      := 'X';             -- read
			csr_slave_byteenable          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- byteenable
			csr_slave_writedata           : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			csr_slave_readdata            : out std_logic_vector(31 downto 0);                     -- readdata
			conduit_pattern_in_clk_export : in  std_logic                      := 'X';             -- export
			asi_data                      : in  std_logic_vector(127 downto 0) := (others => 'X')  -- export
		);
	end component xcvr_test_system_data_pattern_checker_0;

	u0 : component xcvr_test_system_data_pattern_checker_0
		port map (
			csr_clk_clk                   => CONNECTED_TO_csr_clk_clk,                   --                csr_clk.clk
			reset_reset                   => CONNECTED_TO_reset_reset,                   --                  reset.reset
			csr_slave_address             => CONNECTED_TO_csr_slave_address,             --              csr_slave.address
			csr_slave_write               => CONNECTED_TO_csr_slave_write,               --                       .write
			csr_slave_read                => CONNECTED_TO_csr_slave_read,                --                       .read
			csr_slave_byteenable          => CONNECTED_TO_csr_slave_byteenable,          --                       .byteenable
			csr_slave_writedata           => CONNECTED_TO_csr_slave_writedata,           --                       .writedata
			csr_slave_readdata            => CONNECTED_TO_csr_slave_readdata,            --                       .readdata
			conduit_pattern_in_clk_export => CONNECTED_TO_conduit_pattern_in_clk_export, -- conduit_pattern_in_clk.export
			asi_data                      => CONNECTED_TO_asi_data                       --     conduit_pattern_in.export
		);

