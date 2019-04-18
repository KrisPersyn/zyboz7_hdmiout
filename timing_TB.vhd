------------------------------------------------------------
-- Company:			KU Leuven
-- Engineer:		
--
-- Project Name:	
-- Design Name:		
--
-- Create Date:		14/04/2019
-- Module Name:		timing_TB - Testbench
-- Revision:		
-- Description:		
--
-- Target Devices:	
--
-- Comments: 		
--
-- Notes: 
-- 		This testbench has been automatically generated using types STD_LOGIC and
-- 		STD_LOGIC_VECTOR for the ports of the unit under test.  Xilinx recommends
-- 		that these types always be used for the top-level I/O of a design in order
-- 		to guarantee that the testbench will bind correctly to the post-implementation 
-- 		simulation model.
------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity timing_TB is
end timing_TB;

architecture behavior of timing_TB is

	-- Component declaration for the Unit Under Test (UUT)
	component timing
		port (	
				CE : in STD_LOGIC;
				CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				rgb_in : in STD_LOGIC_VECTOR(23 downto 0);
				CLKx : out STD_LOGIC;
				frame_done : out STD_LOGIC;
				h_sync : out STD_LOGIC;
				v_sync : out STD_LOGIC;
				video_en : out STD_LOGIC;
				rgb_out : out STD_LOGIC_VECTOR(23 downto 0);
				x : out STD_LOGIC_VECTOR(10 downto 0);
				y : out STD_LOGIC_VECTOR(10 downto 0)
			);
    end component;
    

	--Inputs
	signal CE : STD_LOGIC := '0';
	signal CLK : STD_LOGIC := '0';
	signal RESET : STD_LOGIC := '0';
	signal rgb_in : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');

	--Outputs
	signal CLKx : STD_LOGIC;
	signal frame_done : STD_LOGIC;
	signal h_sync : STD_LOGIC;
	signal v_sync : STD_LOGIC;
	signal video_en : STD_LOGIC;
	signal rgb_out : STD_LOGIC_VECTOR(23 downto 0);
	signal x : STD_LOGIC_VECTOR(10 downto 0);
	signal y : STD_LOGIC_VECTOR(10 downto 0);

	-- Clock period definition
	constant CLK_PERIOD : time := 7 ns;
	constant CLKx_PERIOD : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
	uut : timing
	port map (
				CE => CE,
				CLK => CLK,
				RESET => RESET,
				rgb_in => rgb_in,
				CLKx => CLKx,
				frame_done => frame_done,
				h_sync => h_sync,
				v_sync => v_sync,
				video_en => video_en,
				rgb_out => rgb_out,
				x => x,
				y => y
			);

	-- Clock process definitions
	CLK_process : process
	begin
		CLK <= '0';
		wait for CLK_PERIOD/2;
		CLK <= '1';
		wait for CLK_PERIOD/2;
	end process;

	-- Stimulus process
	stim_process: process
	begin		
		-- Activate reset here
		RESET <= '1';
		CE <='1';
		rgb_in <= std_logic_vector(to_unsigned(16711680,24));
		-- Define all inputs here
		
		wait for CLK_PERIOD*10;
		-- Release reset here
		RESET <= '0';
		-- Insert stimulus here
		
		wait;
	end process;

end;
