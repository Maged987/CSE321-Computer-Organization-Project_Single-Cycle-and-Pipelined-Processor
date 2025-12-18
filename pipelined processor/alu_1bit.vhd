library ieee;
use ieee.STD_LOGIC_1164.all;

-- =====================================================
-- 1-bit ALU Slice
-- Supports AND, OR, ADD, SUB, and SLT operations
-- Used to build an N-bit ALU through cascading
-- =====================================================

entity ALU_1BIT is 
	port(
			X	: in STD_LOGIC;
			Y	: in STD_LOGIC;
			LESS	: in STD_LOGIC;
			BINVERT : in STD_LOGIC;
			CIN	: in STD_LOGIC;
			OP1	: in STD_LOGIC;
			OP0	: in STD_LOGIC;
			RES	: out STD_LOGIC;
			COUT	: out STD_LOGIC;
			SET	: out STD_LOGIC
	);
end;

architecture ALU_1BIT_ARC of ALU_1BIT is


	component FULL_ADDER is   
		port(
			X	: in	STD_LOGIC;
			Y	: in	STD_LOGIC;
			CIN	: in	STD_LOGIC;
			COUT	: out	STD_LOGIC;
			R	: out	STD_LOGIC
		);
	end component FULL_ADDER;

	signal NEW_Y		: STD_LOGIC;
	signal R0,R1,R2,R3	: STD_LOGIC;
	signal RES_AUX		: STD_LOGIC;

begin
-- Y inversion logic for subtraction (two's complement)
	MUX_BINV:
	
		process(BINVERT,Y) is
		begin
			if BINVERT='0' then
				NEW_Y <= Y;
			else
				NEW_Y <= not Y;
			end if;
		end process MUX_BINV;
-- Logical operation results
	R0 <= X and NEW_Y;
	R1 <= X or NEW_Y;

-- Full adder for arithmetic operations
-- Supports addition and subtraction
	FULLADDER_ALU:
		FULL_ADDER port map(
			X	=> X,
			Y	=> NEW_Y,
			CIN	=> CIN,
			COUT	=> COUT,
			R	=> R2
		);

-- SLT path: LESS signal is used only in LSB slice
	R3 <= LESS;

-- Result selection multiplexer
-- OP1 OP0:
-- 00 -> AND
-- 01 -> OR
-- 10 -> ADD/SUB
-- 11 -> SLT
	MUX_RES_ALU:
		process(OP1,OP0,R0,R1,R2,R3) is
		begin
			if (OP1 = '0' and OP0 = '0') then
				RES_AUX <= R0;
			elsif (OP1 = '0' and OP0 = '1') then
				RES_AUX <= R1;
			elsif (OP1 = '1' and OP0 = '0') then
				RES_AUX <= R2;
			elsif (OP1 = '1' and OP0 = '1') then
				RES_AUX <= R3;
			end if;
		end process MUX_RES_ALU;

	RES <= RES_AUX;
	-- SET output used by MSB to generate SLT condition
	SET <= R2;

end ALU_1BIT_ARC;
