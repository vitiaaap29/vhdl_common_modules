LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
    COMPONENT ALU
    PORT(
         Selector : IN  std_logic_vector(2 downto 0);
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   signal Selector : std_logic_vector(2 downto 0) := (others => '0');
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');

   signal Output : std_logic_vector(7 downto 0);
 
BEGIN
 
   uut: ALU PORT MAP (
          Selector => Selector,
          A => A,
          B => B,
          Output => Output
        );

   stim_proc: process
   begin		
      wait for 20 ns;
		Selector <= "111";
   end process;
	
	stim_proc_1: process
   begin		
      wait for 15 ns;
		A <= "00000111"; -- 7
		B <= "00000101"; -- 5
   end process;

END;