LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Accumulator_tb IS
END Accumulator_tb;
 
ARCHITECTURE behavior OF Accumulator_tb IS 
 
    COMPONENT Accumulator
    PORT(
			Reset : IN  std_logic;
         WE : IN  std_logic;
         DataIn : IN  std_logic_vector(7 downto 0);
         DataOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	
	signal Reset : std_logic := '0';
   signal WE : std_logic := '0';
   signal DataIn : std_logic_vector(7 downto 0) := (others => '0');

   signal DataOut : std_logic_vector(7 downto 0);
 
BEGIN
 
   uut: Accumulator PORT MAP (
			 Reset => Reset,
          WE => WE,
          DataIn => DataIn,
          DataOut => DataOut
        ); 
	
	stim_proc: process
   begin		
		Reset <= '1';
		wait for 10 ns;
		Reset <= '0';
		wait;
   end process;
	
   stim_proc_1: process
   begin		
		wait for 20 ns;
		WE <= not WE;
   end process;
	
	stim_proc_2: process
   begin		
		wait for 15 ns;
		DataIn <= not DataIn;
   end process;

END;