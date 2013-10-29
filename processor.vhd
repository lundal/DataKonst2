----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:23 09/20/2013 
-- Design Name: 
-- Module Name:    processor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
    generic(
        MEM_ADDR_BUS : integer := 32;
        MEM_DATA_BUS : integer := 32
    );
    port( 
        clk               : in  STD_LOGIC;
        reset             : in  STD_LOGIC;
        processor_enable  : in  STD_LOGIC;
        imem_address      : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
        imem_data_in      : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
        dmem_data_in      : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
        dmem_address      : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
        dmem_address_wr   : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
        dmem_data_out     : out STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
        dmem_write_enable : out STD_LOGIC
    );
end processor;

architecture Behavioral of processor is
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
begin

end Behavioral;
