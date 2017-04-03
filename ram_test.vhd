--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:38:12 03/25/2017
-- Design Name:   
-- Module Name:   D:/Maga/vhdl1/ram_test.vhd
-- Project Name:  vhdl1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RAM
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ram_test IS
END ram_test;
 
ARCHITECTURE behavior OF ram_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAM
    PORT(
         DataIn : IN  std_logic_vector(7 downto 0);
         Address : IN  std_logic_vector(7 downto 0);
         Mode : IN  std_logic;
         Enable : IN  std_logic;
         DataOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal Address : std_logic_vector(7 downto 0) := (others => '0');
   signal Mode : std_logic := '0';
   signal Enable : std_logic := '0';

 	--Outputs
   signal DataOut : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  -- constant test_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          DataIn => DataIn,
          Address => Address,
          Mode => Mode,
          Enable => Enable,
          DataOut => DataOut
        );

   -- Clock process definitions
--   test_process :process
--   begin
--		<clock> <= '0';
--		wait for test_period/2;
--		<clock> <= '1';
--		wait for test_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
--      wait for 100 ns;	

      wait for 20ns;
		Enable <= not Enable;
   end process;

END;
