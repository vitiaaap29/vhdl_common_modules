LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RAM_tb IS
END RAM_tb;
 
ARCHITECTURE behavior OF RAM_tb IS 
 
    COMPONENT RAM
    PORT(
		   RW : in STD_LOGIC;
		   Address : in STD_LOGIC_VECTOR(4 downto 0);
		   DataIn : in STD_LOGIC_VECTOR(7 downto 0);
		   DataOut : out STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

	signal RW : std_logic := '0';
	signal Address : std_logic_vector(4 downto 0) := (others => '0');
   signal DataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal DataOut : std_logic_vector(7 downto 0);
 
BEGIN

   uut: RAM PORT MAP (
			 RW => RW,
			 Address => Address,
          DataIn => DataIn,
          DataOut => DataOut
        );
	
	stim_proc: process
   begin		
      wait for 25 ns;
		RW <= not RW;
   end process;
	
	stim_proc_1: process
   begin		
      wait for 15 ns;
		Address <= not Address;
   end process;
	
	stim_proc_2: process
   begin		
      wait for 10 ns;
		DataIn <= not DataIn;
   end process;

END;