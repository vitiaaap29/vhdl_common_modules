library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Accumulator is
    Port ( Reset : in STD_LOGIC;
			  WE : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR(7 downto 0);
           DataOut : out STD_LOGIC_VECTOR(7 downto 0));
end Accumulator;

architecture Behavioral of Accumulator is

	signal Value : STD_LOGIC_VECTOR(7 downto 0);
	
begin
	process (WE, Reset)
	begin
		if (Reset = '1') then
			Value <= (others => '0');
		end if;
		if rising_edge(WE) then
			Value <= DataIn;
		end if;
	end process;
	DataOut <= Value;
end Behavioral;