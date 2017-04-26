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

entity fsm is
    Port (
		stop, clock, rst, start : in  STD_LOGIC;
		
		ram_rw: out std_logic;
		ram_addr: out std_logic_vector(4 downto 0);
		ram_dout: in  std_logic_vector(7 downto 0);
		ram_din: out std_logic_vector(7 downto 0);
		
		rom_re: out std_logic;
		rom_adr: out std_logic_vector(3 downto 0);
		rom_dout: in std_logic_vector(10 downto 0);
		
		dp_operand: out std_logic_vector(7 downto 0);
		dp_ot: out std_logic_vector(2 downto 0);
		dp_res: in std_logic_vector(7 downto 0);
		dp_en: out std_logic;
		dp_reset: out std_logic);
end fsm;

architecture Behavioral of fsm is
	type STATE_TYPES is (
		idle_st,
		fetch_st, decode_st, read_ram_st, sub_st, store_st,
		inc_st, cmp_st, halt_st, je_st, load_st, load_by_acc_st, write_ram_st,
		alu_calc_st
	);
	signal cur_state, next_state: STATE_TYPES;
	signal instruction_register : std_logic_vector(10 downto 0);
	signal pc: std_logic_vector(3 downto 0); --index in rom
	signal operation_type: std_logic_vector(2 downto 0);
	
	signal RA: std_logic_vector(4 downto 0);
	signal RD: std_logic_vector(7 downto 0);
	
	signal compare_status: std_logic;
	
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
		if rst = '1' then
			cur_state <= idle_st;
		elsif rising_edge(clock) then
			cur_state <= next_state;
		end if;
	end process;

	next_state_proc: process(cur_state, start, operation_type)
	begin
		case cur_state is
			when idle_st =>
				if start = '1' then
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
						next_state <= cmp_st;
					when LOAD_BY_ACC =>
						next_state <= load_by_acc_st;
					when LOAD =>
						next_state <= load_st;
					when others =>
						next_state <= idle_st;
				end case;
			when je_st =>
				next_state <= fetch_st;
			when others =>
				next_state <= fetch_st;
		end case;	
	end process; 
	
	prog_counter: process(clock, rst, cur_state)
	begin
		if rst = '1' then
			pc <= "0000";
		elsif falling_edge(clock) then
			if cur_state = decode_st then
				compare_status <= dp_res(0);
				if operation_type = JE and compare_status = '1' then
					pc <= pc + RA;
				else
					pc <= pc + 1;
				end if;
			end if;
		end if;
	end process;
	
	rom_adr <= pc;
	
	control_instruction_register: process(rst, next_state, instruction_register)
	begin
		if rst = '1' then
			operation_type <= "000";
			RA <= "00000";
		elsif next_state = decode_st then
			operation_type <= instruction_register(10 downto 8);
			RA <= instruction_register(7 downto 0);
		end if;
	end process;
	
	ram_addr <= RA;
	
	rom_enable: process(next_state, cur_state)
	begin
		if next_state = fetch_st OR cur_state = fetch_st then
			rom_re <= '1';
		else
			rom_re <= '0';
		end if;
	end process;
	
	rom_read_data: process(rst, cur_state, rom_dout)
	begin
		if rst = '1' then
			instruction_register <= "00000000000";
		elsif cur_state = fetch_st then
			instruction_register <= rom_dout;
		end if;
	end process;
	
	ram_read: process(cur_state)
	begin
		if cur_state = store_st then
			ram_rw <= '0';
		else
			ram_rw <= '1';
		end if;
	end process;
	
	ram_data_control: process(cur_state)
	begin
		if cur_state = read_ram_st then
			RD <= ram_dout;
		end if;
	end process;
	
	ram_din <= dp_res;
	dp_operand <= RD;
	dp_ot <= operation_type;
	
	accumulator_enable_controler: process(cur_state)
	begin
		if (cur_state = inc_st or cur_state = sub_st or cur_state = load_st) then
			dp_en <= '1';
		else
			dp_en <= '0';
		end if;
	end process;

end Behavioral;

