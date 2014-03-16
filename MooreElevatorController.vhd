----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva & Yarbrough
-- 
-- Create Date:    	10:33:47 07/07/2012 
-- Design Name:		CE3
-- Module Name:    	MooreElevatorController - Behavioral 
-- Description: 		Shell for completing CE3
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

entity MooreElevatorController is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor1s : out  STD_LOGIC_VECTOR (3 downto 0);
			  floor10s : out  STD_LOGIC_VECTOR (3 downto 0));
end MooreElevatorController;

architecture Behavioral of MooreElevatorController is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 
type floor_state_type is 
	( floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7, floor11, floor13, floor17, floor19);

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
			floor_state <= floor2;
--------------------- code below is for specific functionalities ----------------

---------------------------------------------------------------------------------
-- Prime number controller --
----------------------------------------------------------------------------------
		elsif (stop='0' and up_down='1') then--moving up
			case floor_state is
				when floor2 =>
					floor_state <= floor3;
				when floor3 =>
					floor_state <= floor5;
				when floor5 =>
					floor_state <= floor7;
				when floor7 =>
					floor_state <= floor11;
				when floor11 =>
					floor_state <= floor13;
				when floor13 =>
					floor_state <= floor17;
				when floor17 =>
					floor_state <= floor19;
				when floor19 =>
					floor_state <= floor19;
				when others =>
					floor_state <= floor2;
			end case;
		elsif (stop='0' and up_down='0') then--moving down
			case floor_state is
				when floor2 =>
					floor_state <= floor2;
				when floor3 =>
					floor_state <= floor2;
				when floor5 =>
					floor_state <= floor3;
				when floor7 =>
					floor_state <= floor5;
				when floor11 =>
					floor_state <= floor7;
				when floor13 =>
					floor_state <= floor11;
				when floor17 =>
					floor_state <= floor13;
				when floor19 =>
					floor_state <= floor17;
				when others =>
					floor_state <= floor2;
				end case;
			end if;
		end if;
	end process;
---------------- end prime number controller ----------------------------

-------------------------------------------------------------------------
--This code is for original Mooore controller
-------------------------------------------------------------------------
--		--now we will code our next-state logic
--		else
--			case floor_state is
--				--when our current state is floor1
--				when floor1 =>
--					--if up_down is set to "go up" and stop is set to 
--					--"don't stop" which floor do we want to go to?
--					if (up_down='1' and stop='0') then 
--						--floor2 right?? This makes sense!
--						floor_state <= floor2;
--					--otherwise we're going to stay at floor1
--					else
--						floor_state <= floor1;
--					end if;
--				--when our current state is floor2
--				when floor2 => 
--					--if up_down is set to "go up" and stop is set to 
--					--"don't stop" which floor do we want to go to?
--					if (up_down='1' and stop='0') then 
--						floor_state <= floor3; 			
--					--if up_down is set to "go down" and stop is set to 
--					--"don't stop" which floor do we want to go to?
--					elsif (up_down='0' and stop='0') then 
--						floor_state <= floor1;
--					--otherwise we're going to stay at floor2
--					else
--						floor_state <= floor2;
--					end if;
--				
----COMPLETE THE NEXT STATE LOGIC ASSIGNMENTS FOR FLOORS 3 AND 4
--				when floor3 =>
--					-- go up and don't stop
--					if (up_down='1' and stop='0') then 
--						floor_state <= floor4;
--						--go down and don't stop
--					elsif (up_down='0' and stop='0') then 
--						floor_state <= floor2;	
--					else
--					--stay
--						floor_state <= floor3;	
--					end if;
--				when floor4 =>
--					--can only go down
--					if (up_down='0' and stop='0') then 
--						floor_state <= floor3;
--					else 
--						--stay
--						floor_state <= floor4;	
--					end if;
--				--This line accounts for phantom states
--				when others =>
--					floor_state <= floor1;
--			end case;
--		end if;
--	end if;
--end process;
----------- end original Moore Controller ------------------------

-- Here you define your output logic. Finish the statements below
--takes care of the 1s place for the elevator
floor1s <= "0000" when ( floor_state = floor0 ) else
			"0001" when ( floor_state = floor1 ) else
			"0010" when ( floor_state = floor2 ) else
			"0011" when ( floor_state = floor3 ) else
			"0100" when ( floor_state = floor4 ) else
			"0101" when ( floor_state = floor5 ) else
			"0110" when ( floor_state = floor6 ) else
			"0111" when ( floor_state = floor7 ) else
			"0001" when ( floor_state = floor11 ) else
			"0011" when ( floor_state = floor13 ) else
			"0111" when ( floor_state = floor17 ) else
			"1001" when ( floor_state = floor19 ) else
			"0000";

-- this signal takes care of the ten's place for the elevator
floor10s <= "0001" when (floor_state = floor11) or (floor_state = floor13)
							or (floor_state = floor17) or (floor_state = floor19) else
				"0000";

end Behavioral;

