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
--use IEEE.STD_LOGIC_ARITH.ALL;

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
        generic (N: natural);
        port(
            X      : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Y      : in  STD_LOGIC_VECTOR(N-1 downto 0);
            ALU_IN : in  ALU_INPUT;
            R      : out STD_LOGIC_VECTOR(N-1 downto 0);
            FLAGS  : out ALU_FLAGS
        );
    end component;
    
    component adder is
        generic (N: natural);    
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
    signal if_inst : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    
    -- ID control signals
    signal idc_reg_dst    : STD_LOGIC;
    signal idc_alu_op     : ALU_OP;
    signal idc_alu_src    : STD_LOGIC;
    signal idc_branch     : STD_LOGIC;
    signal idc_mem_read   : STD_LOGIC;
    signal idc_mem_write  : STD_LOGIC;
    signal idc_reg_write  : STD_LOGIC;
    signal idc_mem_to_reg : STD_lOGIC;
    
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
    signal exc_reg_dst    : STD_LOGIC;
    signal exc_alu_op     : ALU_OP;
    signal exc_alu_src    : STD_LOGIC;
    signal exc_branch     : STD_LOGIC;
    signal exc_mem_read   : STD_LOGIC;
    signal exc_mem_write  : STD_LOGIC;
    signal exc_reg_write  : STD_LOGIC;
    signal exc_mem_to_reg : STD_lOGIC;
    
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
    signal ex_flags  : ALU_FLAGS;
    signal ex_zero   : STD_LOGIC;
    
    -- MEM control signals
    signal memc_branch     : STD_LOGIC;
    signal memc_mem_read   : STD_LOGIC;
    signal memc_mem_write  : STD_LOGIC;
    signal memc_reg_write  : STD_LOGIC;
    signal memc_mem_to_reg : STD_lOGIC;
    
    -- MEM signals
    signal mem_target : STD_LOGIC_VECTOR(PC_SIZE-1 downto 0);
    signal mem_mem    : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_rt     : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_wba    : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal mem_res    : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal mem_zero   : STD_LOGIC;
    
    -- WB control signals
    signal wbc_reg_write  : STD_LOGIC;
    signal wbc_mem_to_reg : STD_lOGIC;
    
    -- WB signals
    signal wb_mem : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal wb_res : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    signal wb_wba : STD_LOGIC_VECTOR(REG_ADDR_SIZE-1 downto 0);
    signal wb_wb  : STD_LOGIC_VECTOR(REG_SIZE-1 downto 0);
    
    -- Other signals
    signal pipeline_enable : STD_LOGIC;
    
begin
    
    REG_IF_ID : if_id
    generic map(
        PC_SIZE   => PC_SIZE,
        INST_SIZE => INST_SIZE
    )
    port map(
        -- Signals
        pc_in    => if_pc_1,
        pc_out   => id_pc,
        inst_in  => if_inst,
        inst_out => id_inst,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    REG_ID_EX : id_ex
    generic map(
        PC_SIZE       => PC_SIZE,
        REG_SIZE      => REG_SIZE,
        REG_ADDR_SIZE => REG_ADDR_SIZE
    )
    port map(
        -- EX control signals
        reg_dst_in  => idc_reg_dst,
        reg_dst_out => exc_reg_dst,
        alu_op_in   => idc_alu_op,
        alu_op_out  => exc_alu_op,
        alu_src_in  => idc_alu_src,
        alu_src_out => exc_alu_src,
        
        -- MEM control signals
        branch_in     => idc_branch,
        branch_out    => exc_branch,
        mem_read_in   => idc_mem_read,
        mem_read_out  => exc_mem_read,
        mem_write_in  => idc_mem_write,
        mem_write_out => exc_mem_write,
        
        -- WB Control signals
        reg_write_in   => idc_reg_write,
        reg_write_out  => exc_reg_write,
        mem_to_reg_in  => idc_mem_to_reg,
        mem_to_reg_out => exc_mem_to_reg,
        
        -- Signals
        pc_in   => id_pc,
        pc_out  => ex_pc,
        rs_in   => id_rs,
        rs_out  => ex_rs,
        rt_in   => id_rt,
        rt_out  => ex_rt,
        imm_in  => id_imm_x,
        imm_out => ex_imm_x,
        rta_in  => id_rta,
        rta_out => ex_rta,
        rda_in  => id_rda,
        rda_out => ex_rda,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    REG_EX_MEM : ex_mem
    generic map(
        PC_SIZE       => PC_SIZE,
        REG_SIZE      => REG_SIZE,
        REG_ADDR_SIZE => REG_ADDR_SIZE
    )
    port map(
        -- MEM control signals
        branch_in     => exc_branch,
        branch_out    => memc_branch,
        mem_read_in   => exc_mem_read,
        mem_read_out  => memc_mem_read,
        mem_write_in  => exc_mem_write,
        mem_write_out => memc_mem_write,
        
        -- WB Control signals
        reg_write_in   => exc_reg_write,
        reg_write_out  => memc_reg_write,
        mem_to_reg_in  => exc_mem_to_reg,
        mem_to_reg_out => memc_mem_to_reg,
        
        -- Signals
        zero_in  => ex_zero,
        zero_out => mem_zero,
        pc_in    => ex_target,
        pc_out   => mem_target,
        res_in   => ex_res,
        res_out  => mem_res,
        rt_in    => ex_rt,
        rt_out   => mem_rt,
        wba_in   => ex_wba,
        wba_out  => mem_wba,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    REG_MEM_WB : mem_wb
    generic map(
        PC_SIZE       => PC_SIZE,
        REG_SIZE      => REG_SIZE,
        REG_ADDR_SIZE => REG_ADDR_SIZE
    )
    port map(
        -- WB Control signals
        reg_write_in   => memc_reg_write,
        reg_write_out  => wbc_reg_write,
        mem_to_reg_in  => memc_mem_to_reg,
        mem_to_reg_out => wbc_mem_to_reg,
        
        -- Signals
        mem_in  => mem_mem,
        mem_out => wb_mem,
        res_in  => mem_res,
        res_out => wb_res,
        wba_in  => mem_wba,
        wba_out => wb_wba,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    ID_REGS : register_file
    port map(
        CLK        => clk,
        RESET      => reset,
        RW         => wbc_reg_write,
        RS_ADDR    => id_rsa,
        RT_ADDR    => id_rta,
        RD_ADDR    => wb_wba,
        WRITE_DATA => wb_wb,
        RS         => id_rs,
        RT         => id_rt
    );
    
    EX_ALU : alu
    generic map(
        N => REG_SIZE
    )
    port map(
        X      => ex_rs,
        Y      => ex_rt, -- TODO
        -- TODO : ALU_IN => exc_alu_op(1 downto 0),
        R      => ex_res,
        FLAGS  => ex_flags
    );
    
    
    
end Behavioral;
