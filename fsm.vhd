----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:08:24 04/02/2017 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
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

entity fsm is
    Port (
		reset : in  STD_LOGIC;
		compare_status: in STD_LOGIC;
		datapath_output: in STD_LOGIC_VECTOR;
		write_enable: out std_logic;
		ram_addr: std_logic_vector(7 downto 0);
		alu_selector : out  STD_LOGIC_VECTOR (2 downto 0));
end fsm;

	--RAM
	--adr  value
	--0x00 0x10
	--0x01 0x15 end adr array
	--...
	--0x10 0xAA
	--...
	--0x15 0x39 last array number

architecture Behavioral of fsm is
	type ROM is array (0 to 31) of STD_LOGIC_VECTOR(10 downto 0); 
	signal rom_micro_prog : ROM := ( 
		0 => "11100000000", --load cur_adr => cur_adr = 0x00 cur_adr in RAM => acc = [cur_adr]
		1 => "11010000000", --load_by_acc
		2 => "00010100",
		others => "00000000");

	type STATE_TYPE is (
		fetch_st, decode_st, read_ram_st, sub_st, store_st,
		inc_st, cmp_st, halt_st, je_st, load_st, load_by_acc_st, write_ram_st,
		alu_calc_st
	);
	signal state: STATE_TYPE;
	signal instruction_register: STD_LOGIC_VECTOR(10 downto 0);
	signal pc: std_logic_vector(7 downto 0); --index in rom
	
	--signals for ram
	signal last_alu_result: std_logic_vector(7 downto 0);
	signal operation_type: std_logic_vector(10 downto 0);
	signal before_read_operation_type: std_logic_vector(3 downto 0);
begin
	next_state: process(clock, reset)
	begin
		if reset = "1" then
			state <= fetch_st;
		else
			case state is
				when fetch_st =>
					instruction_register <= rom_micro_prog(to_integer(unsigned(pc)));
				when decode_st =>
					operation_type <= insturction_register and "11100000000";
					case operation_type is
						when "00000000000" =>
							state <= sub_st;
						when "00100000000" =>
							state <= store_st;
						when "01000000000" =>
							state <= inc_st;
						when "01100000000" =>
							state <= cpm_st;
						when "10000000000" =>
							state <= halt_st;
						when "10100000000" =>
							state <= je_st;
						when "11000000000" =>
							state <= load_by_acc_st;
						when others => --"11100000000"
							state <= load_st;
					end case;
				when sub_st =>
					before_read_operation_type <= instruction_register(10 downto 8);
					state <= read_ram_st;
				when read_ram_st =>
					state <= alu_calc_st;
				when je_st =>
					state <= fetch_st;
				when others =>
--					if state = je_st then
--						if compare_status = "1" then
--							pc <= datapath_output;
--						else
--							pc <= pc + 1; --Should it be in ALU?
--						end if;
--					else
--						pc <= pc + 1;
--					end if;
					state <= fetch_st;
			end case;	
		end if;
	end process; 
	
	output_logic: process(state)--can we change a state?
	begin
		case state is
			when fetch_st =>
				--instruction_register <= rom_micro_prog(to_integer(unsigned(pc))); where is beter sie? here? or in 69 line
			when read_ram_st =>
				ram_addr <= instruction_register(7 downto 0);
				write_enable <= '0';
			when alu_calc_st =>
				case before_read_ram_st is 
					when "000" => --sub OT
						alu_selector <= "101";
					when "011" => --inc OT
						alu_selector <= "110";
					when "100" => --cmp
						alu_selector <= "111";
				end case;
				pc <= pc + 1;
			when je_st =>
				if compare_status = '1' then
					pc <= pc + instruction_register(7 downto 0);
				else
					pc <= pc + 1;
				end if; 
		end case;
	end process;

end Behavioral;

