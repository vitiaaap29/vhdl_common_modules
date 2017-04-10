library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity device is
    Port ( Start : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clock : in  STD_LOGIC);
end device;

architecture SturcutalDevice of device is

component fsm is 
	Port (
		clock, rst, start : in  STD_LOGIC;
		-- Need we out clock from fsm?
		
		ram_rw: out std_logic;
		ram_addr out: std_logic_vector(7 downto 0);
		ram_dout in : std_logic_vector(7 downto 0);
		ram_din out: std_logic_vector(7 downto 0);
		
		rom_re: out std_logic_vector;
		rom_adr: out std_logic_vector(7 downto 0);
		rom_dout: in std_logic_vector(7 downto 0);
		
		dp_operand: out std_logic_vector(7 downto 0);
		dp_ot: out std_logic_vector(2 downto 0);
		dp_res: in std_logic_vector(7 downto 0);
		dp_en: out std_logic;
end component; 

component rom is
	Port (
		RE : in  STD_LOGIC;
	   ADR : in  STD_LOGIC_VECTOR(3 downto 0); --16 operations are max count of operations.
      DOUT : out  STD_LOGIC_VECTOR (10 downto 0));
end component;

component ram is
	Port (
		RW : in STD_LOGIC;
		Address : in STD_LOGIC_VECTOR(4 downto 0);
		DataIn : in STD_LOGIC_VECTOR(7 downto 0);
		DataOut : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component alu_accum is
	port(
		Clock_in : in STD_LOGIC; 
		Selector_in : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
		ram_in: in std_logic_vector(7 downto 0); 
		data_pass_out: out std_logic_vector(7 downto 0) 
	);
end component;

signal datapath_out_to_fsm: std_logic_vector(7 downto 0);
signal clock_fsm_to_datapath: std_logic; --?
signal fsm_dp_ot_to_datapath_selector: std_logic_vector(2 downto 0);
signal fsm_dp_oper_to_datapath_ram_in: std_logic_vector(7 downto 0);
signal fsm_rw_to_ram_we: std_logic;

begin

fsm_pm: fsm port map(
	Clock =>	clock, 
	Reset => rst, 
	Start => start,
	datapath_out_to_fsm => dp_res, --in
	fsm_rw_to_ram_we => ram_rw, --out
--	ram_rw: out std_logic;
--	ram_addr out: std_logic_vector(7 downto 0);
--	ram_dout in : std_logic_vector(7 downto 0);
--	ram_din out: std_logic_vector(7 downto 0);
--		
--		rom_re: out std_logic_vector;
--		rom_adr: out std_logic_vector(7 downto 0);
--		rom_dout: in std_logic_vector(7 downto 0);
		
	fsm_dp_oper_to_datapath_ram_in => dp_operand, --out
	fsm_dp_ot_to_datapath_selector => dp_ot, --out
--	dp_en: out std_logic
	); 
);

ram_pm: ram port map(
	fsm_rw_to_ram_we => RW, --in
--	Address : in STD_LOGIC_VECTOR(4 downto 0);
--	DataIn : in STD_LOGIC_VECTOR(7 downto 0);
--	DataOut : out STD_LOGIC_VECTOR(7 downto 0)
);

datapath_pm: alu_accum port map(
	Clock => Clock_in, --in ?
	fsm_dp_ot_to_datapath_selector => Selector_in, --in 
	ram_in: in std_logic_vector(7 downto 0); 
	datapath_out_to_fsm => data_pass_out, --out
);

end SturcutalDevice;

