# Cycle Accurate MC6809 Core

## Details

This is a Verilog implementation of the Motorola MC6809 and MC6809E microprocessors from late 1970s.  It is intentionally implemented in a manner to make it as similar as possible to the original microprocessors.

When this was implemented, other 6809 cores already had been written.  These other cores were in use and had been verified.  Although I've never used any of these cores, I'm confident that they're excellent replications of the instruction set.  However, none (as far as I know) was verified to be cycle-accurate.  Encouragement from several sources (particularly one very generous source) convinced me to invest the time.

Beyond merely cycle-accurate, the goal was to attempt to preserve as much of the actual bus signals and protocols as possible.  Signals such as DMABREQ, TSC, MRDY, and LIC, while infrequently used were still implemented.  Bus traffic was identified with a Logic Analyzer and matched to the 6809's specs (and, truthfully, when the specs were vague, details captured from hard MC6809/MC6809E part behavior).  The particulars in the Motorola specifications were replicated.

The goal was cycle accuracy and that dictated much of the design. This was never intended to be a supercharged superset of a MC6809. If you're looking to mega-power your existing system, this might not be the best choice.  (Read the section on What This Is Not for explanation.)

## Purpose, License

I invested the time in the desire that *people use it*.  I haven't given away hardware designs or software since the 1980s.  However, this seems like a worthwhile exception.

While the source is completely available, this is *not* an "open-source *group* project".  You may modify it as you see fit.  If you find errors, notifying me would be appreciated.  Still, this is **not** a group project.  I don't intend that to come off as rude quite so much as frank.  I may choose to modify the core in the future; many "open-source group projects" seem to me to become interesting social studies in design-by-commitee, and how much time is required just to manage multiple people with multiple inclinations becomes significant.  I confess that this scenario is not something that appeals to me. [Outside of a day job, I prefer to work with a very small and fairly private group.]  If you're enthusiastic or appreciative, use the core in a design and I'll be thrilled - tell me about it, and I'll explain to you how thrilled I am.  

Refer to the [licensing](./documentation/LICENSE.md) requirements if you choose to leverage this work.

This isn't an attempt to deal with part scarcity.  Any variant of 6809 is still quite easy to obtain (at darned cheap prices, too).  In truth, *far cheaper* than an FPGA.

The actual target are people who are reimplementing retro-devices (Arcade games, Computers) that have incorporated entire designs into an FPGA, but require cycle accuracy.  The core's required space on an FPGA isn't overwhelming once you hit a certain range of parts and integration.  (If you're looking at CPLDs, you might want to scale up a bit.)

## Implementation

The core was implemented using Motorola's original documentation.  Particularly, **Figure 18** in the MC6809 and MC6809E datasheets.  There is a very close mapping between those five pages of diagrams and the bus and cycle activity of the CPU.  

I have noticed that some repositories of HDL tend to be only slightly more organized than *people tossing HDL files "over the wall"*.  Explanations of how they work, how you as a consumer of the HDL should deal with it, etc. tend to be lacking or totally non-existent.

I do have an interest (outside of this project) in HDL education; not quite in tutorials, but in implementations of HDMI, USB, SATA, etc. and explaining clearly how an implementation works - along with the hardware standard at the same time.  

Please - if you're not experienced in an HDL already, this cpu core isn't likely very useful to you as a learning mechanism.  There are wonderful tutorials out there already; I highly recommend learning, experimenting, and so forth *first*, before attempting to absorb this design.

## Validation

The design was validated in multiple fashions, including against a Vectrex from 1982, a TRS-80 Color Computer 3, A slew of Williams Arcade games, and another wave of Taito Arcade games.  

Literal bus compatibility was achieved using a [GODIL-40](http://www.oho-elektronik.de/) against the above scenarios. I can't say enough nice things about the [GODIL](http://www.oho-elektronik.de/) design.  Slick, compact.  It's darned nice work.  The only bad thing is that they're in short supply.  (Oh, and they're 10x-20x the price of a hard CPU.  I wouldn't recommend replacing your daily-use CPUs with a soft CPU in a GODIL unless you have a strong reason for doing so.)

Functional testing was against the list of platforms above.  They all work.  

Actual instruction cycle testing was done with the frequent help of Erik Gavriluk, who donated his time, consideration, and even hardware to the project.  In this case, MAME sports a cycle-accurate 6809 emulator; Erik generated code that ran (nearly) every instruction in every addressing mode, and then ran that through MAME and kept an absolute cycle count.  I captured the soft core's bus on a GODIL running the exact same code and matched the cycle counts.  To improve things, Erik provided me with the register contents after every instruction.  I wrote a testbench to run the same code and validated that the registers changed after each instruction identically in each scenario and in the exact same number of cycles. The result was gratifying.  (Ahem, once it worked.  Believe me, the CoCo, the cycle testing, the GODIL - they *all* pointed me at problems.  I won't claim that the design is flawless - nothing I've ever written truly is - but effort *has* been made to actually verify the thing, and I'll list each of the platforms and experiences.  [I'll even grumpily point out that Stargate has illegal instructions in it that they're darned lucky the 6809 happened to walk over.]

Precise control signal testing (Interrupts, /HALT) were primarily done on JROK's Williams board.  The Williams arcade games had a blitter, and it used /HALT to gain the bus and take action.  JROK had done some extensive timing validation to prove that his implementation of the Williams design was **accurate**.  I contacted him and being as he's an incredibly nice person, he gave me some advice and access to his source + prebuilt binaries.  I was quite thankful - I found bus timing errors (related to /HALT and related to /IRQ latency) in the same vein (how many cycles before the next-new-instruction does each have to be asserted in order to be serviced at the beginning of the next instruction?) as a result.  A very worthwhile endeavor, as I'd been convinced that I was correct; however, his code led me to swap hard CPUs with my soft core on analyzer captures and to realize that despite my intention to match the documentation perfectly there were cases where the documentation left details unclear, requiring comparison between a hard CPU and my existing timing.

## What This Is Not

This isn't an attempt to deal with parts scarcity, nor prepare for it.  I can't imagine that 6809s will become *hard to get* in the next decade or so.  There isn't a ton of volume required and there are lots of warehouses from companies that make their entire businesses on out-of-production parts.

This isn't an attempt to make a faster MC6809. The implementation would have been different had that been a goal. It has extensive 'dead' cycles on the bus to fit MC6809 specifications. If I conditionally remove them, it would be significantly more efficient than a real MC6809 (but once again, not cycle-accurate).

This core does not include HD6309 instructions. I did check, and without the 'dead' cycles mentioned above (the things that make it cycle-accurate), every instruction is at least as efficient as the HD6309, and most are more efficient.  (I do have advantages of 40 years of technology over the original MC6809 design team, and at least 30 years over the HD6309 design team.)  New registers and instructions from the HD6309 aren't there.  Once again, that wasn't the goal.  [I may still enable a dynamic mechanism to switch between cycle-accurate and minimum-cycles-required as an instantiation parameter.]

If your goal really is "a super 6809", I have [strong opinions](./documentation/super6809.md) on the topic.  

## Perfection?

While I'd love to say that this is a perfect replica, logic-level details of the implementation of the CPU aren't available.  The Motorola documentation is *excellent*, but still not complete.  

I know of inconsistencies - but inconsistencies that I expect are trivial.  Anything deemed as serious has been dealt with as soon as I've been made aware of it.

The instructions have been heavily validated, and I'm confident in their accuracy - but not quite so arrogant as to insist that there could not be an oversight.  (I'm not a young man any longer; I've been wrong too many times to be as remotely as confident as I was when I was 16.)

Should issues be discovered, expect transparency and fixes - even if it's an incredibly rare edge case.  [If you're actively using `/DMABREQ`, please contact me.  You're the first.]

## How does it work?

This isn't quite the same question as the next, but if you really want to dig in and grasp the implementation, I've written a summary of the design [here](./documentation/CoreDesign.md).

## How Do I Use It?

### Samples

Application of the core in a GODIL is provided.  With this, you can - although for what reason, I'm not sure - plug-replace a MC6809 or MC6809E in nearly any design (*note the oscillator in the Vectrex instead of the crystal*).  This is intended to demonstrate compatibility.

A sample implementation is provided against a cheap Xilinx Spartan 6 LX9 board from eBay (China), a cheap Altera Cyclone IV EP4CE6 board (also from eBay, China), and two Cyclone V boards from terasic.  These aren't attempting to run at original speeds, so I set them to 25Mhz for no reason other than "I can".  These are intended to demonstrate use of the core entirely internal to an FPGA.

### General Guidelines

A list of general guidelines is provided.  They are likely worth reading if you consider using this core.

## Documentation

1. [Explanation of the CPU Core design.](./documentation/CoreDesign.md)
2. [Validation Efforts.](./documentation/Validation.md)
3. [Implementation Examples](./documentation/samples.md).

## Who Am I?

Despite a certain degree of desire to remain anonymous, that seems pointless in today's world. 

My name is Greg Miller; I learned assembly in 1981 on a 6809 in a TRS-80 Color Computer, leaving me *fond* of this CPU architecture.  

Not surprisingly, I work in the tech industry (although quite definitely not implementing legacy hardware in FPGAs), do not represent my employer in any capacity whatsoever here, and have a family and a mortgage.  

You can contact me via:

    gregmiller6809@gmail.com


## Final Thoughts

I'll keep track of my [Final Thoughts](./documentation/FinalThoughts.md) on the project.

## Acknowledgements

[I do want to thank a few people](documentation/Acknowledgements.md).

