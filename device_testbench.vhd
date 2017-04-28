--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:35:40 04/27/2017
-- Design Name:   
-- Module Name:   C:/MyData/Stas/code/vhdl_common_modules/device_testbench.vhd
-- Project Name:  vhdl1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: device
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
 
ENTITY device_testbench IS
END device_testbench;
 
ARCHITECTURE behavior OF device_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT device
    PORT(
         Start : IN  std_logic;
         Reset : IN  std_logic;
         Clock : IN  std_logic;
         Stop : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Start : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clock : std_logic := '0';
   signal Stop : std_logic := '0';

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: device PORT MAP (
          Start => Start,
          Reset => Reset,
          Clock => Clock,
          Stop => Stop
        );

   -- Clock process definitions
--   Clock_process :process
--   begin
--		Clock <= '0';
--		wait for Clock_period/2;
--		Clock <= '1';
--		wait for Clock_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		Reset <= '1';
		wait for 10ns;
		Reset <='0';
		wait for 10ns;
		Start <='1';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
		Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
		Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
		Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
				Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
				Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
				Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
				Clock <='0';
		wait for 10ns;
		Clock <='1';
		wait for 10ns;
   end process;

END;
