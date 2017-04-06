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
		clock, rst, start : in  STD_LOGIC;
		compare_status: in STD_LOGIC;
		datapath_output: in STD_LOGIC_VECTOR;
		
		ram_write_enable: out std_logic;
		ram_addr: std_logic_vector(7 downto 0);
		ram_data_in: std_logic_vector(7 downto 0);
		ram_data_in: std_logic_vector(7 downto 0);
		
		dp_operand: out std_logic_vector(7 downto 0);
		dp_ot: out std_logic_vector(2 downto 0);
		dp_res: in std_logic_vector(7 downto 0);
		dp_en: out std_logic;
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
--		0 => "11100000000", --load cur_adr => cur_adr = 0x00 cur_adr in RAM => acc = [cur_adr]
--		1 => "11010000000", --load_by_acc
--		2 => "00010100",

	type STATE_TYPES is (
		idle_st,
		fetch_st, decode_st, read_ram_st, sub_st, store_st,
		inc_st, cmp_st, halt_st, je_st, load_st, load_by_acc_st, write_ram_st,
		alu_calc_st
	);
	signal state, next_state: STATE_TYPES;
	signal instruction_register: STD_LOGIC_VECTOR(10 downto 0);
	signal pc: std_logic_vector(7 downto 0); --index in rom
	signal operation_type: std_logic_vector(2 downto 0);
	signal before_read_operation_type: std_logic_vector(3 downto 0);
	
	constant SUB: std_logic_vector(2 downto 0) := "000";
	constant STORE: std_logic_vector(2 downto 0) := "001";
	constant INC: std_logic_vector(2 downto 0) := "010";
	constant CMP: std_logic_vector(2 downto 0) := "011";
	constant HALT: std_logic_vector(2 downto 0) := "100";
	constant JE: std_logic_vector(2 downto 0) := "101";
	constant LOAD_BY_ACC: std_logic_vector(2 downto 0) := "110";
	constant LOAD: std_logic_vector(2 downto 0) := "111";
begin
	sync_memory: process(clock, rst, next_state)
	begin
		if rst = "1" then
			state <= idle_st;
		elsif rising_edge(clock) then
			state <= next_state;
		end if;
	end process;

	next_state: process(cur_state, start, operation_type)
	begin
		if reset = "1" then
			next_state <= fetch_st;
		else
			case cur_state is
				when idle_st =>
					if start = "1" then
						next_state <= fetch_st;
					else
						next_state <= idle_st;
					end if;
				when fetch_st =>
					next_state <= decode_st;
				when decode_st =>
					if operation_type = HALT then
						next_state <= halt_st;
					elsif operation_type = STORE then
						next_state <= store_st;
					elsif operation_type = JE then
						next_state <= je_st;
					elsif operation_type = INC then
						next_state <= inc_st;
					else 
						next_state <= read_ram_st;
					end if;
				when halt_st =>
					next_state <= halt_st;
				when read_ram_st =>
					case operation_type is
						when SUB =>
							next_state <= sub_st;
						when CMP =>
							next_state <= cpm_st;
						when JE =>
							next_state <= je_st;
						when LOAD_BY_ACC =>
							next_state <= load_by_acc_st;
						when LOAD =>
							next_state <= load_st;
						when others =>
							next_state <= idle_st;
					end case;
				when je_st =>
					state <= fetch_st;
				when others =>
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

