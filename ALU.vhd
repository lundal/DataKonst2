library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity ALU is
    generic(
        N : integer := 64;
        M : natural := 6
    );
    port(
        X     : in  STD_LOGIC_VECTOR(N-1 downto 0);
        Y     : in  STD_LOGIC_VECTOR(N-1 downto 0);
        R     : out STD_LOGIC_VECTOR(N-1 downto 0);
        SHIFT : in  STD_LOGIC_VECTOR(M-1 downto 0);
        FUNC  : in  ALU_FUNC
    );
end ALU;

architecture Behavioral of ALU is
    component Adder is
        generic (N : integer := 64);
        port (
            A        : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B        : in  STD_LOGIC_VECTOR(N-1 downto 0);
            R        : out STD_LOGIC_VECTOR(N-1 downto 0);
            CARRY_IN : in  STD_LOGIC
        );
    end component;
    
	component ShifterVariable is
		generic (
			N : natural := 64;
			M : natural := 6
		);
		port (
			I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
			Left	:	in	STD_LOGIC;
			Arith	:	in	STD_LOGIC;
			Count	:	in	STD_LOGIC_VECTOR(M-1 downto 0)
		);
	end component;
	
    -- Adder signals
    signal add_a        : STD_LOGIC_VECTOR(N-1 downto 0);
    signal add_b        : STD_LOGIC_VECTOR(N-1 downto 0);
    signal add_carry_in : STD_LOGIC;
    
    -- Shifter signals
    signal shift_left  : STD_LOGIC;
    signal shift_arith : STD_LOGIC;
    
    -- Result signals
    signal r_shift  : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_addsub : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_and    : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_or     : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_xor    : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_nor    : STD_LOGIC_VECTOR(N-1 downto 0);
    signal r_lui    : STD_LOGIC_VECTOR(N-1 downto 0);
    
    -- Other signals
    signal y_new  : STD_LOGIC_VECTOR(N-1 downto 0);
    signal result : STD_LOGIC_VECTOR(N-1 downto 0);
    
begin
    
    ADDER_SUBTRACTOR : Adder
    generic map (N => N)
    port map(
        A => X,
        B => y_new,
        R => r_addsub,
        CARRY_IN => add_carry_in
    );
    
    SHIFTER : ShifterVariable
    generic map (
        N => N,
        M => M
    )
    port map (
        I => Y,
        O => r_shift,
        Left => shift_left,
        Arith => shift_arith,
        Count => SHIFT
    );
    
    INVERT_Y : process(Y, FUNC)
    begin
        if FUNC = ALU_SUB then
            y_new <= not Y;
            add_carry_in <= '1';
        else
            y_new <= Y;
            add_carry_in <= '0';
        end if;
    end process;
    
    SHIFTIFIER : process(FUNC)
    begin
        case FUNC is
            when ALU_SLL =>
                shift_left  <= '1';
                shift_arith <= '0';
            when ALU_SRL =>
                shift_left  <= '0';
                shift_arith <= '0';
            when ALU_SRA =>
                shift_left  <= '0';
                shift_arith <= '1';
            when others =>
                shift_left  <= '0';
                shift_arith <= '0';
        end case;
    end process;
    
    -- Logic
    r_and <= X and Y;
    r_or  <= X or Y;
    r_xor <= X xor Y;
    r_nor <= not r_or;
    
    -- LUI
    r_lui <= Y(N/2-1 downto 0) & (N/2-1 downto 0 => '0');
    
    RESULTIFIER : process(FUNC, r_shift, r_addsub, r_and, r_or, r_xor, r_nor, r_lui)
    begin
        case FUNC is
            when ALU_SLL => result <= r_shift;
            when ALU_SRL => result <= r_shift;
            when ALU_SRA => result <= r_shift;
            when ALU_ADD => result <= r_addsub;
            when ALU_SUB => result <= r_addsub;
            when ALU_AND => result <= r_and;
            when ALU_OR  => result <= r_or;
            when ALU_XOR => result <= r_xor;
            when ALU_NOR => result <= r_nor;
            when ALU_LUI => result <= r_lui;
            when others  => result <= (others => '0');
        end case;
    end process;
    
    R <= result;
    
end Behavioral;

