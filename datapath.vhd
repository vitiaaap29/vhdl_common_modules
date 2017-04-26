-- Company: 
-- Engineer: 
-- 
-- Create Date: 10:07:49 03/30/2017 
-- Design Name: 
-- Module Name: top_component - Behavioral 
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
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

-- Uncomment the following library declaration if using 
-- arithmetic functions with Signed or Unsigned values 
--use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if instantiating 
-- any Xilinx primitives in this code. 
--library UNISIM; 
--use UNISIM.VComponents.all; 

entity datapath is 
	port(
		Clock_in : in STD_LOGIC; 
		Selector_in : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
		ram_in: in std_logic_vector(7 downto 0); 
		data_pass_out: out std_logic_vector(7 downto 0) 
	); 
end datapath; 

architecture struct of datapath is 

component Accumulator is 
	port( Clock : in STD_LOGIC; 
		InPort : in STD_LOGIC_VECTOR(7 downto 0);
		OutPort : out STD_LOGIC_VECTOR(7 downto 0) );
end component; 

component ALU is 
	port( Selector : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
		A : in STD_LOGIC_VECTOR(7 DOWNTO 0); 
		B : in STD_LOGIC_VECTOR(7 DOWNTO 0); 
		Output : out STD_LOGIC_VECTOR(7 DOWNTO 0) 
	); 
end component; 

signal ALU_to_ACC: std_logic_vector(7 downto 0); 
signal ACC_to_ALU: std_logic_vector(7 downto 0); 

begin 
	ALU_to_ACC <= "00000"; 
	ACC_to_ALU <= "00000"; 

	ALU_U: ALU port map(Selector_in, ram_in, ACC_to_ALU, ALU_to_ACC); 
	ACC_U: Accumulator port map(Clock_in, ALU_to_ACC, ACC_to_ALU); 

end struct;