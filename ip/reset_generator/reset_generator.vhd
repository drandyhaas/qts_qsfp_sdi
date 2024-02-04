library ieee;
use ieee.std_logic_1164.all;

entity reset_generator is
	port 
	(
		clk: in std_logic;
		reset_n_in : in std_logic;
		reset_n_out: out std_logic
	);
end reset_generator;


architecture rtl of reset_generator is
	signal ctr: integer range 0 to 511 := 0;
begin

	process(clk, reset_n_in)begin
		if(reset_n_in = '0')then
			ctr <= 0;
			reset_n_out <= '0';
		elsif(rising_edge(clk))then
			if(ctr = 511)then
				reset_n_out <= '1';
				ctr <= ctr;
			else
				reset_n_out <= '0';
				ctr <= ctr + 1;
			end if;
		end if;
	end process;
end rtl;