----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-29
-- 
-- Description: 
-- Pipeline register between Memory and WriteBack stages
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity mem_wb is
    port( 
        -- WB Control signals
        reg_write_in   : in  STD_LOGIC;
        reg_write_out  : out STD_LOGIC;
        mem_to_reg_in  : in  STD_lOGIC;
        mem_to_reg_out : out STD_lOGIC;
        
        -- Signals
        res_in  : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        res_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        mem_in  : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        mem_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        rda_in  : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        rda_out : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        
        -- Pipeline signals
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC
    );
end mem_wb;

architecture Behavioral of mem_wb is
begin
    process(clk, reset, enable, reg_write_in, mem_to_reg_in, res_in, mem_in, rda_in)
    begin
        if reset = '1' then
            -- WB
            reg_write_out <= '0';
            mem_to_reg_out <= '0';
            
            -- Signals
            res_out <= (others => '0');
            mem_out <= (others => '0');
            rda_out <= (others => '0');
        elsif rising_edge(clk) and enable = '1' then
            -- WB
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            
            -- Signals
            res_out <= res_in;
            mem_out <= mem_in;
            rda_out <= rda_in;
        end if;
    end process;
end Behavioral;

