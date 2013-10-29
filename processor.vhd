----------------------------------------------------------------------------------
-- Engineer: Zirgon
-- Project:  DataKonst2
-- Created:  2013-10-29
-- 
-- Description: 
-- A pipelined processor using a subset of the MIPS instruction set.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
    generic(
        PC_SIZE   : integer := IADDR_BUS;
        INST_SIZE : integer := IDATA_BUS;
        REG_SIZE      : integer := DDATA_BUS;
        REG_ADDR_SIZE : integer := RADDR_BUS
    );
    port( 
        clk               : in  STD_LOGIC;
        reset             : in  STD_LOGIC;
        processor_enable  : in  STD_LOGIC;
        imem_address      : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
        imem_data_in      : in  STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
        dmem_data_in      : in  STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        dmem_address      : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0); --TODO
        dmem_address_wr   : out STD_LOGIC_VECTOR(PC_SIZE-1 downto 0); --TODO
        dmem_data_out     : out STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
        dmem_write_enable : out STD_LOGIC
    );
end processor;

architecture Behavioral of processor is
    component if_id is
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
    end component;

    component id_ex is
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
    end component;
    
    component ex_mem is
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
    end component;
    
    component mem_wb is
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
    end component;
    
    component register_file is
        port(
            CLK        : in  STD_LOGIC;
            RESET      : in  STD_LOGIC;
            RW         : in  STD_LOGIC;
            RS_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            RT_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            RD_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            WRITE_DATA : in  STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
            RS         : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
            RT         : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0)
        );
    end component;
    
    component alu is
        generic (N: NATURAL := DDATA_BUS);
        port(
            X      : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Y      : in  STD_LOGIC_VECTOR(N-1 downto 0);
            ALU_IN : in  ALU_INPUT;
            R      : out STD_LOGIC_VECTOR(N-1 downto 0);
            FLAGS  : out ALU_FLAGS
        );
    end component;
    
    component adder is
        generic (N: natural := MEM_DATA_BUS);    
        port(
            X    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Y    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            CIN  : in  STD_LOGIC;
            COUT : out STD_LOGIC;
            R    : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    -- IF signals
    signal if_pc   : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal if_pc_1 : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    
    -- ID control signals
    signal idc_reg_dst    : in  STD_LOGIC;
    signal idc_alu_op     : in  ALU_OP;
    signal idc_alu_src    : in  STD_LOGIC;
    signal idc_branch     : in  STD_LOGIC;
    signal idc_mem_read   : in  STD_LOGIC;
    signal idc_mem_write  : in  STD_LOGIC;
    signal idc_reg_write  : in  STD_LOGIC;
    signal idc_mem_to_reg : in  STD_lOGIC;
    
    -- ID signals
    signal id_pc     : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal id_inst   : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    signal id_opcode : STD_LOGIC_VECTOR(6-1 downto 0);
    signal id_func   : STD_LOGIC_VECTOR(6-1 downto 0);
    signal id_rs     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal id_rt     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal id_rsa    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal id_rta    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal id_rda    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal id_imm    : STD_LOGIC_VECTOR(16-1 downto 0);
    signal id_imm_x  : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    
    -- EX control signals
    signal idc_reg_dst    : in  STD_LOGIC;
    signal idc_alu_op     : in  ALU_OP;
    signal idc_alu_src    : in  STD_LOGIC;
    signal idc_branch     : in  STD_LOGIC;
    signal idc_mem_read   : in  STD_LOGIC;
    signal idc_mem_write  : in  STD_LOGIC;
    signal idc_reg_write  : in  STD_LOGIC;
    signal idc_mem_to_reg : in  STD_lOGIC;
    
    -- EX signals
    signal ex_pc     : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal ex_target : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal ex_rs     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal ex_rt     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal ex_imm_x  : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal ex_rta    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal ex_rda    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal ex_wba    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal ex_res    : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal ex_zero   : STD_LOGIC;
    
    -- MEM control signals
    signal idc_branch     : in  STD_LOGIC;
    signal idc_mem_read   : in  STD_LOGIC;
    signal idc_mem_write  : in  STD_LOGIC;
    signal idc_reg_write  : in  STD_LOGIC;
    signal idc_mem_to_reg : in  STD_lOGIC;
    
    -- MEM signals
    signal mem_target : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal mem_mem    : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_rt     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_wba    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal mem_res    : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_zero   : STD_LOGIC;
    
    -- WB control signals
    signal idc_reg_write  : in  STD_LOGIC;
    signal idc_mem_to_reg : in  STD_lOGIC;
    
    -- WB signals
    signal wb_mem : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal wb_res : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal wb_wba : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal wb_wb  : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    
begin

end Behavioral;
