## Generated SDC file "alt_top.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Web Edition"

## DATE    "Sun Nov 27 20:39:27 2016"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {OSCCLK} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSCCLK}]
create_clock -name {demo_root:alt_map|mc6809:cpu|rE} -period 40 -waveform { 0.000 20 } [get_registers {demo_root:alt_map|mc6809:cpu|rE}]
create_clock -name {demo_root:alt_map|mc6809:cpu|rQ} -period 40 -waveform { 0.000 20 } [get_registers {demo_root:alt_map|mc6809:cpu|rQ}]
create_clock -name {demo_root:alt_map|ps2_communication:keybd|filteredClk} -period 1000 -waveform { 0.000 500 } [get_registers {demo_root:alt_map|ps2_communication:keybd|filteredClk}]
create_clock -name {demo_root:alt_map|SSEG_Display:U1|q_reg[16]} -period 1000 -waveform { 0.000500 } [get_registers {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50.000 -multiply_by 8 -master_clock {OSCCLK} [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 10 -master_clock {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 8 -master_clock {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 4 -master_clock {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -master_clock {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.200  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -setup 0.140  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -hold 0.130  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -setup 0.140  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -hold 0.130  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -setup 0.140  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -hold 0.130  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -setup 0.140  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -hold 0.130  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rE}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -rise_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}] -fall_to [get_clocks {demo_root:alt_map|ps2_communication:keybd|filteredClk}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|SSEG_Display:U1|q_reg[16]}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rE}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {alt_map|clkpll|pll_clk|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.280  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -rise_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}] -fall_to [get_clocks {demo_root:alt_map|mc6809:cpu|rQ}]  0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************


#**************************************************************
# Set Input Transition
#**************************************************************

