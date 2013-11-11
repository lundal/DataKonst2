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

entity if_id is
    port( 
        -- Signals
        pc_in    : in  STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        pc_out   : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        inst_in  : in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        inst_out : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        -- Pipeline signals
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC
    );
end if_id;

architecture Behavioral of if_id is
begin
    process(clk, reset, enable, pc_in, inst_in)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Signals
                pc_out <= (others => '0');
                --inst_out <= (others => '0');
            elsif enable = '1' then
                -- Signals
                pc_out <= pc_in;
                --inst_out <= inst_in;
            end if;
        end if;
    end process;
    
    inst_out <= (others =>'0') when reset = '1' else inst_in;
    
end Behavioral;

