LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;
 
ENTITY tb_ShifterVariable IS
END tb_ShifterVariable;
 
ARCHITECTURE behavior OF tb_ShifterVariable IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ShifterVariable
	generic (
		N : natural := 64;
		M : natural := 6
	);
    PORT(
         I : IN  std_logic_vector(63 downto 0);
         O : OUT  std_logic_vector(63 downto 0);
         Left : IN  std_logic;
         Arith : IN  std_logic;
         Count : IN  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(63 downto 0) := (others => '0');
   signal Left : std_logic := '0';
   signal Arith : std_logic := '0';
   signal Count : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal O : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ShifterVariable PORT MAP (
          I => I,
          O => O,
          Left => Left,
          Arith => Arith,
          Count => Count
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;

		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000100";

		wait for 10 ns;
		
		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		Count <= "000100";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '0';
		Count <= "000001";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '0';
		Count <= "000001";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000011";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';

		wait for 10 ns;
		Count <= "000011";

		

		wait;
   end process;
   
END;