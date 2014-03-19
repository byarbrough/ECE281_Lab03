ECE281_Lab03
============

Elevator Control Variations

###Schematic inside Nexys2_top_shell
![alt text](https://github.com/byarbrough/ECE281_Lab03/blob/master/Inside_top_shell.jpg?raw=true "Inner Schematic")
This schematic was done as part of the prelab. It was helpful in determining exactly what inputs should be wired to what ouputs and where I needed internal signals. By the time I achieve full functionality, this schematic had changed a bit.

###Part 1: Required Functionality

On one hand, this part was simple because I had a killer Moore machine from CE3. On the other hand, my Mealy machine was not yet a Mealy machine and I had no clue where to begin wiring stuff. Additionally, ISE in all of its benevolence refused to provide the proper instantiation template, so I had to get the syntax off of forums (once C3C Ruprecht asked me why I had peridos in my syntax). I have to say though that once I read through the shell a couple times, looked at my schematic, and relooked at my schematic, everything fell into place. The basic controller actually worked on the first bit file generation because I had spent so much tmie going over the soft code.

###Part 2: More Floors and Change Inputs
Strangely enough, I had less trouble with this than the required functionality. This is largely becuase once I had the setup going, the modifcations to the Moore machine were not overly complex. For the prime number floors, it was simply a matter of adding a bunch of extra states and defining their functions. The original Moore shell would have been fine for this, but I was too lazy to copy and paste that many if statemnts. Both of these clock triggerd processes begin the same, but then differ.

_CODE FROM THE SHELL_
if rising_edge(clk) then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous? Synchronous.
		if reset='1' then
			floor_state <= floor1;
		--now we will code our next-state logic
		else
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						--floor2 right?? This makes sense!
						floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						floor_state <= floor1;
					end if;

####As you can see, there is a lot of testing with multiple if statements. This would have been a lot of lines of code to do the prime numbers.

_MY CODE_
if rising_edge(clk) then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
		--changed to from floor1 to floor2 for prime number problem
			floor_state <= floor2;
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
			
####This code does the entirety of the moving up, and a similar chunk does moving down. That's it. Much simpler.

Both cases were sure to include a "when others" option: critical for handling phantom states. Although there isn't really a reason to get phantom states, when they do come up they hold memory if they aren't accounted for and can generally cause problems with the device.

The other major change I had to make was adding an output to this controller. Because it was suppsoed to display a two digit number to the SSEG I decided to output a ten's place digit as well as a one's place digit. This made it easy to use the SSEG because I could just wire another signal. For the 
