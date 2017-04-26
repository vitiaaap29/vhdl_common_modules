--By page 8 of Ivanuks's 14th lection for 5 cource of POIT
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

entity rom is
    Port ( RE : in  STD_LOGIC;
           ADR : in  STD_LOGIC_VECTOR(3 downto 0); --16 operations are max count of operations.
           DOUT : out  STD_LOGIC_VECTOR (10 downto 0));
end rom;

architecture Behavioral of rom is
subtype inst is std_logic_vector(10 downto 0);
type tRom is array(0 to 1) of inst; --normal size is 15

--constant SUB: std_logic_vector(2 downto 0) := "000";
--constant STORE: std_logic_vector(2 downto 0) := "001";
--constant INC: std_logic_vector(2 downto 0) := "010";
--constant CMP: std_logic_vector(2 downto 0) := "011";
--constant HALT: std_logic_vector(2 downto 0) := "100";
--constant JE: std_logic_vector(2 downto 0) := "101";
--constant LOAD_BY_ACC: std_logic_vector(2 downto 0) := "110";
--constant LOAD: std_logic_vector(2 downto 0) := "111";

--RAM
--adr  value label
--0x00 0x10  cur_adr
--0x01 0x15  end_adr
--...
--0x10 0x1A array of number
--0x11 0x0A
--...
--0x15 0x39 last array number
--0x16 0x00 res_adr

constant ROM: tRom := (
					  --loop: loop is adr in room
--	"111"&"00000000", --load cur_adr  --> acc <= RAM[cur_adr], acc = 0x10
--	"110"&"00000000", --load_by_acc   --> acc <= RAM[acc], acc = 0x1A
--	"000"&"00010000", --sub res_adr   --> acc <= RAM[result_adr] - acc, acc = -0x1A
--	"001"&"00010000", --store res_adr --> RAM[result_adr] <= acc; RAM[result_adr] = -0x1A, in DD 0x11110001
--	"111"&"00000000", --load cur_adr  --> acc <= RAM[cur_adr]; acc = 0x00
--	"010"&"00000000", --inc           --> acc <= acc++, acc = 0x01
--	"001"&"00000000", --store cur_adr --> RAM[cur_adr] <= acc, RAM[cur_adr] = 0x01
--	"111"&"00000000", --load cur_adr  --> acc = RAM[cur_adr], acc = 0x01
--	"011"&"00000000", --cmp end_adr   --> STATUS = end_adr > acc ? 1 : 0
--	"101"&"00000000", --je loop		 --> PC = loop if STATUS == 1 else PC++
--	"100"&"00000000"  --halt          --> end execution
"111"&"00000000",
"100"&"00000000"
);

signal current_instruction: inst;
	
begin
current_instruction <= ROM(to_integer(unsigned(ADR)));

zbufs: process(RE, current_instruction)
begin
	if (RE = '1' ) then
		DOUT <= current_instruction;
	else
		DOUT <= (others => 'Z');
	end if;
end process;

end Behavioral;

