----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Yarbrough
-- 
-- Create Date:    	10:33:47 07/07/2012 
-- Design Name:		CE3
-- Module Name:    	MooreFloorFinder - Behavioral 
-- Description: 		Takes a three switch input, then sends the elevator to that floor
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

entity MooreFloorFinder is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           toFloor : in  STD_LOGIC_VECTOR (3 downto 0);
			  onFloor : out  STD_LOGIC_VECTOR (3 downto 0));
end MooreFloorFinder;

architecture Behavioral of MooreFloorFinder is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 
type floor_state_type is 
	( floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!
signal floor_state : floor_state_type;

begin
---------------------------------------------
--Below you will code your next-state process
---------------------------------------------

--This line will set up a process that is sensitive to the clock
floor_state_machine: process(clk)
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	if rising_edge(clk) then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
		--changed to from floor1 to floor2 for prime number problem
			floor_state <= floor0;
--------------------- code below is for specific functionalities ----------------

		elsif (stop='0') then--moving up
			case floor_state is
				when floor0 =>
					floor_state <= floor1;
				when floor1 =>
					floor_state <= floor2;
				when floor2 =>
					floor_state <= floor3;
				when floor3 =>
					floor_state <= floor4;
				when floor4 =>
					floor_state <= floor5;
				when floor5 =>
					floor_state <= floor6;
				when floor6 =>
					floor_state <= floor7;
				when floor7 =>
					floor_state <= floor7;
				when others =>
					floor_state <= floor0;
			end case;
		elsif (stop='1') then--moving down
			case floor_state is
				when floor0 =>
					floor_state <= floor0;
				when floor1 =>
					floor_state <= floor0;
				when floor2 =>
					floor_state <= floor1;
				when floor3 =>
					floor_state <= floor2;
				when floor4 =>
					floor_state <= floor3;
				when floor5 =>
					floor_state <= floor4;
				when floor6 =>
					floor_state <= floor5;
				when floor7 =>
					floor_state <= floor6;
				when others =>
					floor_state <= floor0;
				end case;
			end if;
		end if;
	end process;

-- Here you define your output logic. Finish the statements below
--takes care of the 1s place for the elevator
onFloor <= "0000" when ( floor_state = floor0 ) else
			"0001" when ( floor_state = floor1 ) else
			"0010" when ( floor_state = floor2 ) else
			"0011" when ( floor_state = floor3 ) else
			"0100" when ( floor_state = floor4 ) else
			"0101" when ( floor_state = floor5 ) else
			"0110" when ( floor_state = floor6 ) else
			"0111" when ( floor_state = floor7 ) else
			"0000";

end Behavioral;

