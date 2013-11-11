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
        -- Requested
        rs_addr  : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        rt_addr  : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        
        -- From mem
        mem_addr  : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        mem_write : in STD_LOGIC;
        
        -- From wb
        wb_addr  : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        wb_write : in STD_LOGIC;
        
        -- Forwarding
        forward_rs : out FORWARD_TYPE;
        forward_rt : out FORWARD_TYPE
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

end Behavioral;
