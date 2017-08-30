# Acknowledgements

I'd like to voice my appreciation to a few groups or individuals:

*Erik Gavriluk*, who deftly convinced me to do the work, provided the CoCo 3 and both JROK boards.  Erik spent untold hours sifting through code when I had an implementation bug attempting to get me detailed per-instruction dumps of execution of code on known-good platforms.  He helped put together code that was used for testbenches and provided the 'known good' copies of the execution.  He also offered feedback when I was just too close to a problem to recognize the obvious.

*The MAME contributors*, who have spent so much time emulating old hardware.  For the most part, schematics are available for old hardware.  However, the perspectives of so many other people are so helpful when attempting to determine pragmatically how a four-page schematic distills into functionality, or that a specific undefined instruction maps to which specific instruction on the original hardware.

*JROK*, for making multiple cool boards and clearly investing a ton of time into them.  My test hardware would've been far smaller without his efforts.  The fact that he's a nice guy and quickly offered advice and help when I introduced myself speaks for his character.

*Roger Taylor*, for sifting through irritating `CWAI`, `SYNC`, the-second-NMI-doesn't-work, and maddening `/HALT` issues, patiently waiting for me to figure out what the heck I'd done wrong each time.  Roger has to be one of the most patient and humble people out there, and I'd still have several items not-quite-right if not for his time and help.

##Addenda:

Many thanks to Greg Sander and Jose Tejada for pointing out that I had a bug in the DAA instruction.

When Greg suggested there might be a bug, I wasn't very convinced until he suggested that it might be in DAA.  I'd never bothered to use DAA, and instantly believed that it could be broken.  

Greg didn't know 6809; he didn't know Verilog (knew VHDL), but was fiddling with it and narrowing in on proving that it was DAA so fast my head spun.

When I finally got around to fixing it, I had gone through multiple conflicting references (how many people know that carry out on DAA is basically an OR of the original contents of the carry bit and the carry-out of the DAA addition?) and deleted several lines where I was too clever for my own good.

Greg and Jose have both given me a thumbs up on it working correctly for them, so my sincere appreciation goes out to both for investing time in it.  Thanks!







