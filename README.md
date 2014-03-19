ECE281_Lab03
============

Elevator Control Variations

###Schematic inside Nexys2_top_shell
![alt text](https://github.com/byarbrough/ECE281_Lab03/blob/master/Inside_top_shell.jpg?raw=true "Inner Schematic")
This schematic was done as part of the prelab. It was helpful in determining exactly what inputs should be wired to what ouputs and where I needed internal signals. By the time I achieve full functionality, this schematic had changed a bit.

###Part 1: Required Functionality

On one hand, this part was simple because I had a killer Moore machine from CE3. On the other hand, my Mealy machine was not yet a Mealy machine and I had no clue where to begin wiring stuff. Additionally, ISE in all of its benevolence refused to provide the proper instantiation template, so I had to get the syntax off of forums (once C3C Ruprecht asked me why I had peridos in my syntax). I have to say though that once I read through the shell a couple times, looked at my schematic, and relooked at my schematic, everything fell into place. The basic controller actually worked on the first bit file generation because I had spent so much tmie going over the soft code.

###Part 2: More Floors and Change Inputs
Strangely enough, I had less trouble with this than the required functionality. This is largely becuase once I had the setup going, the modifcations to the Moore machine were not overly complex. For the prime number floors, it was simply a matter of adding a bunch of extra states and defining their functions. The original Moore shell would have been fine for this, but I was too lazy to copy and paste that many if statemnts.
