----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-29
-- 
-- Description: 
-- Pipeline register between Instruction Fetch and Instruction Decode stages
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity pc is
    port( 
        -- Signals
        pc_in    : in  STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        pc_out   : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        
        -- Pipeline signals
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC
    );
end pc;

architecture Behavioral of pc is
begin
    process(clk, reset, enable, pc_in)
    begin
        if reset = '1' then
            -- Signals
            pc_out <= (others => '0');
        elsif rising_edge(clk) and enable = '1' then
            -- Signals
            pc_out <= pc_in;
        end if;
    end process;
end Behavioral;

