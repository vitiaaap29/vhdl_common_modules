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

entity device is
    Port ( Start : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
			  Stop : in STD_LOGIC);
end device;

architecture SturcutalDevice of device is

component fsm is 
	Port (
		stop, clock, rst, start : in  STD_LOGIC;
		-- Need we out clock from fsm?
		
		ram_rw: out std_logic;
		ram_addr: out std_logic_vector(4 downto 0);
		ram_dout: in std_logic_vector(7 downto 0);
		ram_din: out std_logic_vector(7 downto 0);
		
		rom_re: out std_logic;
		rom_adr: out std_logic_vector(3 downto 0);
		rom_dout: in std_logic_vector(10 downto 0);
		
		dp_operand: out std_logic_vector(7 downto 0);
		dp_ot: out std_logic_vector(2 downto 0);
		dp_res: in std_logic_vector(7 downto 0);
		dp_en: out std_logic;
		dp_reset: out std_logic);
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

component datapath is
	port(
		Reset_in : in STD_LOGIC; 
		WE_in : in STD_LOGIC; 
		Selector_in : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
		ram_in: in std_logic_vector(7 downto 0); 
		data_pass_out: out std_logic_vector(7 downto 0) 
	);
end component;


signal clock_fsm_to_datapath: std_logic; --?

--DataPath connection signals
signal fsm_dp_ot_to_datapath_selector: std_logic_vector(2 downto 0);
signal fsm_dp_oper_to_datapath_ram_in: std_logic_vector(7 downto 0);
signal datapath_out_to_fsm: std_logic_vector(7 downto 0);
signal fsm_dp_en_to_datapath_en: std_logic;
signal fsm_dp_reset_to_datapath_reset_in: std_logic;

--RAM connection signals
signal fsm_rw_to_ram_we: std_logic;
signal fsm_ram_addr_to_ram_address: STD_LOGIC_VECTOR(4 downto 0);
signal ram_dataout_to_fsm_ram_din: STD_LOGIC_VECTOR(7 downto 0);
signal fsm_ram_dout_to_ram_datain: STD_LOGIC_VECTOR(7 downto 0);

--ROM connection signals
signal fsm_rom_re_to_rom_re: std_logic;
signal fsm_rom_adr_to_rom_adr: STD_LOGIC_VECTOR(3 downto 0);
signal rom_dout_to_fsm_rom_dout: STD_LOGIC_VECTOR (10 downto 0);

begin

fsm_pm: fsm port map(
Stop,
	Clock, 
	Reset, 
	Start,
--	datapath_out_to_fsm => dp_res, --in

--	fsm_rw_to_ram_we => ram_rw, --out
--RAM
	fsm_rw_to_ram_we,
	fsm_ram_addr_to_ram_address,
	ram_dataout_to_fsm_ram_din,
	fsm_ram_dout_to_ram_datain,
--ROM		
	fsm_rom_re_to_rom_re,
	fsm_rom_adr_to_rom_adr,
	rom_dout_to_fsm_rom_dout,
--DataPath		
	fsm_dp_oper_to_datapath_ram_in, --out
	fsm_dp_ot_to_datapath_selector, --out
--	dp_en: out std_logic
	datapath_out_to_fsm,
	fsm_dp_en_to_datapath_en,
	fsm_dp_reset_to_datapath_reset_in
	); 


ram_pm: ram port map(
	fsm_rw_to_ram_we, --in
	fsm_ram_addr_to_ram_address,
	fsm_ram_dout_to_ram_datain,
	ram_dataout_to_fsm_ram_din 
);

rom_pm: rom port map(
	fsm_rom_re_to_rom_re,
	fsm_rom_adr_to_rom_adr,
	rom_dout_to_fsm_rom_dout
);

datapath_pm: datapath port map(
	fsm_dp_reset_to_datapath_reset_in,
	fsm_dp_en_to_datapath_en, --in ?
	fsm_dp_ot_to_datapath_selector, --in 
	fsm_dp_oper_to_datapath_ram_in,
	datapath_out_to_fsm --out
);

end SturcutalDevice;

