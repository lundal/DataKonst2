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
    constant ALU_FUNC_WIDTH : integer := 6;
    subtype SIGNAL_PC is STD_LOGIC_VECTOR(PC_WIDTH-1 downto 0);
    
    -- Handy values
    constant ZERO1b  : STD_LOGIC                     := '0';
    constant ZERO16b : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    constant ZERO32b : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";	
    constant ONE1b   : STD_LOGIC                     := '1';
    constant ONE16b  : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";	
    constant ONE32b  : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111111111111";	
    
    -- Custom types
    type JUMP_TYPE is (NO_JUMP, JUMP, JUMP_REG);
    type FORWARD_TYPE is (NO_FORWARD, FORWARD_MEM, FORWARD_WB);
    
end MIPS_CONSTANT_PKG;
