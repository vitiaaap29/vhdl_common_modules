--------------------------------------------------------------------------------- 
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10:28:03 03/16/2017 
-- Design Name: 
-- Module Name: RAM - Behavioral 
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
--------------------------------------------------------------------------------- 
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using 
-- arithmetic functions with Signed or Unsigned values 
--use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if instantiating 
-- any Xilinx primitives in this code. 
--library UNISIM; 
--use UNISIM.VComponents.all; 

entity RAM is 
Port ( Clock : in STD_LOGIC; 
	WriteEnable : in STD_LOGIC; 
	Address : in STD_LOGIC_VECTOR(7 downto 0); 
	DataIn : in STD_LOGIC_VECTOR(7 downto 0); 
	DataOut : out STD_LOGIC_VECTOR(7 downto 0)); 
end RAM; 

architecture Behavioral of RAM is 
type Table is array (0 to 31) of STD_LOGIC_VECTOR(7 downto 0); 
signal Memory : Table := ( 
	0 => "10101010", 
	1 => "00001010", 
	2 => "00010100", 
	others => "00000000"); 
signal ReadAddress : STD_LOGIC_VECTOR(Address'range); 
begin
	process (Clock) 
		begin 
		if rising_edge(Clock) then 
			if WriteEnable = '1' then 
				Memory(to_integer(unsigned(Address))) <= DataIn; 
			end if; 
			ReadAddress <= Address;
		end if; 
	end process; 
	DataOut <= Memory(to_integer(unsigned(ReadAddress))); 
end Behavioral;