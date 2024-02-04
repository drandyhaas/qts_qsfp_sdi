	component qsfp_xcvr_test_pll_status_interconnect_0 is
		port (
			pll_locked        : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_locked
			pll_powerdown     : out std_logic_vector(0 downto 0);                    -- pll_powerdown
			mcgb_rst          : out std_logic_vector(0 downto 0);                    -- mcgb_rst
			pll_locked_output : out std_logic_vector(0 downto 0);                    -- pll_locked
			pll_locked_a      : out std_logic_vector(0 downto 0);                    -- pll_locked
			pll_powerdown_a   : in  std_logic_vector(0 downto 0) := (others => 'X')  -- pll_powerdown
		);
	end component qsfp_xcvr_test_pll_status_interconnect_0;

	u0 : component qsfp_xcvr_test_pll_status_interconnect_0
		port map (
			pll_locked        => CONNECTED_TO_pll_locked,        --        pll_locked.pll_locked
			pll_powerdown     => CONNECTED_TO_pll_powerdown,     --     pll_powerdown.pll_powerdown
			mcgb_rst          => CONNECTED_TO_mcgb_rst,          --          mcgb_rst.mcgb_rst
			pll_locked_output => CONNECTED_TO_pll_locked_output, -- pll_locked_output.pll_locked
			pll_locked_a      => CONNECTED_TO_pll_locked_a,      --      pll_locked_a.pll_locked
			pll_powerdown_a   => CONNECTED_TO_pll_powerdown_a    --   pll_powerdown_a.pll_powerdown
		);

