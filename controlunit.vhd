library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity control_unit is
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
            jmp       : out JUMP_TYPE;
            branch    : out STD_LOGIC;
            mem_write : out STD_LOGIC;
            
            -- WB Control signals
            reg_write  : out STD_LOGIC;
            mem_to_reg : out STD_lOGIC
        );
end control_unit;

architecture Behavioral of control_unit is

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
        jmp         <= NO_JUMP;
        branch      <= '0';
        mem_write   <= '0';
        reg_write   <= '0';
        mem_to_reg  <= '0';
        
		case (opcode) is
			when OP_RCODE => 
				case (func) is
                    -- Shifts
					when FUNC_SLL =>
                        alu_func <= ALU_SLL;
                        reg_write <= '1';
					when FUNC_SRL => 
                        alu_func <= ALU_SRL;
                        reg_write <= '1';
					when FUNC_SRA => 
                        alu_func <= ALU_SRA;
                        reg_write <= '1';
					when FUNC_SLLV => 
                        alu_func <= ALU_SLL;
                        shift_src <= '1';
                        reg_write <= '1';
					when FUNC_SRLV => 
                        alu_func <= ALU_SRL;
                        shift_src <= '1';
                        reg_write <= '1';
                    when FUNC_SRAV => 
                        alu_func <= ALU_SRA;
                        shift_src <= '1';
                        reg_write <= '1';
                    
                     -- Logical
					when FUNC_AND => 
                        alu_func <= ALU_AND;
                        reg_write <= '1';
					when FUNC_OR => 
                        alu_func <= ALU_OR;
                        reg_write <= '1';
					when FUNC_XOR => 
                        alu_func <= ALU_XOR;
                        reg_write <= '1';
					when FUNC_NOR => 
                        alu_func <= ALU_NOR;
                        reg_write <= '1';
                    
                    -- Arithmetic
					when FUNC_ADD => 
						alu_func <= ALU_ADD;
                        reg_write <= '1';
                    when FUNC_ADDU => 
						alu_func <= ALU_ADD;
                        reg_write <= '1';
					when FUNC_SUB => 
                        alu_func <= ALU_SUB;
                        reg_write <= '1';
                    
                    -- Jump
					when FUNC_JR => 
                        jmp <= JUMP_REG;
					when FUNC_JALR => 
                        jmp <= JUMP_REG;
                        link <= '1';
                    
                    -- Others
                    when FUNC_SLT =>
                        slt <= '1';
                        alu_func <= ALU_SUB;
                        reg_write <= '1';
                    when others =>
                        -- Not supported
				end case;
            
            -- Immediates
			when OP_ADDI => 
                reg_dst <= '1';
				alu_func <= ALU_ADD;
				alu_src <= '1';
                reg_write <= '1';
            when OP_ADDIU => 
                reg_dst <= '1';
				alu_func <= ALU_ADD;
				alu_src <= '1';
                reg_write <= '1';
			when OP_ANDI => 
                reg_dst <= '1';
                alu_func <= ALU_AND;
                alu_src <= '1';
                reg_write <= '1';
            when OP_ORI => 
                reg_dst <= '1';
                alu_func <= ALU_OR;
                alu_src <= '1';
                reg_write <= '1';
            when OP_XORI => 
                reg_dst <= '1';
                alu_func <= ALU_XOR;
                alu_src <= '1';
                reg_write <= '1';
            
            -- Branch
			when OP_BEQ => 
                branch <= '1';
                eq <= '1';
                alu_func <= ALU_SUB;
			when OP_BNEQ => 
                branch <= '1';
                eq <= '0';
                alu_func <= ALU_SUB;
            
            -- Jump
			when OP_JUMP => 
                jmp <= JUMP;
			when OP_JAL => 
                jmp <= JUMP;
                link <= '1';
            
            -- Memory
			when OP_LW => 
                reg_dst <= '1';
                alu_src <= '1';
                alu_func <= ALU_ADD;
                mem_to_reg <= '1';
                reg_write <= '1';
			when OP_SW => 
                alu_src <= '1';
                alu_func <= ALU_ADD;
                mem_write <= '1';
            
            -- Others
            when OP_SLTI =>
                slt <= '1';
                alu_func <= ALU_SUB;
                alu_src <= '1';
                reg_write <= '1';
                reg_dst <= '1';
			when OP_LUI => 
                alu_func <= ALU_LUI;
                reg_write <= '1';
            when others =>
                -- Not supported
		end case;
	end process;

end Behavioral;

