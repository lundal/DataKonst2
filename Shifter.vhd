library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;

entity Shifter is
	generic (
		N : natural := 64;
		M : natural := 1
	);
    port (
		I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		Left	:	in	STD_LOGIC;
		Arith	:	in	STD_LOGIC;
		Enable	:	in	STD_LOGIC
	);
end Shifter;

architecture Behavioral of Shifter is
	
begin
	process (I, Left, Arith, Enable) begin
		if Enable = '0' then
			O <= I;
		elsif Left = '1' then
			O <= std_logic_vector(SHIFT_LEFT(unsigned(I), M));
		elsif Arith = '1' then
			O <= std_logic_vector(SHIFT_RIGHT(signed(I), M));
		else
			O <= std_logic_vector(SHIFT_RIGHT(unsigned(I), M));
		end if;
	end process;
end Behavioral;

