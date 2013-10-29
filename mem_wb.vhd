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
    generic(
        PC_SIZE       : integer := IADDR_BUS;
        REG_SIZE      : integer := DDATA_BUS;
        REG_ADDR_SIZE : integer := RADDR_BUS
    );
    port( 
        -- WB Control signals
        reg_write_in   : in  STD_LOGIC;
        reg_write_out  : out STD_LOGIC;
        mem_to_reg_in  : in  STD_lOGIC;
        mem_to_reg_out : out STD_lOGIC;
        
        -- Signals
        mem_in  : in  STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        mem_out : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        res_in  : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        res_out : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        wba_in  : in  STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        wba_out : out STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        
        -- Pipeline signals
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC
    );
end mem_wb;

architecture Behavioral of mem_wb is
begin
    process(clk, reset, enable, reg_write_in, mem_to_reg_in, mem_in, res_in, wba_in)
    begin
        if rising_edge(clk) and enable = '1' then
            if reset = '1' then
                -- WB
                reg_write_out <= '0';
                mem_to_reg_out <= '0';
                
                -- Signals
                mem_out <= (others => '0');
                res_out <= (others => '0');
                wba_out <= (others => '0');
            else
                -- WB
                reg_write_out <= reg_write_in;
                mem_to_reg_out <= mem_to_reg_in;
                
                -- Signals
                mem_out <= mem_in;
                res_out <= res_in;
                wba_out <= wba_in;
            end if;
        end if;
    end process;
end Behavioral;
