library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.segm_mips_const_pkg.all;


entity DATA_MEMORY is
	generic (N :NATURAL; M :NATURAL); -- N = tam. dir. M = tamaño de la memoria
	port(
		RESET		:	in  STD_LOGIC;				--Reset asincrónico
		ADDR		:	in  STD_LOGIC_VECTOR (N-1 downto 0);	--Dirección a ser leida o escrita
		WRITE_DATA	:	in  STD_LOGIC_VECTOR (N-1 downto 0);	--Datos a ser escritos
		MemRead		:	in  STD_LOGIC;				--Señal de habilitación para lectura
		MemWrite	:	in  STD_LOGIC;				--Señal de habilitación para escritura
		READ_DATA	:	out STD_LOGIC_VECTOR (N-1 downto 0)	--Datos leidos
	);
end DATA_MEMORY;


architecture DATA_MEMORY_ARC of DATA_MEMORY is
  
	type MEM_T is array (M-1 downto 0) of STD_LOGIC_VECTOR (N-1 downto 0);
	signal MEM : MEM_T;
  
begin

	MEM_PROC:
		process(RESET,MemWrite,MemRead,WRITE_DATA,MEM,ADDR)
		begin	
			if (RESET = '1') then -- Reset Asincrónico
				for i in 0 to M-1 loop
					MEM(i) <= (others => '1');
				end loop;
			 -- Ejecuto las ordenes de la unidad de control:
			elsif MemWrite='1' then -- O bien escribo en la memoria
				MEM(to_integer(unsigned( ADDR(9 downto 0) ))) <= WRITE_DATA;
			elsif MemRead='1' then -- O bien leo de ella
			    	READ_DATA <= MEM(to_integer(unsigned( ADDR(9 downto 0) )));
			end if;
		end process MEM_PROC;

end DATA_MEMORY_ARC;
