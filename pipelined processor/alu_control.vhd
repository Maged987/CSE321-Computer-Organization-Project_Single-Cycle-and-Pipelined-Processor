library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.records_pkg.all;

-- =====================================================
-- ALU Control Unit
-- Decodes Main Control ALUOp signals and FUNCT field
-- Generates control signals for the ALU
-- =====================================================

entity ALU_CONTROL is
	port(
		-- FUNCT field from R-type MIPS instructions
		-- Used to select the exact ALU operation
			CLK		:	in STD_LOGIC;			
			FUNCT		:	in STD_LOGIC_VECTOR(5 downto 0);	
			-- ALU operation class from Main Control Unit
			-- Determines instruction type (R-type, branch, load/store, etc.)
			ALU_OP_IN	:	in ALU_OP_INPUT;	

		     	ALU_IN		:	out ALU_INPUT		
	);
end ALU_CONTROL;

architecture ALU_CONTROL_ARC of ALU_CONTROL is
begin
	-- ALU control signal generation
	-- Pure combinational logic (no clocked behavior)

	-- Op0: Part of ALU operation selection (R-type decoding)
	ALU_IN.Op0 <= ALU_OP_IN.Op1 and ( FUNCT(0) or FUNCT(3) );
	-- Op1: Selects ALU function based on instruction type and FUNCT
	ALU_IN.Op1 <= (not ALU_OP_IN.Op1) or (not FUNCT(2));
	-- Op2: Enables subtraction (Y inversion + carry-in)
	ALU_IN.Op2 <= ALU_OP_IN.Op0 or ( ALU_OP_IN.Op1 and FUNCT(1) );
	-- Op3: Enables special ALU operation (LUI)
	ALU_IN.Op3 <= ALU_OP_IN.Op2;

end ALU_CONTROL_ARC;
