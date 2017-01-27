# Final Thoughts

I'll invest the time to track down bugs; ping me.  

If you're trying to apply it and having trouble, feel free to ping me there as well.  The odds are good that I can help.

I am interested in making some changes when I get a bit of time:

 - I'd like to add a parameter to the core that permits you to instantiate the module such that the 'unnecessary delays' that provide for the cycle-accuracy can be disabled.  Considering that my interest has been cycle-accuracy, I haven't done that - but I've been aware from the beginning that it would be useful.

 - I'd like to sort out the Test Bench that I was using and start including it.  I used ISim and ModelSim (mostly the latter).  I'd have to do some cleaning up, but it would be worthwhile.

 - I'd like to go through and clean up the warnings.  The fascinating thing is that Quartus, ISE, and Vivado all give some warnings that the others do not.  Something that synthesizes clean in one may well get complaints from one of the other two (yes, the latter pair are both from Xilinx, but are definitely different).  Heck, I've gotten warnings on a Cyclone V in Quartus that didn't appear for a Cyclone IV.  I'd be tickled to have it synthesize on all of the above and every warning that is removable be entirely gone.

 - I wouldn't mind adding another sample that does SRAM out of the FPGA, but the rest of the FPGA is internal.  The other Cyclone V board that I pointed out seems like a good candidate.

That said, I'm likely to take a break (aside from bugs).  I do work for a living, and this kind of project occupies a very tiny window in my evenings after my children go to bed and before I do.  I do have some other interests (similar interests, but different topics), and I'm eager to put the tiny portion of time I can spare into them.

Best wishes!

Greg



