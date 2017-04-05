----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:52:10 03/26/2017 
-- Design Name: 
-- Module Name:    Accumulator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Accumulator is
    Port ( Clock : in STD_LOGIC;
           InPort : in STD_LOGIC_VECTOR(7 downto 0);
           OutPort : out STD_LOGIC_VECTOR(7 downto 0);
			  RamOutPort : out STD_LOGIC_VECTOR(7 downto 0); --port for writing data to RAM
			  RamOutAddressPort : out STD_LOGIC_VECTOR(7 downto 0) ); -- RAM address for writing that data
end Accumulator;

architecture Behavioral of Accumulator is
signal Value : STD_LOGIC_VECTOR(7 downto 0);
begin
	process (Clock)
	begin
		if rising_edge(Clock) then
			Value <= InPort;
		end if;
	end process;
	OutPort <= Value;
end Behavioral;