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
    RS : process (rs_addr, mem_addr, mem_write, wb_addr, wb_write)
    begin
        if rs_addr = (REG_ADDR_WIDTH-1 downto 0 => '0') then
            forward_rs <= NO_FORWARD;
        elsif rs_addr = mem_addr and mem_write = '1' then
            forward_rs <= FORWARD_MEM;
        elsif rs_addr = wb_addr and wb_write = '1' then
            forward_rs <= FORWARD_WB;
        else
            forward_rs <= NO_FORWARD;
        end if;
    end process;
    
    RT : process (rt_addr, mem_addr, mem_write, wb_addr, wb_write)
    begin
        if rt_addr = (REG_ADDR_WIDTH-1 downto 0 => '0') then
            forward_rt <= NO_FORWARD;
        elsif rt_addr = mem_addr and mem_write = '1' then
            forward_rt <= FORWARD_MEM;
        elsif rt_addr = wb_addr and wb_write = '1' then
            forward_rt <= FORWARD_WB;
        else
            forward_rt <= NO_FORWARD;
        end if;
    end process;
end Behavioral;
