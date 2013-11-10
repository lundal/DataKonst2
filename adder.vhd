library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Adder is
    generic (N : integer := 64);
    port (
        A        : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B        : in  STD_LOGIC_VECTOR(N-1 downto 0);
        R        : out STD_LOGIC_VECTOR(N-1 downto 0);
        CARRY_IN : in  STD_LOGIC
    );
end Adder;

architecture Behavioral of Adder is
begin
    -- Add, add, add, away!
    R <= A + B + CARRY_IN;
end Behavioral;
