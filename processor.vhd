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

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
    port( 
        clk               : in  STD_LOGIC;
        reset             : in  STD_LOGIC;
        processor_enable  : in  STD_LOGIC;
        imem_address      : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
        imem_data_in      : in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        dmem_data_in      : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        dmem_address      : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0); --TODO
        dmem_address_wr   : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0); --TODO
        dmem_data_out     : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
        dmem_write_enable : out STD_LOGIC
    );
end processor;

architecture Behavioral of processor is
    
    component if_id is
        port( 
            -- Signals
            pc_in    : in  STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
            pc_out   : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
            inst_in  : in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
            inst_out : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
            
            -- Pipeline signals
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            enable   : in  STD_LOGIC
        );
    end component;

    component id_ex is
        port( 
            -- EX control signals
            alu_func_in   : in  ALU_FUNC;
            alu_func_out  : out ALU_FUNC;
            alu_src_in    : in  STD_LOGIC;
            alu_src_out   : out STD_LOGIC;
            shift_src_in  : in  STD_LOGIC;
            shift_src_out : out STD_LOGIC;
            
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
            rsa_in  : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            rsa_out : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            rta_in  : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            rta_out : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            rda_in  : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            rda_out : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
            shift_in  : in  STD_LOGIC_VECTOR(SHIFT_WIDTH-1 downto 0);
            shift_out : out STD_LOGIC_VECTOR(SHIFT_WIDTH-1 downto 0);
            target_in  : in  STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
            target_out : out STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
            
            -- Pipeline signals
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            enable : in  STD_LOGIC
        );
    end component;
    
    component ex_mem is
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
    end component;
    
    component mem_wb is
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
    end component;
    
    component register_file is
        port(
            CLK        : in  STD_LOGIC;
            RW         : in  STD_LOGIC;
            RS_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            RT_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            RD_ADDR    : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
            WRITE_DATA : in  STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
            RS         : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
            RT         : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0)
        );
    end component;
    
    component ALU is
        generic(
            N : integer := 64;
            M : integer := 6
        );
        port(
            X     : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Y     : in  STD_LOGIC_VECTOR(N-1 downto 0);
            R     : out STD_LOGIC_VECTOR(N-1 downto 0);
            SHIFT : in  STD_LOGIC_VECTOR(M-1 downto 0);
            FUNC  : in  ALU_FUNC
        );
    end component;
    
    component Adder is
        generic (
            N : integer := 64
        );
        port (
            A		 : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B		 : in  STD_LOGIC_VECTOR(N-1 downto 0);
            R		 : out STD_LOGIC_VECTOR(N-1 downto 0);
            CARRY_IN : in  STD_LOGIC
        );
    end component;
    
    component ZeroTester is
        generic (N : integer := 64);
        port (
            I    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Pos  : out STD_LOGIC;
            Zero : out STD_LOGIC;
            Neg  : out STD_LOGIC
        );
    end component;
    
    component control_unit is
        port(
            -- Input
            opcode : in STD_LOGIC_VECTOR(6-1 downto 0);
            func   : in STD_LOGIC_VECTOR(6-1 downto 0);
            
            -- ID control signals
            reg_dst : out STD_LOGIC;
            
            -- EX control signals
            alu_func  : out ALU_FUNC;
            alu_src   : out STD_LOGIC;
            shift_src : out STD_LOGIC;
            
            -- MEM control signals
            eq        : out STD_LOGIC;
            slt       : out STD_LOGIC;
            link      : out STD_LOGIC;
            jump      : out JUMP_TYPE;
            branch    : out STD_LOGIC;
            mem_write : out STD_LOGIC;
            
            -- WB Control signals
            reg_write  : out STD_LOGIC;
            mem_to_reg : out STD_lOGIC
        );
    end component;
    
    component forwarding_unit is
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
    end component;
    
    component pc is
        port( 
            -- Signals
            pc_in    : in  STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
            pc_out   : out STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
            
            -- Pipeline signals
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            enable   : in  STD_LOGIC
        );
    end component;
    
    -- IF signals
    signal if_eq        : STD_LOGIC;
    signal if_pc        : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal if_pc_1      : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal if_pc_next   : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal if_pc_next_1 : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal if_inst      : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
    
    -- ID control signals
    signal id_reg_dst    : STD_LOGIC;
    signal id_alu_func   : ALU_FUNC;
    signal id_alu_src    : STD_LOGIC;
    signal id_shift_src  : STD_LOGIC;
    signal id_eq         : STD_LOGIC;
    signal id_slt        : STD_LOGIC;
    signal id_link       : STD_LOGIC;
    signal id_jump       : JUMP_TYPE;
    signal id_branch     : STD_LOGIC;
    signal id_mem_write  : STD_LOGIC;
    signal id_reg_write  : STD_LOGIC;
    signal id_mem_to_reg : STD_lOGIC;
    
    -- ID signals
    signal id_pc     : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal id_inst   : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
    signal id_opcode : STD_LOGIC_VECTOR(OPCODE_WIDTH-1 downto 0);
    signal id_func   : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0);
    signal id_rs     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal id_rt     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal id_rsa    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal id_rta    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal id_rda    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal id_wba    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal id_imm    : STD_LOGIC_VECTOR(16-1 downto 0);
    signal id_imm_x  : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal id_shift  : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal id_target : STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
    
    -- EX control signals
    signal ex_alu_func   : ALU_FUNC;
    signal ex_alu_src    : STD_LOGIC;
    signal ex_shift_src  : STD_LOGIC;
    signal ex_eq         : STD_LOGIC;
    signal ex_slt        : STD_LOGIC;
    signal ex_link       : STD_LOGIC;
    signal ex_jump       : JUMP_TYPE;
    signal ex_branch     : STD_LOGIC;
    signal ex_mem_write  : STD_LOGIC;
    signal ex_reg_write  : STD_LOGIC;
    signal ex_mem_to_reg : STD_lOGIC;
    
    -- EX signals
    signal ex_pc     : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal ex_rs     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_rt     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_rs_fwd : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_rt_fwd : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_imm    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_alu_x  : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_alu_y  : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_alu_s  : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal ex_rsa    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal ex_rta    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal ex_rda    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal ex_res    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal ex_shift  : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal ex_target : STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
    
    -- EX forward signals
    signal ex_fwd_rs : FORWARD_TYPE;
    signal ex_fwd_rt : FORWARD_TYPE;
    
    -- MEM control signals
    signal mem_eq         : STD_LOGIC;
    signal mem_slt        : STD_LOGIC;
    signal mem_link       : STD_LOGIC;
    signal mem_jump       : JUMP_TYPE;
    signal mem_branch     : STD_LOGIC;
    signal mem_mem_write  : STD_LOGIC;
    signal mem_reg_write  : STD_LOGIC;
    signal mem_mem_to_reg : STD_lOGIC;
    
    -- MEM signals
    signal mem_pc     : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal mem_mem    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_rs     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_rt     : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_rda    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal mem_wba    : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal mem_res    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_res_1  : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_res_2    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_imm    : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal mem_target : STD_LOGIC_VECTOR(TARGET_WIDTH-1 downto 0);
    
    -- MEM Jump/Branch signals
    signal mem_jump_reg_addr : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal mem_jump_addr     : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    signal mem_branch_addr   : STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    
    -- MEM Sign signals
    signal mem_pos  : STD_lOGIC;
    signal mem_zero : STD_lOGIC;
    signal mem_neg  : STD_lOGIC;
    
    -- WB control signals
    signal wb_reg_write  : STD_LOGIC;
    signal wb_mem_to_reg : STD_lOGIC;
    
    -- WB signals
    signal wb_mem : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal wb_res : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    signal wb_rda : STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
    signal wb_wb  : STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
    
    -- Other signals
    signal pipeline_enable : STD_LOGIC;
    
begin
    
    REG_IF_ID : if_id
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
    port map(
        -- EX control signals
        alu_func_in   => id_alu_func,
        alu_func_out  => ex_alu_func,
        alu_src_in    => id_alu_src,
        alu_src_out   => ex_alu_src,
        shift_src_in  => id_shift_src,
        shift_src_out => ex_shift_src,
        
        -- MEM control signals
        eq_in         => id_eq,
        eq_out        => ex_eq,
        slt_in        => id_slt,
        slt_out       => ex_slt,
        link_in       => id_link,
        link_out      => ex_link,
        jump_in       => id_jump,
        jump_out      => ex_jump,
        branch_in     => id_branch,
        branch_out    => ex_branch,
        mem_write_in  => id_mem_write,
        mem_write_out => ex_mem_write,
        
        -- WB Control signals
        reg_write_in   => id_reg_write,
        reg_write_out  => ex_reg_write,
        mem_to_reg_in  => id_mem_to_reg,
        mem_to_reg_out => ex_mem_to_reg,
        
        -- Signals
        pc_in   => id_pc,
        pc_out  => ex_pc,
        rs_in   => id_rs,
        rs_out  => ex_rs,
        rt_in   => id_rt,
        rt_out  => ex_rt,
        imm_in  => id_imm_x,
        imm_out => ex_imm,
        rsa_in  => id_rsa,
        rsa_out => ex_rsa,
        rta_in  => id_rta,
        rta_out => ex_rta,
        rda_in  => id_wba,
        rda_out => ex_rda,
        shift_in  => id_shift,
        shift_out => ex_shift,
        target_in  => id_target,
        target_out => ex_target,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    REG_EX_MEM : ex_mem
    port map(
        -- MEM control signals
        eq_in         => ex_eq,
        eq_out        => mem_eq,
        slt_in        => ex_slt,
        slt_out       => mem_slt,
        link_in       => ex_link,
        link_out      => mem_link,
        jump_in       => ex_jump,
        jump_out      => mem_jump,
        branch_in     => ex_branch,
        branch_out    => mem_branch,
        mem_write_in  => ex_mem_write,
        mem_write_out => mem_mem_write,
        
        -- WB Control signals
        reg_write_in   => ex_reg_write,
        reg_write_out  => mem_reg_write,
        mem_to_reg_in  => ex_mem_to_reg,
        mem_to_reg_out => mem_mem_to_reg,
        
        -- Signals
        pc_in    => ex_pc,
        pc_out   => mem_pc,
        rs_in    => ex_rs,
        rs_out   => mem_rs,
        rt_in    => ex_rt,
        rt_out   => mem_rt,
        imm_in   => ex_imm,
        imm_out  => mem_imm,
        res_in   => ex_res,
        res_out  => mem_res,
        rda_in   => ex_rda,
        rda_out  => mem_rda,
        target_in  => ex_target,
        target_out => mem_target,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    REG_MEM_WB : mem_wb
    port map(
        -- WB Control signals
        reg_write_in   => mem_reg_write,
        reg_write_out  => wb_reg_write,
        mem_to_reg_in  => mem_mem_to_reg,
        mem_to_reg_out => wb_mem_to_reg,
        
        -- Signals
        mem_in  => mem_mem,
        mem_out => wb_mem,
        res_in  => mem_res_2,
        res_out => wb_res,
        rda_in  => mem_wba,
        rda_out => wb_rda,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
    
    -----------------------
    -- INSTRUCTION FETCH --
    -----------------------
    
    REG_PC : pc
    port map(
        -- Signals
        pc_in  => if_pc_next_1,
        pc_out => if_pc,
        
        -- Pipeline signals
        clk    => clk,
        reset  => reset,
        enable => pipeline_enable
    );
	
    IF_PC_INC : Adder
    generic map(
        N => PC_WIDTH
    )
    port map(
        A        => if_pc,
        B        => (others => '0'),
        R        => if_pc_1,
        CARRY_IN => '1'
    );
    
    -- Instruction Memory
    imem_address <= if_pc;
    if_inst <= imem_data_in;
    
    -- MUX : EQ
    if_eq <= mem_zero when mem_eq = '1' else not mem_zero;
    
    -- MUX : Branch
    if_pc_next <= mem_branch_addr when (mem_branch and if_eq) = '1' else if_pc_1;
    
    -- MUX : Jump
    if_pc_next_1 <= if_pc_next when mem_jump = NO_JUMP else mem_jump_addr when mem_jump = JUMP else mem_jump_reg_addr;
    
    ------------------------
    -- INSTRUCTION DECODE --
    ------------------------
    
    ID_DECODER : process(id_inst)
    begin
        id_opcode <= id_inst(32-1 downto 26);
        id_func   <= id_inst(6-1 downto 0);
        id_rsa    <= id_inst(26-1 downto 21);
        id_rta    <= id_inst(21-1 downto 16);
        id_rda    <= id_inst(16-1 downto 11);
        id_shift  <= id_inst(11-1 downto 6);
        id_imm    <= id_inst(16-1 downto 0);
        id_target <= id_inst(26-1 downto 0);
    end process;
    
    ID_CTRL_UNIT : control_unit
    port map(
        -- Input
        opcode => id_opcode,
        func   => id_func,
        
        -- ID Control signals
        reg_dst => id_reg_dst,
        
        -- EX control signals
        alu_func  => id_alu_func,
        alu_src   => id_alu_src,
        shift_src => id_shift_src,
        
        -- MEM control signals
        eq        => id_eq,
        slt       => id_slt,
        link      => id_link,
        jump      => id_jump,
        branch    => id_branch,
        mem_write => id_mem_write,
        
        -- WB Control signals
        reg_write  => id_reg_write,
        mem_to_reg => id_mem_to_reg
    );

    ID_REGS : register_file
    port map(
        CLK        => clk,
        RW         => wb_reg_write,
        RS_ADDR    => id_rsa,
        RT_ADDR    => id_rta,
        RD_ADDR    => wb_rda,
        WRITE_DATA => wb_wb,
        RS         => id_rs,
        RT         => id_rt
    );
    
    -- Sign Extender
    id_imm_x <= ZERO16 & id_imm when id_imm(16-1) = '0' else ONE16 & id_imm;
    
    -- MUX: Destination Register
    id_wba <= id_rda when id_reg_dst = '0' else id_rta;
    
    -------------
    -- EXECUTE --
    -------------
    
    EX_ALU : ALU
    generic map(
        N => REG_WIDTH,
        M => REG_ADDR_WIDTH
    )
    port map(
        X     => ex_alu_x,
        Y     => ex_alu_y,
        R     => ex_res,
        SHIFT => ex_alu_s,
        FUNC  => ex_alu_func
    );
    
    FORWARD : forwarding_unit
    port map(
        -- Requested
        rs_addr => ex_rsa,
        rt_addr => ex_rta,
        
        -- From mem
        mem_addr  => mem_wba,
        mem_write => mem_reg_write,
        
        -- From wb
        wb_addr  => wb_rda,
        wb_write => wb_reg_write,
        
        -- Forwarding
        forward_rs => ex_fwd_rs,
        forward_rt => ex_fwd_rt
    );
    
    -- TODO : Forwarding
    ex_rs_fwd <= ex_rs;
    ex_rt_fwd <= ex_rt;
    
    -- MUX: Shift Source
    ex_alu_s <= ex_shift when ex_shift_src = '0' else ex_rs_fwd(SHIFT_WIDTH+FUNC_WIDTH-1 downto FUNC_WIDTH);
    
    -- MUX: ALU Source
    ex_alu_y <= ex_rt_fwd when ex_alu_src = '0' else ex_imm;
    
    -- Other mapping
    ex_alu_x <= ex_rs_fwd;
    
    ------------
    -- MEMORY --
    ------------
    
    -- Data Memory
    dmem_address <= mem_res;
    dmem_address_wr <= mem_res;
    dmem_data_out <= mem_rt;
    dmem_write_enable <= mem_mem_write;
    mem_mem <= dmem_data_in;
    
    ZERO_TESTER : ZeroTester
    generic map (
        N => 32
    )
    port map (
        I    => mem_res,
        Pos  => mem_pos,
        Zero => mem_zero,
        Neg  => mem_neg
    );
    
    MEM_BRANCH_ADDER : Adder
    generic map(
        N => PC_WIDTH
    )
    port map(
        A        => mem_pc,
        B        => mem_imm,
        R        => mem_branch_addr,
        CARRY_IN => '0'
    );
    
    -- MUX : SLT
    mem_res_1 <= (REG_WIDTH-1 downto 1 => '0') & mem_neg when mem_slt = '1' else mem_res;
    
    -- MUX : Link Result
    mem_res_2 <= mem_pc when mem_link = '1' else mem_res_1;
    
    -- MUX : Link Address
    mem_wba <= (others => '1') when mem_link = '1' else mem_rda;
    
    -- Jump addresses
    mem_jump_reg_addr <= mem_rs;
    mem_jump_addr <= mem_pc(INST_WIDTH-1 downto TARGET_WIDTH) & mem_target;
    
    ----------------
    -- WRITE BACK --
    ----------------
    
    -- MUX: Memory To Registry
    wb_wb <= wb_res when wb_mem_to_reg = '0' else wb_mem;
    
    -----------
    -- OTHER --
    -----------
    
	-- Enable pipeline (TODO : Only for stalling)
	pipeline_enable <= processor_enable;
	
end Behavioral;
