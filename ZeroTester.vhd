library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZeroTester is
	generic (N : integer := 64);
	port (
		I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Pos		:	out	STD_LOGIC;
		Zero	:	out	STD_LOGIC;
		Neg		:	out	STD_LOGIC
	);
end ZeroTester;

architecture Behavioral of ZeroTester is
	
begin
	Pos		<= '1' when not (I = (N-1 downto 0 => '0')) and I(N-1) = '0' else '0';
	Zero	<= '1' when I = (N-1 downto 0 => '0') else '0';
	Neg		<= '1' when I(N-1) = '1' else '0';
end Behavioral;

