library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( Selector : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           A : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           Output : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end ALU;

architecture Behavioral of ALU is
begin
	process (Selector, A, B)
	begin
		case Selector is
			when "000" => Output <= A;
			when "001" => Output <= A OR B;
			when "010" => Output <= NOT A;
			when "011" => Output <= A + B;
			when "100" => Output <= A - B;
			when "101" => Output <= A + 1;
			when "110" => Output <= A - 1;
			when others => 
				if (A > B) then
					Output(0) <= '1';
				else
					Output(0) <= '0';
				end if;
		end case;
	end process;
end Behavioral;