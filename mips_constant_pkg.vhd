library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MIPS_CONSTANT_PKG is
    
    constant MEM_ADDR_COUNT : integer := 8;
    
    -- Bus sizes
    constant IADDR_BUS : integer := 32;
    constant IDATA_BUS : integer := 32;
    constant DADDR_BUS : integer := 32;
    constant DDATA_BUS : integer := 32;
    constant RADDR_BUS : integer := 5;
    
    -- Signal widths
    constant PC_WIDTH       : integer := IADDR_BUS;
    constant INST_WIDTH     : integer := IDATA_BUS;
    constant REG_WIDTH      : integer := DDATA_BUS;
    constant REG_ADDR_WIDTH : integer := RADDR_BUS;
    constant SHIFT_WIDTH    : integer := RADDR_BUS;
    constant TARGET_WIDTH   : integer := 26;
    constant OPCODE_WIDTH   : integer := 6;
    constant FUNC_WIDTH     : integer := 6;
    
    -- Functions
    constant FUNC_SLL : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "000000";
    constant FUNC_SRL : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "000010";
    constant FUNC_SRA : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "000011";
    constant FUNC_ADD : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100000";
    constant FUNC_SUB : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100010";
    constant FUNC_AND : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100100";
    constant FUNC_OR  : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100101";
    constant FUNC_XOR : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100110";
    constant FUNC_NOR : STD_LOGIC_VECTOR(FUNC_WIDTH-1 downto 0) := "100110";

    
    -- Handy values
    constant ZERO1  : STD_LOGIC                     := '0';
    constant ZERO16 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    constant ZERO32 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
    constant ONE1   : STD_LOGIC                     := '1';
    constant ONE16  : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
    constant ONE32  : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111111111111";
    
--    -- Control signal records (TODO if time)
--    type CTRL_ID is
--    record
--        reg_dst : STD_LOGIC;
--    end record;
--    
--    type CTRL_EX is
--    record
--        alu_func  : ALU_FUNC;
--        alu_src   : STD_LOGIC;
--        shift_src : STD_LOGIC;
--    end record;
--    
--    type CTRL_MEM is
--    record
--        eq        : STD_LOGIC;
--        slt       : STD_LOGIC;
--        link      : STD_LOGIC;
--        jump      : JUMP_TYPE;
--        branch    : STD_LOGIC;
--        mem_write : STD_LOGIC;
--    end record;
--    
--    type CTRL_WB is
--    record
--        reg_write  : iSTD_LOGIC;
--        mem_to_reg : STD_lOGIC;
--    end record;
    
    -- Custom types
    type JUMP_TYPE is (NO_JUMP, JUMP, JUMP_REG);
    type FORWARD_TYPE is (NO_FORWARD, FORWARD_MEM, FORWARD_WB);
    type ALU_FUNC is (ALU_NA, ALU_SLL, ALU_SRL, ALU_SRA, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_NOR, ALU_LUI);
    
end MIPS_CONSTANT_PKG;
