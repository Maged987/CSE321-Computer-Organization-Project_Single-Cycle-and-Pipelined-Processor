library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.segm_mips_const_pkg.all;

entity REGISTERS is
    port(
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        RW : in STD_LOGIC;
        RS_ADDR : in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
        RT_ADDR : in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
        RD_ADDR : in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
        WRITE_DATA : in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
        RS : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
        RT : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0)
    );
end REGISTERS;

architecture REGISTERS_ARC of REGISTERS is
    type REGS_T is array (NUM_REG-1 downto 0) of STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    signal REGISTROS : REGS_T;

    -- DEBUG SIGNALS: These create explicit names for the Waveform
    signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    signal reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15 : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    signal reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23 : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
    signal reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31 : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);

begin

    -- DEBUG ASSIGNMENTS: Connecting the array to the named signals
    reg0 <= REGISTROS(0);   reg1 <= REGISTROS(1);   reg2 <= REGISTROS(2);   reg3 <= REGISTROS(3);
    reg4 <= REGISTROS(4);   reg5 <= REGISTROS(5);   reg6 <= REGISTROS(6);   reg7 <= REGISTROS(7);
    reg8 <= REGISTROS(8);   reg9 <= REGISTROS(9);   reg10 <= REGISTROS(10); reg11 <= REGISTROS(11);
    reg12 <= REGISTROS(12); reg13 <= REGISTROS(13); reg14 <= REGISTROS(14); reg15 <= REGISTROS(15);
    reg16 <= REGISTROS(16); reg17 <= REGISTROS(17); reg18 <= REGISTROS(18); reg19 <= REGISTROS(19);
    reg20 <= REGISTROS(20); reg21 <= REGISTROS(21); reg22 <= REGISTROS(22); reg23 <= REGISTROS(23);
    reg24 <= REGISTROS(24); reg25 <= REGISTROS(25); reg26 <= REGISTROS(26); reg27 <= REGISTROS(27);
    reg28 <= REGISTROS(28); reg29 <= REGISTROS(29); reg30 <= REGISTROS(30); reg31 <= REGISTROS(31);

    REG_ASIG:
    process(CLK, RESET, RW, WRITE_DATA, RD_ADDR)
    begin
        if RESET='1' then
            for i in 0 to NUM_REG-1 loop
                REGISTROS(i) <= (others => '0');
            end loop;

            -- Initialize specific registers for Restoring algorithm test
            REGISTROS(0) <= (others => '0');
            REGISTROS(1) <= std_logic_vector(to_unsigned(1, INST_SIZE));
            REGISTROS(2) <= std_logic_vector(to_unsigned(2, INST_SIZE));
            REGISTROS(3) <= std_logic_vector(to_unsigned(3, INST_SIZE));
            REGISTROS(4) <= std_logic_vector(to_unsigned(4, INST_SIZE));
            REGISTROS(5) <= std_logic_vector(to_unsigned(1, INST_SIZE));
            REGISTROS(6) <= (others => '0');
            REGISTROS(7) <= x"00000020"; -- 32
            REGISTROS(8) <= (others => '0');
            REGISTROS(9) <= std_logic_vector(to_unsigned(9, INST_SIZE));
            REGISTROS(10) <= std_logic_vector(to_unsigned(19, INST_SIZE));
            REGISTROS(11) <= std_logic_vector(to_unsigned(26, INST_SIZE));
            -- Keep the rest of your initializations here as needed...
            
        elsif rising_edge(CLK) then
            if RW='1' then
                REGISTROS(to_integer(unsigned(RD_ADDR))) <= WRITE_DATA;
            end if;
        end if;
    end process REG_ASIG;

    RS <= (others=>'0') when RS_ADDR="00000"
          else REGISTROS(to_integer(unsigned(RS_ADDR)));
          
    RT <= (others=>'0') when RT_ADDR="00000"
          else REGISTROS(to_integer(unsigned(RT_ADDR)));

end REGISTERS_ARC;