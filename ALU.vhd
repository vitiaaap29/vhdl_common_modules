----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:54:58 03/25/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( Selector : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           A : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			  Status: out STD_LOGIC_VECTOR(1 DOWNTO 0);
           Output : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end ALU;

architecture Behavioral of ALU is
begin
	process (Selector, A, B)
	begin
		case Selector is
			when "000" => Output <= A;
			when "001" => Output <= A AND B;
			when "010" => Output <= A OR B;
			when "011" => Output <= NOT A;
			when "100" => Output <= A + B;
			when "101" => Output <= A - B;
			when "110" => Output <= A + 1;
--			when "111" => Output(0) <= A > B; --Need stadndalone process.
			when others => Output <= A - 1;
		end case;
	end process;
	
--	status_change: process(Selector, output)
--	begin
--		if Selector = "111" then
--			Status(0) <= output(0);
--		end if;
--	end process;
end Behavioral;

--Line 53: found '0' definitions of operator ">", cannot determine exact overloaded matching definition for ">"
--Line 61: Cannot read from 'out' object output ; use 'buffer' or 'inout'
--Line 58: output with mode 'out' cannot be readVHDL file C:/MyData/Stas/code/vhdl_common_modules/ALU.vhd ignored due to errors
--Line 41: Unit <behavioral> ignored due to previous errors.