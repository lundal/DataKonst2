----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-29
-- 
-- Description: 
-- Pipeline register between Instruction Decode and Execute stages
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity id_ex is
    generic(
        PC_SIZE       : integer := IADDR_BUS;
        REG_SIZE      : integer := DDATA_BUS;
        REG_ADDR_SIZE : integer := RADDR_BUS
    );
    port( 
        -- EX control signals
        reg_dst_in  : in  STD_LOGIC;
        reg_dst_out : out STD_LOGIC;
        alu_op_in   : in  ALU_OP;
        alu_op_out  : out ALU_OP;
        alu_src_in  : in  STD_LOGIC;
        alu_src_out : out STD_LOGIC;
        
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
        pc_in   : in  STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        pc_out  : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        rs_in   : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rs_out  : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rt_in   : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rt_out  : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        imm_in  : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        imm_out : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        rta_in  : in  STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        rta_out : out STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        rda_in  : in  STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        rda_out : out STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
        
        -- Pipeline signals
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC
    );
end id_ex;

architecture Behavioral of id_ex is
begin
    process(clk, reset, enable, reg_dst_in, alu_op_in, alu_src_in, branch_in, mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in, pc_in, rs_in, rt_in, imm_in, rta_in, rda_in)
    begin
        if rising_edge(clk) and enable = '1' then
            if reset = '1' then
                -- EX
                reg_dst_out <= '0';
                alu_op_out <= ALUOP_FUNC;
                alu_src_out <= '0';
                
                -- MEM
                branch_out <= '0';
                mem_read_out <= '0';
                mem_write_out <= '0';
                
                -- WB
                reg_write_out <= '0';
                mem_to_reg_out <= '0';
                
                -- Signals
                pc_out <= (others => '0');
                rs_out <= (others => '0');
                rt_out <= (others => '0');
                imm_out <= (others => '0');
                rta_out <= (others => '0');
                rda_out <= (others => '0');
            else
                -- EX
                reg_dst_out <= reg_dst_in;
                alu_op_out <= alu_op_in;
                alu_src_out <= alu_src_in;
                
                -- MEM
                branch_out <= branch_in;
                mem_read_out <= mem_read_in;
                mem_write_out <= mem_write_in;
                
                -- WB
                reg_write_out <= reg_write_in;
                mem_to_reg_out <= mem_to_reg_in;
                
                -- Signals
                pc_out <= pc_in;
                rs_out <= rs_in;
                rt_out <= rt_in;
                imm_out <= imm_in;
                rta_out <= rta_in;
                rda_out <= rda_in;
            end if;
        end if;
    end process;
end Behavioral;
