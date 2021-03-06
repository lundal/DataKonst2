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
    port( 
        -- MEM control signals
        eq_in         : in  STD_LOGIC;
        eq_out        : out STD_LOGIC;
        slt_in        : in  STD_LOGIC;
        slt_out       : out STD_LOGIC;
        link_in       : in  STD_LOGIC;
        link_out      : out STD_LOGIC;
        jump_in       : in  JUMP_TYPE;
        jump_out      : out JUMP_TYPE;
        branch_in     : in  STD_LOGIC;
        branch_out    : out STD_LOGIC;
        mem_write_in  : in  STD_LOGIC;
        mem_write_out : out STD_LOGIC;
        
        -- WB Control signals
        reg_write_in   : in  STD_LOGIC;
        reg_write_out  : out STD_LOGIC;
        mem_to_reg_in  : in  STD_lOGIC;
        mem_to_reg_out : out STD_lOGIC;
        
        -- Signals
        pc_in   : in  STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        pc_out  : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        rs_in   : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        rs_out  : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        rt_in   : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        rt_out  : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        imm_in  : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        imm_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        res_in  : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        res_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        rda_in  : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        rda_out : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
        target_in  : in  STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
        target_out : out STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
        
        -- Pipeline signals
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC
    );
end ex_mem;

architecture Behavioral of ex_mem is
begin
    process(clk, reset, enable, eq_in, slt_in, link_in, jump_in, branch_in, mem_write_in, reg_write_in, mem_to_reg_in, pc_in, rs_in, rt_in, imm_in, res_in, rda_in, target_in)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- MEM
                eq_out <= '0';
                slt_out <= '0';
                link_out <= '0';
                jump_out <= NO_JUMP;
                branch_out <= '0';
                mem_write_out <= '0';
                
                -- WB
                reg_write_out <= '0';
                mem_to_reg_out <= '0';
                
                -- Signals
                pc_out <= (others => '0');
                rs_out <= (others => '0');
                rt_out <= (others => '0');
                imm_out <= (others => '0');
                res_out <= (others => '0');
                rda_out <= (others => '0');
                target_out <= (others => '0');
            elsif enable = '1' then
                -- MEM
                eq_out <= eq_in;
                slt_out <= slt_in;
                link_out <= link_in;
                jump_out <= jump_in;
                branch_out <= branch_in;
                mem_write_out <= mem_write_in;
                
                -- WB
                reg_write_out <= reg_write_in;
                mem_to_reg_out <= mem_to_reg_in;
                
                -- Signals
                pc_out <= pc_in;
                rs_out <= rs_in;
                rt_out <= rt_in;
                imm_out <= imm_in;
                res_out <= res_in;
                rda_out <= rda_in;
                target_out <= target_in;
            end if;
        end if;
    end process;
end Behavioral;

