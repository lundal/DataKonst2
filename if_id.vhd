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
    generic(
        PC_SIZE   : integer := IADDR_BUS;
        INST_SIZE : integer := IDATA_BUS
    );
    port( 
        -- Signals
        pc_in    : in  STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        pc_out   : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        inst_in  : in  STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
        inst_out : out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
        
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
            if enable = '0' then
                -- Do nothing
            elsif reset = '1' then
                -- Signals
                pc_out <= (others => '0');
                inst_out <= (others => '0');
            else
                -- Signals
                pc_out <= pc_in;
                inst_out <= inst_in;
            end if;
        end if;
    end process;
end Behavioral;
