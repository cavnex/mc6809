# The 6809 Core Design

## Background

The 6809 is very similar in many aspects to other CPUs of its era - the 8080, the Z-80, the 6502, the 6800, and even lesser known outliers from other companies.  Unlike nearly every CPU after it, the 6809 *is not microcoded*.  The 6809 is a very big mass of combinatorial logic with some latches on the conceptual edges.

Please read the page of short overview of the 6809's bus cycle [here](./6809Details.md); even if you're aware of these details, it's worthwhile to note them again.

The important part to take from that discussion is that 'the cycle runs from the falling edge of E to the next falling edge of E', and 'signals are held for an indeterminate time', 'several signals are in flux for a certain period', and finally 'read data is latched at the falling edge of E, which is the transition into the next cycle'.

## Limitations


### Vanilla
I intentionally wanted to avoid adding either Xilinx or Altera specific code to the actual core.  It would've made some things easier, and other parts *better*.  It also would've forced me to either tie it to one manufacturer, the other, or to maintain two copies.  Ouch.

For better or worse, the core and the different-variant (MC6809, MC6809E) wrappers around the core are Vanilla Verilog.

### Clocks
FPGAs are fairly poor at acting on both the rising and the falling edges of a clock.  There are plenty of pragmatic solutions.  If you aren't time-dependent, create a copy of the signal, suffer the propagation delay, and trigger off of the other edge.  If you *are* time-dependent, people will suggest everything from using a PLL to double the clock and therefore hit both edges that way (odd instances vs. even instances of the doubled clock), or use a DCM/PLL to create a synchronized copy of the clock and trigger off of it.  

The core itself *doesn't* do that, because "not vanilla verilog".

### Tristate

Tristated signals really have no meaning inside an FPGA (okay, some older FPGAs - I know some older Xilinx parts did, for instance, support this concept to a limited extent).  Things like the CPU's data bus have a data-in and a data-out path to/from the CPU at the inner core. 

Implementations where they're wired to the physical world end up dealing with multiplexing tristated situations onto actual pins/pads.  [See [The GODIL Implementations](godil.md).]

Additionally, even though the external chip itself can have a tristated Address bus, tristated R/W signal, etc. - the inner core doesn't.  Again, tristate inside an FPGA doesn't make sense.  Once more, that's something that needs to be done on the actual application to signals outside an FPGA. [Again, see The GODIL Implementations.]

Please note that this is the reason that the 6809E hard signal TSC isn't addressed.  It basically needs to be addressed at the outer-most layer.  It's applied in the GODIL implementation for the MC6809E, and that example can be viewed.  

### Driving a crystal

The MC6809 wrapper cannot drive a crystal.  Basically, general I/O isn't intended for the analog aspects of driving a crystal. I might have been able to hack something together that would "work" for driving a crystal, but that seems like a very bad idea.  If you plan on using an external implementation of an MC6809 (rather than MC6809E), nix the crystal and just use an oscillator.  [See The Vectrex Implementation.]

### Special signals

The 6809 in general has some 'special' aspects.  /RESET actually has a higher VIH trigger than most inputs on a real componet, and that's intentional by the designers to ensure that the CPU comes out of reset *last*.  That's great, but ... there isn't a practical way for me to implement this on an FPGA without extra circuitry.  [My memory says that instead of the 2V TTL VIH threshold, the 6809 uses something like 4V for RESET.]

The E clock is driven *differently* than other signals.  I never read a very solid explanation of this, other than a sentence or two buried in the Motorola documentation citing something like "as it directly drives internal NMOS circuitry".  As a result, I saw truly wretched overshoot and undershoot on a GODIL, forcing me to filter the darned clock.  [See The GODIL Implementations.]

## Source Micro-Hierarchy

The CPU Core itself is in a file called 'mc6809i.v'; it's meant to be 'internal' and is the superset of all signals 6809 and 6809E, as well as anything I wanted to optionally export (such as the contents of the registers).

There are also fairly tiny files called 'mc6809.v' and 'mc6809e.v', which both instantiate the core from 6809i.v but have slightly different input/output characteristics.  [For instance, mc6809.v expects to get a clock and generates E and Q as well as provides MRDY stalling of E and Q and passes signals that are only on a 6809, such as /DMABREQ.  The 6809E expects to receive E and Q preformed, but also passes through things like AVMA, LIC, and BUSY - which aren't on a 6809.]

The file mc6809s.v is merely a convenient superset of 6809 and 6809E functions that I found convenient.  It receives a clock and generates E and Q, has MRDY as a result, but also exports LIC, AVMA, BUSY, etc.  I've done some work with this on SDRAM based systems where I've used MRDY to stall the 6809 when, say, DDR-2 latency wouldn't be ready in time.  [Obviously, I didn't care about cycle accuracy there - I was also clocking it signifcantly faster than a real 6809.]

I generally won't comment on these three (mc6809.v, mc6809e.v, mc6809s.v) files in explanation other than stating that they're primarily input/output pass-throughs.

The exception that I can think of is the generation of E and Q:

E and Q are generated in logic in mc6809.v and mc6809s.v.  Logic-based clocks aren't the best thing in an FPGA.  However, the alternative was invoking FPGA-specific items; directly assigning a BUFG in Xilinx, or using a PLL on Altera or Xilinx to generate the clocks (although I can't stretch the clocks at that point ...)  I could easily understand someone wanting a very efficient implementation, and not caring about MRDY merely using a PLL to generate E and Q from a master clock.  It merely is counter-productive for me to offer that when I'm trying to be as 'vanilla' as possible.

## Tenets

In short, work is done in as few cycles as possible, even if that leaves a number of completely empty cycles where nothing is done whatsoever.

As an example, we'll use the EXG instruction on 'Sheet 3 of 5' in Figure 18 of the 6809 datasheet.  The leading opcode has been read before the EXG path has been hit in this diagram, so one cycle has already been utilized (the 6809 *always* reads two bytes for an instruction, even on one-byte instructions.  That's why there are no one-cycle instructions.  Some instructions end up getting read twice as a result) before the 7 flowchart boxes are encountered here.  The first box - labelled Post Byte - is the parameter of EXG that lists which registers to exchange.  The top nybble and the bottom nybble form a register index that explains whether, say, X and Y are to be swapped, or A and DP, etc.  The actual implementation in **this** core is done in the very first box in this flow.  By the end of that cycle, the exchange is complete.  It's then followed in the implementation by *six* empty cycles that literally do *nothing*.  Each of those six have state names - quite literally CPUSTATE\_EXG\_DONTCARE1 through CPUSTATE\_EXG\_DONTCARE6.  The last one passes control back to fetch the next instruction.  The point is that *in most cases, the work is done as quickly as possible* followed by filler cycles.  There's an inherent trade-off.  I likely could have created a core that would scale to a higher clockrate better if I'd layered the work over all available clock cycles for an instruction.  Instead of it synthesizing to a max of 60Mhz on a Kintex part I have, it might synthesize even higher then.  However, when the goal is cycle-accuracy, it was easier to maintain with merely doing the work "as quickly as possible".  [The alternative is that if I were to conditionally remove the "dead/dontcare/stall" cycles, EXG would run in 2 cycles, rather than 8.]

Summarized, each action is done in as few cycles as was deemed possible.  Read/Modify/Write is actually typically done in 2 "productive" cycles (and to preserve cycle accuracy, empty cycles .  The Read and the Modify are done on the same cycle, then the Write on a later cycle (it might not the immediate cycle following; there may be a dead cycle of padding to ensure the bus traffic pattern matches the 6809).  Again, there's a penalty for this intentional compression - if you clock the core significantly higher, it limits the ability of the read data on the bus to arrive "just" before the end of the cycle.  If you're running at 5Mhz and under, it isn't a concern.  Even at 25Mhz in the demos I've included, it isn't a concern.  However, it would be a sensible limitation at *some* clock rate (although I haven't tried to calculate what that value would be).

## Module

A Verilog Parameter is defined for one particular topic: How to deal with invalid instructions.

The 6809 does not sport a fully decoded instruciton set.  The team cited in a wonderful old Byte article that this was to save real-estate on the die.  As a result, a set of undefined instrucitons actually *do* perform actions when run.  For example, a `NEG <$XX` instruction is literally $00 $XX.  However, $01 is an undefined instruction.  On a hard 6809, the bytes $01 $FF will perform a `NEG <$XX`.  Quite simply, bit 0 of the instruction isn't decoded, and $01 aliases to $00.  

From an idealistic perspective, I didn't want to support this behavior initially.  By every Motorola manual, these are *illegal*.  However - a hard 6809 *does* support them, and as my motivation is performance accuracy, it would seem absurd not to ensure identical behavior there as well. 

Ironically, this actually was an issue with the Williams Arcade Game 'Stargate'.  I had difficulty with running it, and was convinced that I'd screwed up - despite the fact that things like Defender, Robotron, and Sinistar ran fine.  I chatted with Erik Gavriluk, and then ended up hooking it to an analyzer.  I had the soft core rigged to 'STOP' processing instructions when an illegal instruction was met.  By 'STOP', I mean that it puts $DEAD on the address bus, asserts R/W high (a read), and just-plain-stops.  It would require a reset to get it out of that state.  This was extremely valuable to me in catching failures, as once something went wrong, the code tended to go awry.  Once that happened, it would frequently try to process garage as instructions, and then stop.  A logic analyzer would catch the '$DEAD' on the address bus, trigger, and I'd walk the bus traffic back until I found where things appeared to go off-track.  In this case, I found it going awry very early in the run of Stargate.  A subroutine low in memory was called, and a branch there would end up branching into the middle of the 2nd instruction following.  It would hit an illegal instruction and my soft CPU would just stop.  I couldn't believe that this wasn't *my* fault.  Erik, however, walked the code through MAME and determined that yep - Stargate does indeed do exactly that on MAME. When I made a bit of code to look for illegal instructions and *skip* them, Stargate ran.  Later, I added code to emulate the incomplete-decoding-behavior.  For those interested, Erik created a [patch](patch.md) for Stargate that fixes the mixed-up code.

The Verilog parameter `ILLEGAL_INSTRUCTIONS` for the internal core permits you to declare what behavior you want.  The default behavior is to emulate the incomplete-decoding of the hard 6809.

If you override the parameter in instantiation, you can obtain any of three behaviors:

    `STOP` - causes the Soft Core to place $DEAD on the address bus and *stop*.  I considered adding a new vector for illegal instructions, but that seemed a slippery slope.  
    `GHOST` - the default setting - causes the Soft Core to emulate the incomplete decoding of the hard core.
    `IGNORE` - This is similar to GHOST but actually causes illegal instructions to be ignored, and the PC to increment to the next byte.  

Unless you have particular need for a specific mode, I suggest leaving the default in place.



## Basic Structure

Refer to Figure 18 in the MC6809 or MC6809E data sheets.

There is a very close parallel between these diagrams (particularly the timing and bus traffic patterns and contents) and the implementation.  

The general style of the implementation actually isn't what I've used for a very long time.  Some folks would call it "old style Verilog".  It's really a big combinatorial state machine.  There are registered values, and for each there's a "\_nxt" version of it.  (For instance, the current 'state' in the state machine is 'CpuState'; to change it, you set 'CpuState\_nxt'.  On the next falling-edge-of-E, CpuState latches CpuState\_nxt, and the change takes effect.)  I originally considered using a more "modern" style, but quickly realized that I wouldn't come up with something close to accurate that way.  I'd get a CPU that worked, but the cycle-accuracy would be significantly harder.  Thus, the design with a lot of combinatorial logic actually is *similar* to how the real CPU was designed, even if it doesn't match much HDL I've written in recent times.

The CPU core itself resides intentionally in one file.  I detest reading other people's designs and trying to sort out dependencies when they've basically thrown a few VHDL or Verilog files over the wall.  Despite the reality that I've ended up with a single file of about 4000 lines, if you see something referenced, it's defined somewhere above your current cursor position in the file.

The design breaks down into three groupings:

1. A single `always @(*)` statement that makes up the CPU's state machine.
2. A number of Verilog functions tied into combinatorial logic.
3. Latching; the CPU State (from one cycle to the next) on the falling edge of E; IRQ and FIRQ on the falling edge of Q; the notation that NMI has been asserted occurred on its own falling edge.

### The State Machine

There's one `always @(*)` statement that represents the state machine for the CPU.

The `always` and the `case` section following it are the functionality for the CPU.  Every cycle of every instruction is related, directly or indirectly, to a `CPUSTATE_` listed in the state machine.

As mentioned earlier, the vast majority of these tie into Figure 18 in the MC6809's datasheet. There isn't a perfect 1:1 relationship, but it's significant enough that I could number the boxes in Figure 18 and then create a cross-reference chart that lists which `CPUSTATE_` that box refers to.

Before I mention the general form, I should comment on the form; recognize that it's a design that is .. well, combinatorial and something that is inherently unsettled the inputs to the chip settle (the data bus, generally).  As the data on the bus changes and settles, the results from each state *change*.  The `always @(*)` statement means, basically, "At all times shall this be true"; the logic is free-flowing.  The results out of each state will settle before the cycle end, when all `\_nxt` values are copied into their latched versions.  

/RESET is sampled on the `always @(negedge E)` statement.  If it's seen as active (low), the `CpuState` is set to `CPUSTATE_RESET`, the NMI Mask (rarely known, the 6809 ignores NMI until the S register has been initialized) set, and the indicator that we currently have an NMI pending is cleared.

The State Machine central location is called `CPUSTATE_FETCHI1`.  This is where the first byte of any instruction is read (or attempted to be read; there's a `CPUSTATE_FETCHI1V2` which differs primarily by having already read a first-byte of `$10` or `$11`, indicating a Page2 or Page 3 instruction).  The 6809 always reads *two* bytes for each instruction (even on single-byte instructions), so if a first byte was read and latched (i.e., interrupts are vectored between instructions, so `CPUSTATE_FETCHI1` is also the place where the states to NMI, IRQ, and FIRQ are moved to), the next state is always `CPUSTATE_FETCHI2`.  Instruction decoding starts here.

The different `function` routines in the code are covered in another section.  However, some are used for instruction decoding.  The first-level decode happens on instruction addressing mode.  INDEXED, EXTENDED, DIRECT, INHERENT, IMMEDIATE, and RELATIVE are handled here, and you can track an individual instruction through the statements.  I suggest examining Table 9 in the 6809 datasheet; the instructions are clearly laid out by addressing mode.

The hand-off to individual state machine paths begins in these decoding sections.  A handful of instructions are acted upon in this - the second cycle - and finish, returning to `CPUSTATE_FETCHI1` on the next cycle.  Most transition out.

An example might be useful:

For INDEXED, EXTENDED, and DIRECT instructions, the goal really is generating an Effective Address (EA).  The actual instructions and actions are basically identical aside from the addressing mode.  An `ADDA ,X`, an `ADDA $F002`, and an `ADDA <$79` all have the goal of determining the Effective Address first.  Once determined, the same path is used to process them.  

To demonstrate this using Figure 18 in the 6809 datasheet, look at Sheet 4 to see the page for 'INDEXED'.  The example has `,X` as the index, a 0 offset from a register base.  That's the left-most column.  Note the NNNN+2(3) on the address bus (which basically means 'the 3rd or 4th [if it was a Page 2 or 3 instruction]' instruction byte), and **DON'T CARE** on the data bus.  It reads the next byte incremented off of the program counter, but does nothing with the data.  It isn't an INDIRECT reference (where you calculate the Effective Address and then read the 16 bits it points to and use that as the new Effective Address), so the Effective Address in this case becomes the contents of register X.  At the bottom of the page, it passes to block 'D' in the diagram.

Continuing with this example, Sheet 3 of Figure 18 contains the EXTENDED addressing mode (rightmost column, 3 boxes vertically).  Immediately following the first (or second if this was a Page 2/Page 3 instruction) are the MSB and LSB of the Effective Address.  They're read in sequence.  Finally, a dead cycle is on the bus (technically a 'Non-Valid Memory Access'), where the real 6809 is likely marshalling the Effective Address.  After reading the EA and the dead cycle, it passes to block 'C' in the diagram.

[Block 'C' is actually on Sheet 4 of Figure 18.  It literally goes directly to Block 'D', so they are in practice the same place.]

The DIRECT addressing mode is just to the left of EXTENDED on Sheet 3.  It reads only 1 more instruction byte, the LSB (the DP register being the MSB) of the EA.  It has a dead cycle, and then passes to block 'C' in the diagram.  (As I pointed out, which goes directly to Block 'D', no cycle involved.)

The point is that all three paths have worked to come up with the effective address, and then passed to the same place to make use of it.  Block 'D' is Sheet 5 of Figure 18.  Entering Block 'D', the Effective Address has been established, and the instructions that act on an Effective Address are entirely listed.  In our example, 'ADDA' is in the third column.  One cycle - a read - is done from the Effective Address, an ALU operation is performed, and the instruction completes.

*Note: Figure 18 explains the bus traffic and cycle timing.  It doesn't explain the 'how'.  There's no information here that says 'Do an ALU operation'.  That's inferred information, but not hidden.  It merely isn't the point of this diagram.*

The CpuState values for determining the Effective Address for Indexed, Extended, and Direct are different.  Start reading at `CPUSTATE_INDEXED\_BASE` for Indexed, `CPUSTATE_EXTENDED\_ADDRLO` for Extended, and Direct is so short it's mostly in `CPUSTATE_FETCHI2`, under a case statement that looks for `TYPE\_DIRECT:`, then redirects to `CPUSTATE_DIRECT\_DONTCARE` to generate the dead cycle.

In the same way that Figure 18 shows a central clearinghouse for actions on an Effective Address, there's a single state for doing ALU operations (I named this generously; it's really 'nearly anything on Sheet 5' - mostly ALU operations, but I've stuffed LD into ALU operations, and in this case, even ST is in that state) called `CPUSTATE_ALU\_EA`.  [The exception to Figure 18/Sheet 5 is `JMP`; it requires 0 cycles on sheet 5, so I cannot be cycle accurate and have it pass through `CPUSTATE_ALU\_EA`.]

Explaining every instruction or every state is impractical.  I am, however, attempting to demonstrate how one can trace the path of an individual instruciton through using the information I've provided and referring to the 6809 documentation as a reference.  The implementation here is *likely* (although not always) very similar.

*Worth noting here is that some copies of the 6809 or 6809E documentation have several Page 2 and Page 3 instructions redacted on Sheet 5.  I don't recall ever determining why they were redacted.  If your copy is redacted, the fifth column says 'LDD, LDS, LDU, LDX, LDY'; the sixth column says 'STD, STS, STU, STX, STY (All Except Immediate)', and the ninth column says 'ADDD, CMPD, CMPS, CMPU, CMPX, CMPY, SUBD'.  I'm sure someone had a good reason to hide the Page 2 instructions, but I don't know why.  If you know, please educate me.  From the perspective of timing, they are in exactly the correct places.*

**DONTCARE**

There are multiple names used by the 6809 documentation and myself in referring to a specific thing - a cycle in which there is no bus activity.  The 6809 places `$FFFF` on the address bus in that case, and leaves R/W set to a '1, indicating a Read.  (As a result, the data bus frequently receives the LSB of the RESET vector.)

The 6809 documentation refers to them as 'internal' cycles and /VMA (NOT Valid-Memory-Access) cycles.  In the code comments and here, I'll refer to them as 'dead' cycles and particularly in the Verilog code, as DONTCARE cycles (as Figure 18 refers to the contents of the data bus on these as *Don't Care*).

These are filler cycles to maintain cycle accuracy (I believe there's perhaps one exception where I actually do something useful on one).

Not every box in Figure 18 that says *Don't Care* means one of these cycles.  Many of the successive reads-ahead from the program counter are discarded, and they're listed as *Don't Care* as well.  The difference is that they don't have $FFFF on the address bus.  That said, these are superfluous cycles as well - but cycles where the Address Bus is listed as having specific contents, even if the data isn't used.  I *do* duplicate that behavior.

For both cases, you'll see a long list of very short `CPUSTATE_` values that basically do ... *nothing*.  It adds a fair number of lines to the file and is relatively monotonous, but you can track each of them back to Figure 18.


### The Functions

Verilog has a notion of a function.  A function may have a single output (whatever width you like, but only one), and can have any number of inputs as arguments.  The point of a function is similar in source-level concept to a software function; to have critical reused code in one place, and to simplify the design by breaking it out of a bigger block of code where it, bluntly, might be more confusing.

A contrived example of a function is below (it does nothing more than form an 8-bit value from the bottom 5 bits of the first argument + the 3 bits of the second argument and return the result):

    function [7:0] DoSomething(input [7:0] arg1, input [2:0] arg2);
    begin
        DoSomething = {arg1[4:0], arg2};
    end
    endfunction

Since the design is combinatorial, I've (nearly exclusively, if not exclusively) used functions in this manner (contrived):


    function [7:0] DoSomething(input [7:0] arg1, input [2:0] arg2);
    begin
        DoSomething = {arg1[4:0], arg2};
    end
    endfunction
    wire [7:0] Something = DoSomething(Inst1, Inst2[2:0]);

The point is that this is synthesized combinatorial logic.  Irrespective of the point in time or whether Inst1 and Inst2 are valid, it is *always* taking the bottom 5 bits of Inst1, tacking on the bottom 3 bits of Inst2, and the wire `Something` will always contain that data.  As Inst1 and Inst2 change, the result will change.

The confusing nature of this might not be immediately apparent.  A real example is that I use a function for the determination of whether a branch should be taken or not.  

The function looks like:

    function take_branch(input   [7:0] Inst1, input   [7:0] cc);

The wire invocation looks like:

    wire    TakeBranch =  take_branch(Inst1, cc);

`TakeBranch` is literally '1' or '0' based on whether the branch should or should not (respectively) be taken.

Consider for the moment - how does this work if Inst1 isn't a branch instruction?  What if we're doing, say, a `LDX $FF00` at the moment?  What is TakeBranch then?  

The answer is "meaningless".  It's always calculating, it's examining the lower nybble of the first instruction byte to determine the branch type, and examining the latched version of the CC register to determine if the CC flags indicate that a branch should or should not be taken.

This isn't a problem purely because the value coming out of this logic is only examined and used *if* we're processing a branch.  The code processing `LDX` never looks at the output of this logic.

This particular style is used for a variety of topics:

 - Is the current instruction illegal?
 - What's the Indexed Addressing Mode for the current instruction?
 - Is the current instruction a `JMP` instruction?  (Any form)
 - Is the current instruction an 8-bit store?  If so, from register A or B?
 - Is the current instruction a 16-bit store?  If so, from register X, Y, S, U, or D?
 - Is the current instruction a 'special' immediate-mode instruction (specifically, PSH, PUL, EXG, TFR, ANDCC, ORCC)?
 - Is the current instruction a one-byte instruction?  (Example, NOP, SEX, ABX, RTS, etc.)
 - What's the target register for a 16-bit ALU operation?  (X, Y, U, S, D)
 - What's the action for the current 16-bit ALU instruction?  (SUB, ADD, LD, CMP, LEA)
 - The 16 bit ALU itself.  Inputs ALU16\_OP (what action to take), ALU16\_A (input 1), ALU16\_B (input 2, if needed), ALU16\_CC (condition codes before the operation).  Returns the 16-bit result and the 8-bits of modified condition codes.
 - What's what action for the current 8-bit ALU instruction? (NEG, COM, LSR, ROR, ASR, ASL/LSL, ROL, DEC, INC, TST, CLR, SUB, CMP, SBC, AND, BIT, LD, EOR, ADC, OR, ADD), *and* does this operation cause a writeback?  (Example, TST, BIT, CMP do not do writebacks into the target register.)
 - The 8 bit ALU itself.  Inputs ALU\_OP, ALU\_A, ALU\_B (if needed), ALU\_CC.  Outputs modified CC, plus 8-bit result.
 - What's the addressing mode of the current instruction?  (INHERENT, IMMEDIATE, DIRECT, RELATIVE, INDEXED, EXTENDED)
 - Is this 8-bit ALU operation Set '0' or Set '1'?  (Set '0' relates to a set of actions that can be taken on an accumulator or directly against an effective address; set '1' require an accumulator, but cannot be used without one.  Set '0' is NEG, COM, LSR, ROR, ASR, ASL/LSL, ROL, DEC, INC, TST, CLR; Set '1' is SUB, CMP, SBC, AND, BIT, LD, EOR, ADC, OR, ADD).
 - Is the current instruction performing an 8-bit ALU operation?
 - Is the target register of the 8-bit instruction 'A' or 'B'?
 - Should the outstanding branch be taken?
 - What data should be used for an EXG or a TFR?  There's either two registers who have contents to swap, or a source register with contents and a destination register to copy the contents into.  The top and bottom nybbles of the 2nd instruction byte indicate which.  What's the correct data (register contents) for each?

### ALU

The 8-bit ALU is more complicated than the 16-bit ALU.  I'll attempt to discuss both, but the latter is primarily used for ADD/SUB on D, index-relative address offsets, and CMP on the 16 bit registers. 

Some ALU operations are incredibly straightforward.  Others, such as 'SBC' require some thought.  I spent a fair amount of time scribbling out solutions to sample problems on paper with a pencil.

Making things increasingly complex is that the CC bits on the 6809 aren't entirely consistent.  Z and N generally are treated the same way for every instruction.  N is basically a copy of the most significant bit of the result.  Z is set if the result is 0, and cleared otherwise.  Straightforward.  

C is a touch more complicated, but a declared adder in Verilog (or subtractor) will provide the bit if you merely declare a 1-bit larger action.  Example:

Example: result = a + b:

    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] result;
    reg carry;
    
    {carry, result} = {1'b0, a} + {1'b0, b};

Example: result = a - b:

    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] result;
    reg carry;
        
    {carry, result} = {1'b0, a} - {1'b0, b};


V was the bit that left me a bit frustrated; the 6809 manuals described its purpose, but not the rules by which it was calculated.

Fortunately, these types of flags are calculated identically for basically every CPU.

The clearest definition for Overflow (in addition) is that it is set in two situations, but cleared otherwise:

 - When the sum of two numbers with the sign bit cleared contains a sign bit that happens to be *set*, V is set.
 ... also ...
 - When the sum of two numbers with the sign bit set contains a sign bit that happens to be *cleared*, V is set.

    Consider RESULT=A+B

    A7    B7    R7
    0     0     0
    0     0     1  <-- This one
    0     1     0
    0     1     1
    1     0     0
    1     0     1
    1     1     0  <-- This one
    1     1     1


Subtraction varies that slightly - as subtraction is basically addition negated second argument:

    Consider RESULT=A+B

    A7    B7    R7
    0     0     0
    0     0     1  
    0     1     0
    0     1     1  <-- This one
    1     0     0  <-- This one
    1     0     1
    1     1     0 
    1     1     1

If you dig into the calculation of the V bit in the ALU, you'll see exactly those conditions used for the generation of the Overflow bit.

Most ALU functions are straightforward; an `AND` literally is input value A AND input value B.  

A compare (`CMP`) is a subtraction, without changing the target.  'Compare A to 10' is quite literally 'set the flags for A-10'.

It is arguable that the 8-bit ALU implementation was overloaded unnecessarily.  Does 'LD' truly belongs there, for instance?  However, it provides a straightforward level of functionality for having the condition code flags set primarily in one location.

The only *frustrating* thing about the 8-bit ALU was that 6809 flags are entirely set in different manners depending on the situation.  They aren't necessarily logically inconsistent, but they are less uniform by implementation than I would have preferred (as I said, N and Z are uniform in the ALU; V and C are not).

The H flag - the half-carry - a BCD carryover that I never used in the 1980s (not even once) is supported for the few instructions marked as actually affecting it.  [There are a few instructions where it's marked as 'undefined'.  Matching the 6809 in those cases wasn't something where I attempted to learn the real silicon's behavioral pattern.  If it was documented as 'undefined', I simply left it with whatever value it already had.]

Half-Carry is intended to be when you're using a nybble per decimal digit, and want to be able to do addition but be able to adjust the result to match correct behavior.

For instance, imagine this:

      59
    + 29
     ----
      88

Now imagine using a nybble per digit.  Represented in hex:

      $59
    + $29
      ----
      $82

Half-Carry is literally intended to be whether a Carry was done out of bit 3 into bit 4.  Since we don't have insight into the carries between digits, we can infer whether a carry was done:

    A4   B4    SUM4
    ---------------
     0    0       0
     0    0       1
     0    1       0
     0    1       1
     1    0       0
     1    0       1
     1    1       0
     1    1       1

Use the table above - it represents SUM=A+B, and shows all combinations of bit 4 for A, bit 4 for B, and bit 4 of the SUM.

We can easily determine whether a carry in was present or not due to some SUM values being impossible *without* a carry-in:


    A4   B4    SUM4    CARRY-IN-FROM-BIT-3
    ------------------------------------------
     0    0       0           0
     0    0       1           1
     0    1       0           1
     0    1       1           0
     1    0       0           1
     1    0       1           0
     1    1       0           0
     1    1       1           1

The desired value for H is that fourth column.  Again, as our adder is infered by Verilog, we don't have access to mid-value-carries.  However, using the values above, we can determine whether there *was* a carry out from bit 3 into bit 4.

Notice that the fourth column is defined literally by the Exclusive OR of the first 3 columns.

In our BCD math example above, `$59+$29=$82`, A4=1, B4=0, SUM4=0.  H = 1^0^0 = 1.

There was indeed a carry between bit 3 and bit 4 in the addition.

The H flag can be read directly, or you can use the `DAA` instruction to read it and also directly adjust values > 9 by adding $06 (if H is set), $60 (if C is set), or $66 (if H and C are set) to the contents of register A.

In our example, H was set, so `DAA` would add $06 to our sum, modifying it from $82 to $88 - the decimal-correct value when representing decimal digits in hex nybbles.

If you're using lots and lots of 7-segment displays, this is truly god's work.  If you're not, it's likely a bit dull.

The 16-bit ALU is something worth glancing at after examining the 8-bit ALU.  It's simpler - it does addition, subtraction, compare, load (to set the flags consistently), and actually load-effective-address (`LEA`, which really is only a convenient 'set Z correctly, please').

[While writing this section of documentation, I have scanned the Verilog for the ALU several times, wondered 'Did I do that right?', checked the 6809 specs and realized 'Huh.  I did.  Go figure.'  It apparently isn't inherently obvious stuff for me.]

### Interrupts

Despite learning assembly 35 years ago on a 6809, until working on this project, I'd never actually thought about "cycle latency before an interrupt is serviced".  Or, in other words, I suppose I had some simplistic notion that the cycle after an interrupt was asserted, it would be serviced.

That just doesn't make sense if you think about it for more than a moment; the 6809 has N cycles per instruction, and there's no real ability to 'unwind' something partially complete.  

The key recognition is that interrupts are serviced in a certain number of cycles *after* the current instruction is complete.  

Refer to Figures 9 and 10 in the 6809 datasheet.

Let's start with Figure 9 - the timing for an /IRQ or /NMI assertion.

The interrupt is asserted in the example while an instruction is still running.  (In the digram, at time m-2.)

That instruction still has one cycle to complete (time m-1).

The fetch for the "next" instruction happens (time m), and the pending interrupt is noticed.  The instruction's first byte is read, but isn't used.  

The same instruction byte is read again on the next cycle - interrupt processing is about to begin (time m+1).

A /VMA (dead) cycle follows (time m+2).

Then, the register contents are written to the stack, PC, U, Y, X, DP, B, A, CC.  (time m+3 through time m+14)

Another /VMA (dead) cycle follows (time m+15).

Finally, the /NMI or the /IRQ vectors are read (cycles m+16, m+17).

One last /VMA (dead) cycle (m+18).

Finally, the first byte of the first instruction of the interrupt handler is read (new time 'n', but basically m+19).

In the design, the check for an interrupt is at the top of `CPUSTATE_FETCH_I1`.  It priority-checks for NMI first, then FIRQ, then IRQ.  If they're found, the next cycle is set off to a state machine entry for that particular interrupt.  

Figure 10 shows almost an identical scenario, but for /FIRQ, only the PC and CC are pushed to the stack.

### Stack usage

The 6809 instructions `PSH` and `PUL` are represented with the particular stack to use, ala `PSHS`, `PULS`, `PSHU`, `PULU`.  The argument with the instruction is the list of registers to push or pull to/from the stack.

That list of registers makes up a byte, which is the 2nd byte of a `PSH` or `PUL` instruction.  The bits in the byte indicate whether a register is in the `PSH` or `PUL` list; bits 7 through 0 are `PC`, `U`/`S`, `Y`, `X`, `DP`, `B`, `A`, `CC`.  [Bit 6 is either `U` or `S` depending on whether the stack being used is `S` or `U` respectively.  I.e., you can pull `U` from the `S` stack, but not `U` from the `U` stack.]

The Figure 18 diagrams for stack manipulation appear in multiple places - NMI/IRQ/FIRQ, `CWAI`, `SWI`/`SWI2`/`SWI3`, `JSR`, `BSR`, `LBSR` for pushing, and `RTI`, `RTS`, and `PUL` for pulling.  

The actual functionality for pushing and pulling is identical between the scenarios.  The /VMA cycles around the scenarios is *not* identical.  

Rather than implement any variable-register-action in multiple places, I chose to implement it in one place with some slight state checkpointing to ensure the correct flow and action.  

The states `CPUSTATE_PSH_ACTION` and `CPUSTATE_PUL_ACTION` are used for interrupts (including `SWI`/`SWI2`/`SWI3`), `RTI`, `PSH`, `CWAI`, and `PUL`. The `JSR`, `BSR`, `LBSR` and `RTS` instructions use one-off stack manipulations to handle the PC.

A registered value named `tmp` is used to store details; `tmp` is used in multiple places in the core, but in this particular flow, the bottom 8 bits of `tmp` is used to represent the bitmap of registers to utilize.  It's a 1:1 match to the 2nd byte of a `PSH` or `PUL` instruction.  However, bit 14 of `tmp` is used to determine which stack is in use.  This bit is **set** for a `PSHU` or `PULU`.  It's cleared in every other situation.  

Bit 15 of `tmp` is used cycle-to-cycle to differentiate between the low and high bytes of a 16-bit register, as this state may run for many cycles.  

Bit 13 of `tmp` is used to indicate whether LIC should be set on every cycle or not.  (This is a requirement for register stacking during an interrupt; it is not normal for a `PSHS` or PSHU`.)

Bit 12 of `tmp` is used to indicate whether we're `PUL`'ing from an RTI and therefore CC should be pulled, E should be examined there, and that used to determine the remainder of the registers to be fetched.

The registered value `NextState` indicates the state to go to next when this state is considered complete.  

## Register Contents

For the purpose of convenience (and for simulation), the 6809i module has an optional output of a 112-bit wide register.  It maps to the 6809's internal register contents:

    BITS        REGISTER
    7:0         A
    15:8        B
    31:16       X
    47:32       Y
    63:48       S
    79:64       U
    87:80       CC
    95:88       DP
    111:96      PC

These are latched internally in the CPU at the falling edge of E; they offer a wonderful insight into the internals of the CPU on an instruction-by-instruction basis.

## Summary

The core is far from perfect; I definitely wasn't attempting to go through the process the folks in the 1970s were - desperately saving gates whereever possible.  At some points, I added registered values for my own convenience, despite being very aware that doing so was *not* cheap.  Were I to actually attempt to implement this in hard silicon, I'd consider revisiting several cases first and streamline them.  However, in an FPGA, the number of potentail Logic Elements to be saved doesn't seem overwhelming, so my motivation there is relatively low.

Please feel free to comment on areas that you feel are incorrect in explanation or *need* more documentation.  This is intended to familiarize people who want to examine or modify the design with the original intentions.  If you're attempting to learn HDL and FPGAs, please don't mistake this for a tutorial.  There are far better places to learn from than here.















