----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: Silva created Shell
-- 			Yarbrough completed project
-- 
-- Create Date:    12:43:25 07/07/2012 
-- Module Name:    Nexys2_Lab3top - Structural 
-- Target Devices: Nexys2 Project Board
-- Tool versions: 
-- Description: This file is a shell for implementing designs on a NEXYS 2 board
-- As is right now (uncommenting sections will alter functionality) the controller allows for an input
-- of which floor you are on and you call the elevator from. This is done with the leftmost three switches.
-- The nearest elevator will come to pick up on that floor, LED lights will flash one direction while moving up, and the other direction when moving down
-- To move a specific elevator, set the rightmost switches, then press button 1 or 0. Button 2 and 3 reset that elevator to floor zero.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating	
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nexys2_top_shell is
    Port ( 	clk_50m : in STD_LOGIC;
				btn : in  STD_LOGIC_VECTOR (3 DOWNTO 0);
				switch : in STD_LOGIC_VECTOR (7 DOWNTO 0);
				SSEG_AN : out STD_LOGIC_VECTOR (3 DOWNTO 0);
				SSEG : out STD_LOGIC_VECTOR (7 DOWNTO 0);
				LED : out STD_LOGIC_VECTOR (7 DOWNTO 0));
end Nexys2_top_shell;

architecture Behavioral of Nexys2_top_shell is

---------------------------------------------------------------------------------------
--This component converts a nibble to a value that can be viewed on a 7-segment display
--Similar in function to a 7448 BCD to 7-seg decoder
--Inputs: 4-bit vector called "nibble"
--Outputs: 8-bit vector "sseg" used for driving a single 7-segment display
---------------------------------------------------------------------------------------
	COMPONENT nibble_to_sseg
	PORT(
		nibble : IN std_logic_vector(3 downto 0);          
		sseg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

---------------------------------------------------------------------------------------------
--This component manages the logic for displaying values on the NEXYS 2 7-segment displays
--Inputs: system clock, synchronous reset, 4 8-bit vectors from 4 instances of nibble_to_sseg
--Outputs: 7-segment display select signal (4-bit) called "sel", 
--         8-bit signal called "sseg" containing 7-segment data routed off-chip
---------------------------------------------------------------------------------------------
	COMPONENT nexys2_sseg
	GENERIC ( CLOCK_IN_HZ : integer );
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		sseg0 : IN std_logic_vector(7 downto 0);
		sseg1 : IN std_logic_vector(7 downto 0);
		sseg2 : IN std_logic_vector(7 downto 0);
		sseg3 : IN std_logic_vector(7 downto 0);          
		sel : OUT std_logic_vector(3 downto 0);
		sseg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

-------------------------------------------------------------------------------------
--This component divides the system clock into a bunch of slower clock speeds
--Input: system clock 
--Output: 27-bit clockbus. Reference module for the relative clock speeds of each bit
--			 assuming system clock is 50MHz
-------------------------------------------------------------------------------------
	COMPONENT Clock_Divider
	PORT(
		clk : IN std_logic;          
		clockbus : OUT std_logic_vector(26 downto 0)
		);
	END COMPONENT;

-------------------------------------------------------------------------------------
--Below are declarations for signals that wire-up this top-level module.
-------------------------------------------------------------------------------------

signal nibble0, nibble1, nibble2, nibble3 : std_logic_vector(3 downto 0);
signal sseg0_sig, sseg1_sig, sseg2_sig, sseg3_sig : std_logic_vector(7 downto 0);
signal ClockBus_sig : STD_LOGIC_VECTOR (26 downto 0);


--------------------------------------------------------------------------------------
--Insert your design's component declaration below	
--------------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------------
-- Add MooreElevatorController Component for CE3
-- Input: clk, reset, stop, up_down
-- Output: floor
-------------------------------------------------------------------------------------
	COMPONENT MooreElevatorController
	PORT(
    clk : IN  STD_LOGIC;
    reset : IN  STD_LOGIC;
	 stop : IN  STD_LOGIC;
	 up_down : IN  STD_LOGIC;
	 floor1s : OUT  STD_LOGIC_VECTOR (3 downto 0);
	 floor10s : out  STD_LOGIC_VECTOR (3 downto 0)
    );
	END COMPONENT;
	
	COMPONENT MealyElevatorController
	 PORT( 
		clk : in  STD_LOGIC;
		  reset : in  STD_LOGIC;
		  stop : in  STD_LOGIC;
		  up_down : in  STD_LOGIC;
		  floor : out  STD_LOGIC_VECTOR (3 downto 0);
		  nextfloor : out std_logic_vector (3 downto 0)
		  );
		END COMPONENT;

	COMPONENT FloorSelect
	PORT(
		clk : in  STD_LOGIC;
      reset : in  STD_LOGIC;
      toFloor : in  STD_LOGIC_VECTOR (3 downto 0);
	  curFloor : in  STD_LOGIC_VECTOR (3 downto 0);
	  onFloor : out  STD_LOGIC_VECTOR (3 downto 0)
	);
	END COMPONENT;

--------------------------------------------------------------------------------------
--Insert any required signal declarations below
--------------------------------------------------------------------------------------

signal floor_sig0 : std_logic_vector(3 downto 0);
signal floor_sig1 : std_logic_vector(3 downto 0);

--used for floorfinder only
signal swRead0 : std_logic_vector(3 downto 0);
signal swRead1 : std_logic_vector(3 downto 0);

--call the elevator to a specific floor
signal callElevator : std_logic_vector(3 downto 0);

begin

----------------------------
--code below tests the LEDs:
----------------------------
--LED <= CLOCKBUS_SIG(26 DOWNTO 19);

--------------------------------------------------------------------------------------------	
--This code instantiates the Clock Divider. Reference the Clock Divider Module for more info
--------------------------------------------------------------------------------------------
	Clock_Divider_Label: Clock_Divider PORT MAP(
		clk => clk_50m,
		clockbus => ClockBus_sig
	);

--------------------------------------------------------------------------------------	
--Code below drives the function of the 7-segment displays. 
--Function: To display a value on 7-segment display #0, set the signal "nibble0" to 
--				the value you wish to display
--				To display a value on 7-segment display #1, set the signal "nibble1" to 
--				the value you wish to display...and so on
--Note: You must set each "nibble" signal to a value. 
--		  Example: if you are not using 7-seg display #3 set nibble3 to "0000"
--------------------------------------------------------------------------------------


nibble0 <= floor_sig0;
nibble1 <= floor_sig1;
nibble2 <= "0000";
nibble3 <= callElevator;

--This code converts a nibble to a value that can be displayed on 7-segment display #0
	sseg0: nibble_to_sseg PORT MAP(
		nibble => nibble0,
		sseg => sseg0_sig
	);

--This code converts a nibble to a value that can be displayed on 7-segment display #1
	sseg1: nibble_to_sseg PORT MAP(
		nibble => nibble1,
		sseg => sseg1_sig
	);

--This code converts a nibble to a value that can be displayed on 7-segment display #2
	sseg2: nibble_to_sseg PORT MAP(
		nibble => nibble2,
		sseg => sseg2_sig
	);

--This code converts a nibble to a value that can be displayed on 7-segment display #3
	sseg3: nibble_to_sseg PORT MAP(
		nibble => nibble3,
		sseg => sseg3_sig
	);
	
--This module is responsible for managing the 7-segment displays, you don't need to do anything here
	nexys2_sseg_label: nexys2_sseg 
	generic map ( CLOCK_IN_HZ => 50E6 )
	PORT MAP(
		clk => clk_50m,
		reset => '0',
		sseg0 => sseg0_sig,
		sseg1 => sseg1_sig,
		sseg2 => sseg2_sig,
		sseg3 => sseg3_sig,
		sel => SSEG_AN,
		sseg => SSEG
	);

-----------------------------------------------------------------------------
--Instantiate the design you with to implement below and start wiring it up!:
-----------------------------------------------------------------------------

------------------------------------ for the Mealy --------------------------
--	MealyControl: MealyElevatorController
--	PORT MAP(
--		 clk => ClockBus_sig(25),
--		 reset => btn(3),
--		 stop => switch(0), 
--		 up_down => switch(1), 
--		 floor => floor_sig0, 
--		 nextfloor => floor_sig1
--    );

------------------------------------------------------------------------------

----------------- instantiates prime number controller
-- MoorePrime: MooreElevatorController
--	 PORT MAP(
--		 clk => ClockBus_sig(25),
--		 reset => btn(3),
--		 stop => switch(0), 
--		 up_down => switch(1), 
--		 floor1s => floor_sig0,
--		 floor10s => floor_sig1
--	 );
-----------------------------------------------------

---------------------- instantiates floor finder ------------

-- first 7 floor elevator
Selectornator0: FloorSelect
	PORT MAP(
		clk => ClockBus_sig(25),
		reset => btn(2),
		toFloor => swRead0, 
		curFloor => floor_sig0, 
		onFloor => floor_sig0
	  );
	 
--second 7 floor elevator
Selectornator1: FloorSelect
	PORT MAP(
		clk => ClockBus_sig(25),
		reset => btn(3),
		toFloor => swRead1, 
		curFloor => floor_sig1, 
		onFloor => floor_sig1
	  );	  

--set switches to the signal
switch_setter: process(ClockBus_sig(25))
	--switch(0), switch(1), switch(2), switch(3), btn(0), btn(1), btn(2), btn(3))
begin
	--check which floor to activate
	if rising_edge(ClockBus_sig(25)) then
		--set elevators to floor
		if (btn(0) = '1') then --move the elevator0
			swRead0(3) <= '0';
			swRead0(2) <= switch(2);
			swRead0(1) <= switch(1);
			swRead0(0) <= switch(0);
		elsif (btn(1) ='1') then --move elevator1
			swRead1(3) <= '0';
			swRead1(2) <= switch(2);
			swRead1(1) <= switch(1);
			swRead1(0) <= switch(0);
		end if;
		
		--deal with elevator call, neither elevator is on the floor
		if ( callElevator /= floor_sig0 ) and ( callElevator /= floor_sig1) then
			--check which is closer
			if(abs(SIGNED((UNSIGNED(floor_sig0) - UNSIGNED(callElevator))))
			  <= abs(SIGNED((UNSIGNED(floor_sig1) - UNSIGNED(callElevator)))))then --elevator0 is closer
				swRead0(3) <= '0';
				swRead0(2) <= switch(7);
				swRead0(1) <= switch(6);
				swRead0(0) <= switch(5);
			else --the other elevator is closer
				swRead1(3) <= '0';
				swRead1(2) <= switch(7);
				swRead1(1) <= switch(6);
				swRead1(0) <= switch(5);
			end if;
		end if;
	end if;
			--set LEDs, done based on the clock
			if floor_sig0 < swRead0 or floor_sig1 < swRead1 then --an elevator is moving up
				LED <= CLOCKBUS_SIG(26 DOWNTO 19);
			elsif floor_sig0 > swRead0 or floor_sig1 > swRead1 then--an elevator is moving down, wire clock backwards
				LED(7) <= CLOCKBUS_SIG(19);
				LED(6) <= CLOCKBUS_SIG(20);
				LED(5) <= CLOCKBUS_SIG(21);
				LED(4) <= CLOCKBUS_SIG(22);
				LED(3) <= CLOCKBUS_SIG(23);
				LED(2) <= CLOCKBUS_SIG(24);
				LED(1) <= CLOCKBUS_SIG(25);
				LED(0) <= CLOCKBUS_SIG(26);
			else --all stopped
				LED(7) <= CLOCKBUS_SIG(25);
				LED(6) <= CLOCKBUS_SIG(25);
				LED(5) <= CLOCKBUS_SIG(25);
				LED(4) <= CLOCKBUS_SIG(25);
				LED(3) <= CLOCKBUS_SIG(25);
				LED(2) <= CLOCKBUS_SIG(25);
				LED(1) <= CLOCKBUS_SIG(25);
				LED(0) <= CLOCKBUS_SIG(25);
			end if;			
	--end if;
end process;

--wire the floor call to the leftmost switches
callElevator(3) <= '0';
callElevator(2) <= switch(7);
callElevator(1) <= switch(6);
callElevator(0) <= switch(5);

end Behavioral;

