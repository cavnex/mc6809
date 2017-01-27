# A Supercharged 6809

My opinions only.  I expect some folks to disagree, which is certainly their right.

The topic is "How do you make a *better* 6809?"

## Don't go HD6309

The Hitachi HD6309 and HD6309E are neat CPUs.  Investigate them, read about them, and darnit, those Hitachi guys did a great job.  It's really a pity that something like the TRS-80 Color Computer 3 didn't ship with a HD63C09.  Compatibility would have been retained for software written for older units, but new instructions and registers would've made the CoCo 3 just downright better.  (Hitachi would've had to have admitted to having added the new features by the CoCo 3 launch.)

Extending a soft core - a core written with the intention of being accurate to the original - to include the 6309's features?  The point in doing this would be ... to gain compatibility with .. wait, what?  A handful of 6309-specific chunks of code?  

No, this is just one-upsmanship.  

If you seriously want to make a truly fast 6809, I have suggestions, but they may not be the pop-scene favorites:

## Start making architectural changes

### Break the CPU/Bus Cycle link

The 6809 has the notion that a bus cycle is equivilent to a CPU clock cycle. This made sense in the late 1970s.  By the mid 1980s, it wasn't making sense any longer.  Today, the notion is archaic. Permit the CPU to run at a specific clock speed, but to only stall when entirely dependent on a bus transaction.  All real-world software timing needs to be through external timing sources - cycle counting "just doesn't work" any longer.

### Add a cache

In fact, start with just an I cache.  A tiny bit of code would be needed to flush the I cache in specific situations (code loaded into RAM), but then things like loops that fit entirely within an I cache can run at the CPU's clock speed, not blocked by every byte of instruction required.  Add a D cache next.  Enjoy bursts of *very* fast throughput.  

### Permit bursty memory

SDRAM/DDR/DDR2/DDR3/etc. are a confusing thing.  They're actually quite perky in reads and writes of many values at once, but they're absolutely awful for a single read/write transaction.  There's a very good reason why lots of designs around legacy microprocessors are designed today to use SRAM - it's more expensive, but darnit, it can perform single accesses in a very concrete amount of time [which fits with late-70s/early-80s CPU design structure perfectly].  However, when it comes down to it, you can't beat SDRAM.  They're stunningly cheap, available, and when you're moving bursts of data at a time (ahem, like *cache lines*), they're very efficient.  

### Copy the late 1980s Intel Playbook

Want to keep going?  Expand the register set by depth, with compatibility maintained via existing opcodes.  Newer opcodes - identical in purpose, but not identical in form - service, say, the 32-bit version of X, Y, S, and U.  Say that LX, LY, LS, and LU refer to the full 32 bit register, while X, Y, S, and U refer to the 16-bit version only.  A similar plan for A, B, D - although my inclination is that A and B become 32-bits as well and D merely is the lower 8 bits of A concatenated with the lower 8 bits of B.  <shrug>  (I'm oversimplifying a bit; the 6809 depends on 16-bit offsets to handle wrap-around; that'd have to still work, but only within the 16-bit zone.)

Instructions might be 6, 8 bytes long on average.  However, the impact is fairly low; the massively increased throughput from the caching (FPGA block ram can run remarkably fast) trivializes the doubled and perhaps tripled instruction lengths.

Does it "feel" like a 6809 any longer?  Yeah, it does.  The instruction set for 32-bit-register instructions is very similar to the compatible 8/16-bit instruction set.  

Is it neat and tidy?  Gosh, no.  If you want that, toss compatibility and do a pipelined interlocked CPU.  

### The point

My apologies if this comes off in a negative light.  That really isn't my intent.  

My knee-jerk sense here is that the 6809 was (nearly) the last big combinatorial non-microcoded CPU for a good reason.  Some of us adore it, but there's a pragmatic limit to attempting to make a 'super' version of it; the supercharged "thing" quickly ceases to be a "6809" any more. 

[Finally, the guilty admission: I've considered doing everything above myself several times.  However, I have other strange notions in my head for projects these days, so I'm not likely to pursue these kinds of things.]
 

