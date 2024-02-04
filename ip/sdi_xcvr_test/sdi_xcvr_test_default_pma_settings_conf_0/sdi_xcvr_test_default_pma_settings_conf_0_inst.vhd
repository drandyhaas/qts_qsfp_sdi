	component sdi_xcvr_test_default_pma_settings_conf_0 is
		port (
			clock            : in  std_logic                     := 'X';             -- clk
			reset_n          : in  std_logic                     := 'X';             -- reset_n
			master_wen       : out std_logic;                                        -- write_n
			master_oen       : out std_logic;                                        -- read_n
			master_be        : out std_logic_vector(3 downto 0);                     -- byteenable
			master_address   : out std_logic_vector(31 downto 0);                    -- address
			master_wdata     : out std_logic_vector(31 downto 0);                    -- writedata
			master_rdata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			readdatavalid_in : in  std_logic                     := 'X';             -- readdatavalid
			waitrequest_in   : in  std_logic                     := 'X';             -- waitrequest
			slave_read       : in  std_logic                     := 'X';             -- read
			slave_write      : in  std_logic                     := 'X';             -- write
			slave_readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			slave_writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			slave_address    : in  std_logic_vector(3 downto 0)  := (others => 'X')  -- address
		);
	end component sdi_xcvr_test_default_pma_settings_conf_0;

	u0 : component sdi_xcvr_test_default_pma_settings_conf_0
		port map (
			clock            => CONNECTED_TO_clock,            --         clock.clk
			reset_n          => CONNECTED_TO_reset_n,          --         reset.reset_n
			master_wen       => CONNECTED_TO_master_wen,       -- avalon_master.write_n
			master_oen       => CONNECTED_TO_master_oen,       --              .read_n
			master_be        => CONNECTED_TO_master_be,        --              .byteenable
			master_address   => CONNECTED_TO_master_address,   --              .address
			master_wdata     => CONNECTED_TO_master_wdata,     --              .writedata
			master_rdata     => CONNECTED_TO_master_rdata,     --              .readdata
			readdatavalid_in => CONNECTED_TO_readdatavalid_in, --              .readdatavalid
			waitrequest_in   => CONNECTED_TO_waitrequest_in,   --              .waitrequest
			slave_read       => CONNECTED_TO_slave_read,       --  avalon_slave.read
			slave_write      => CONNECTED_TO_slave_write,      --              .write
			slave_readdata   => CONNECTED_TO_slave_readdata,   --              .readdata
			slave_writedata  => CONNECTED_TO_slave_writedata,  --              .writedata
			slave_address    => CONNECTED_TO_slave_address     --              .address
		);

