library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- =====================================================
-- 1-bit Full Adder
-- Computes X + Y + CIN
-- Used as the arithmetic core inside the ALU
-- =====================================================

 
entity FULL_ADDER is 
    port(
	        X	: in	std_logic;
	        Y	: in	std_logic;
	        CIN	: in	std_logic;
	        COUT	: out	std_logic;
	        R	: out	std_logic
        );
end FULL_ADDER;

architecture FULL_ADDER_ARC of FULL_ADDER is


signal G,P,K : std_logic;

begin
	-- Carry logic signals
	-- G: Generate, P: Propagate, K: Kill
	G <= X and Y;
	P <= X xor Y;
	K <= X nor Y;
	-- Carry-out logic: generated or propagated carry
	COUT <= G or ( P and CIN );
	-- Sum computation
	R <= P xor CIN;    
end FULL_ADDER_ARC;
