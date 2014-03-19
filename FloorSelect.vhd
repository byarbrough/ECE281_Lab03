----------------------------------------------------------------------------------
-- Company: 		USAFA DFEC 281
-- Engineer: 		Brian Yarbrough
-- 
-- Create Date:    14:10:24 03/17/2014 
-- Design Name: 
-- Module Name:    FloorSelect - Behavioral 
-- Project Name: 	Lab03
-- Target Devices: Nexys2
-- Tool versions: 
-- Description: This provides the Moore controller which sends an elevator to a specific floor
--				It is based off of the basic controller, but has an additional input which allows for awareness of where it is heading.
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

entity FloorSelect is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           toFloor : in  STD_LOGIC_VECTOR (3 downto 0);
           curFloor : in  STD_LOGIC_VECTOR (3 downto 0);
           onFloor : out  STD_LOGIC_VECTOR (3 downto 0));
end FloorSelect;

architecture Behavioral of FloorSelect is

type floor_state_type is 
	( floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7);
	
signal floor_state : floor_state_type;

begin
floor_state_machine: process(clk)
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	if rising_edge(clk) then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
		--changed to from floor1 to floor2 for prime number problem
			floor_state <= floor0;
		elsif (toFloor > curFloor) then--moving up towards floor
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
		elsif (toFloor < curFloor) then--moving down to floor
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
			end if; --the elevator is already on the correct floor
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
