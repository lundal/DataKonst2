----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:28:14 11/11/2013 
-- Design Name: 
-- Module Name:    controlunit - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlunit is
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
end controlunit;

architecture Behavioral of controlunit is

begin
	process (opcode, func)
	begin
        reg_dst     <= '0';
        alu_func    <= ALU_NA;
        alu_src     <= '0';
        shift_src   <= '0';
        eq          <= '0';
        slt         <= '0';
        link        <= '0';
        jump        <= NO_JUMP;
        branch      <= '0';
        mem_write   <= '0';
        reg_write   <= '0';
        mem_to_reg  <= '0';
        
		case (opcode) is
			when OP_RCODE => 
				case (func) is
					when FUNC_SLL =>
                        alu_func <= ALU_SLL;
					when FUNC_SRL => 
                        alu_func <= ALU_SRL;
					when FUNC_SRA => 
                        alu_func <= ALU_SRA;
					when FUNC_SLLV => 
                        alu_func <= ALU_SLL;
                        alu_src <= '1';
					when FUNC_SRLV => 
                        alu_func <= ALU_SRL;
                        alu_src <= '1';
					when (FUNC_ADD OR FUNC_ADDU)=> 
						alu_func <= ALU_ADD;
					when FUNC_SUB => 
                        alu_func <= ALU_SUB;
					when FUNC_AND => 
                        alu_func <= ALU_AND;
					when FUNC_OR => 
                        alu_func <= ALU_OR;
					when FUNC_XOR => 
                        alu_func <= ALU_XOR;
					when FUNC_NOR => 
                        alu_func <= ALU_NOR;
					when FUNC_JR => 
                        jump <= JUMP_REG;
                    when FUNC_SLT =>
                        slt <= '1';
				end case;
			when (OP_ADDI OR OP_ADDIU) => 
				alu_func <= ALU_ADD;
				alu_src <= '1';
			when OP_ANDI => 
                alu_func <= ALU_AND;
                alu_src <= '1';
			when OP_BEQ => 
                branch <= '1';
                eq <= '1';
			when OP_BNEQ => 
                branch <= '1';
                eq <= '0';
			when OP_JUMP => 
                jump <= JUMP;
			when OP_JAL => 
                jump <= JUMP;
                link <= '1';
			when OP_LUI => 
                alu_func <= ALU_SLL;
                -- TODO: shift 16 bits
                reg_write <= '1';
			when OP_LW => 
                mem_to_reg <= '1';
                reg_write <= '1';
			when OP_SW => 
                mem_write <= '1';
			when OP_XORI => 
                alu_func <= ALU_XOR;
                alu_src <= '1';
            when OP_SLTI =>
                slt <= '1';
                alu_src <= '1';
		end case;
	end process;

end Behavioral;

