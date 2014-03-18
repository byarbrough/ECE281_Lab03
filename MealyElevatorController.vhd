----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva & Yarbrough
-- 
-- Create Date:    10:33:47 07/07/2012 
-- Design Name: 
-- Module Name:    MealyElevatorController Silva - Behavioral 
-- Project Name: 		CE3
-- Target Devices: 	Simulation
-- Tool versions: 
-- Description: 	Mealy Elevator Control
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: C3C Sabin Park gave me the idea to include stop and up_down in the sensitivity list to make it a Mealy machine instead of Moore.
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

entity MealyElevatorController is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor : out  STD_LOGIC_VECTOR (3 downto 0);
			  nextfloor : out std_logic_vector (3 downto 0));
end MealyElevatorController;

architecture Behavioral of MealyElevatorController is

type floor_state_type is (floor1, floor2, floor3, floor4);

signal floor_state, nextfloor_state : floor_state_type;

begin

---------------------------------------------------------
-- Mealy machine next-state process, based on clk or inputs ----
---------------------------------------------------------
floor_state_machine: process(clk, stop, up_down)
begin
--only change on rising edge
	if rising_edge(clk) then
		--reset is active high and will return the elevator to floor1
		if reset='1' then
			floor_state <= floor1;
		--cases
		elsif stop='0' then --the elevator is moving
			case floor_state is
				--state
				when floor1 =>
					--moving up
					if up_down='1' then
						nextfloor_state <= floor2;
					--moving down
					else
						nextfloor_state <= floor1;
					end if;
				when floor2 =>
					if up_down='1' then
						nextfloor_state <= floor3;
					else
						nextfloor_state <= floor1;
					end if;
				when floor3 =>
					if up_down='1' then
						nextfloor_state <= floor4;
					else
						nextfloor_state <= floor2;
					end if;
				when floor4 =>
					if up_down='1' then
						nextfloor_state <= floor4;
					else
						nextfloor_state <= floor3;
					end if;
				when others =>
					nextfloor_state <= floor1;
			end case;
		--otherwise the elevator is stopped, do nothing
		end if;
		
		--set the current floor to the next floor
		floor_state <= nextfloor_state;
	end if;
end process;

-----------------------------------------------------------
--Code your Ouput Logic for your Mealy machine below
--Remember, now you have 2 outputs (floor and nextfloor)
-----------------------------------------------------------
floor <= "0001" when ( floor_state = floor1 ) else
			"0010" when ( floor_state = floor2 ) else
			"0011" when ( floor_state = floor3 ) else
			"0100" when ( floor_state = floor4 ) else
			"0001";
			
nextfloor <= "0001" when ( floor_state = floor1 and (up_down='0' or stop='1')) else
			"0010" when ( floor_state = floor1 and up_down='1' and stop='0') else
			"0011" when ( floor_state = floor2 and (up_down='1' and stop='0')) else--up
			"0001" when ( floor_state = floor2 and up_down='0' and stop='0' ) else--down
			"0010" when ( floor_state = floor2 and stop='1') else--stop
			"0100" when ( floor_state = floor3 and (up_down='1' and stop='0')) else
			"0010" when ( floor_state = floor3 and up_down='0' and stop='0' ) else
			"0011" when ( floor_state = floor3 and stop='1') else
			"0100" when ( floor_state = floor4 and (up_down='1' or stop='1')) else
			"0011" when ( floor_state = floor4 and up_down='0' and stop='0') else
			"0001";

end Behavioral;

