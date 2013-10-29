----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-29
-- 
-- Description: 
-- Pipeline register between Execute and Memory stages
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity ex_mem is
    generic(
        PC_SIZE       : integer := IADDR_BUS;
        REG_SIZE      : integer := DDATA_BUS;
        REG_ADDR_SIZE : integer := RADDR_BUS
    );
    port( 
        -- MEM control signals
        branch_in     : in  STD_LOGIC;
        branch_out    : out STD_LOGIC;
        mem_read_in   : in  STD_LOGIC;
        mem_read_out  : out STD_LOGIC;
        mem_write_in  : in  STD_LOGIC;
        mem_write_out : out STD_LOGIC;
        
        -- WB Control signals
        reg_write_in   : in  STD_LOGIC;
        reg_write_out  : out STD_LOGIC;
        mem_to_reg_in  : in  STD_lOGIC;
        mem_to_reg_out : out STD_lOGIC;
        
        -- Signals
        zero_in  : in  STD_LOGIC;
        zero_out : out STD_LOGIC;
        pc_in    : in  STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        pc_out   : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        res_in   : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        res_out  : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rt_in    : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rt_out   : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        wba_in   : in  STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        wba_out  : out STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        
        -- Pipeline signals
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC
    );
end ex_mem;

architecture Behavioral of ex_mem is
begin
    process(clk, reset, enable, branch_in, mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in, zero_in, pc_in, res_in, rt_in, wba_in)
    begin
        if rising_edge(clk) and enable = '1' then
            if reset = '1' then
                -- MEM
                branch_out <= '0';
                mem_read_out <= '0';
                mem_write_out <= '0';
                
                -- WB
                reg_write_out <= '0';
                mem_to_reg_out <= '0';
                
                -- Signals
                zero_out <= '0';
                pc_out <= (others => '0');
                res_out <= (others => '0');
                rt_out <= (others => '0');
                wba_out <= (others => '0');
            else
                -- MEM
                branch_out <= branch_in;
                mem_read_out <= mem_read_in;
                mem_write_out <= mem_write_in;
                
                -- WB
                reg_write_out <= reg_write_in;
                mem_to_reg_out <= mem_to_reg_in;
                
                -- Signals
                zero_out <= zero_in;
                pc_out <= pc_in;
                res_out <= res_in;
                rt_out <= rt_in;
                wba_out <= wba_in;
            end if;
        end if;
    end process;
end Behavioral;
