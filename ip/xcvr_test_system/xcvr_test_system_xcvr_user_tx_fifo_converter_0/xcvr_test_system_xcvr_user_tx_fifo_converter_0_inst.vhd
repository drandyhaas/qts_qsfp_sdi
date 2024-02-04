	component xcvr_test_system_xcvr_user_tx_fifo_converter_0 is
		port (
			data_pattern_generator_pattern_out                : out std_logic_vector(63 downto 0);                     -- export
			data_pattern_generator_pattern_out_clk            : in  std_logic                      := 'X';             -- export
			data_pattern_generator_pattern_out_fifo_write_clk : in  std_logic                      := 'X';             -- export
			data_pattern_generator_pattern_out_fifo_write     : in  std_logic_vector(127 downto 0) := (others => 'X'); -- export
			data_pattern_generator_tx_fifo_rdempty            : out std_logic;                                         -- export
			data_pattern_generator_tx_fifo_wrfull             : out std_logic;                                         -- export
			data                                              : out std_logic_vector(127 downto 0);                    -- datain
			wrreq                                             : out std_logic;                                         -- wrreq
			rdreq                                             : out std_logic;                                         -- rdreq
			wrclk                                             : out std_logic;                                         -- wrclk
			rdclk                                             : out std_logic;                                         -- rdclk
			q                                                 : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- dataout
			rdempty                                           : in  std_logic                      := 'X';             -- rdempty
			wrfull                                            : in  std_logic                      := 'X'              -- wrfull
		);
	end component xcvr_test_system_xcvr_user_tx_fifo_converter_0;

	u0 : component xcvr_test_system_xcvr_user_tx_fifo_converter_0
		port map (
			data_pattern_generator_pattern_out                => CONNECTED_TO_data_pattern_generator_pattern_out,                --                data_pattern_generator_pattern_out.export
			data_pattern_generator_pattern_out_clk            => CONNECTED_TO_data_pattern_generator_pattern_out_clk,            --            data_pattern_generator_pattern_out_clk.export
			data_pattern_generator_pattern_out_fifo_write_clk => CONNECTED_TO_data_pattern_generator_pattern_out_fifo_write_clk, -- data_pattern_generator_pattern_out_fifo_write_clk.export
			data_pattern_generator_pattern_out_fifo_write     => CONNECTED_TO_data_pattern_generator_pattern_out_fifo_write,     --     data_pattern_generator_pattern_out_fifo_write.export
			data_pattern_generator_tx_fifo_rdempty            => CONNECTED_TO_data_pattern_generator_tx_fifo_rdempty,            --            data_pattern_generator_tx_fifo_rdempty.export
			data_pattern_generator_tx_fifo_wrfull             => CONNECTED_TO_data_pattern_generator_tx_fifo_wrfull,             --             data_pattern_generator_tx_fifo_wrfull.export
			data                                              => CONNECTED_TO_data,                                              --                                        fifo_input.datain
			wrreq                                             => CONNECTED_TO_wrreq,                                             --                                                  .wrreq
			rdreq                                             => CONNECTED_TO_rdreq,                                             --                                                  .rdreq
			wrclk                                             => CONNECTED_TO_wrclk,                                             --                                                  .wrclk
			rdclk                                             => CONNECTED_TO_rdclk,                                             --                                                  .rdclk
			q                                                 => CONNECTED_TO_q,                                                 --                                       fifo_output.dataout
			rdempty                                           => CONNECTED_TO_rdempty,                                           --                                                  .rdempty
			wrfull                                            => CONNECTED_TO_wrfull                                             --                                                  .wrfull
		);

