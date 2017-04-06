library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    Port ( RW : in STD_LOGIC;
			  Address : in STD_LOGIC_VECTOR(4 downto 0);
			  DataIn : in STD_LOGIC_VECTOR(7 downto 0);
           DataOut : out STD_LOGIC_VECTOR(7 downto 0));
end RAM;

architecture Behavioral of RAM is

	subtype BYTE is STD_LOGIC_VECTOR(7 downto 0);
	type TMemory is array (0 to 31) of BYTE;
	signal Memory : TMemory := ( 
		0 => "10101010", 
		1 => "00001010", 
		2 => "00010100", 
		others => "00000000");
	signal data_in : BYTE;
	signal data_out : BYTE;
	
begin
	data_in <= DataIn;
	process (RW, Address, data_in)
	begin
		if (RW = '1') then
			Memory(to_integer(unsigned(Address))) <= data_in;
		end if;	
	end process;
	data_out <= Memory(to_integer(unsigned(Address)));
	process (RW, data_out)
	begin
		if (RW = '0') then
			DataOut <= data_out;
		else
			DataOut <= (others => 'Z');
		end if;
	end process;
end Behavioral;