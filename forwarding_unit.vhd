----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-30
-- 
-- Description: 
-- A simple forwarding unit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity forwarding_unit is
    generic(
        REG_ADDR_SIZE : integer := RADDR_BUS
    );
    port( 
        -- Execute signals
        rs_addr : in STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        rt_addr : in STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        
        -- Later signals
        mem_write : in STD_LOGIC_VECTOR;
        mem_addr  : in STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        wb_write  : in STD_LOGIC_VECTOR;
        wb_addr   : in STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        
        -- Forwarding signals
        rs_forward : out STD_LOGIC_VECTOR(2-1 downto 0);
        rt_forward : out STD_LOGIC_VECTOR(2-1 downto 0)
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

end Behavioral;
