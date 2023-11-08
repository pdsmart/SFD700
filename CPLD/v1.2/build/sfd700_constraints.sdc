## Generated SDC file "tzpuFusionX.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Fri Jun 26 22:10:05 2020"

##
## DEVICE  "EPM7160STC100-10"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

# Standard mainboard clock. Varies so take 4MHz being maximum.
#create_clock -name {CLK_BUS0} -period 250.00 -waveform { 0.000 125.000 } [get_ports { CLK_BUS0 }]

# For 16MHz crystal.
create_clock -name {CLK_16M} -period 62.500 -waveform { 0.000 31.250 }   [ get_ports { CLK_16M }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_ADDR[*]}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_DATA[*]}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {ID[*]}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_WRn}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_RDn}]
#set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_M1n}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_MREQn}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_IORQn}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_RESETn}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {MODE[*]}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {INTRQ}]
set_input_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DRQ}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_DATA[*]}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {ID[*]}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_INT}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {Z80_EXWAITn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {ROM_A10}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {RAM_A10}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {ROM_CSn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {RAM_CSn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {RSV}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {FDCn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DDENn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {SIDE1}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {MOTOR}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DRVSAn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DRVSBn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DRVSCn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {DRVSDn}]
set_output_delay -add_delay  -clock [get_clocks {CLK_16M}]  1.000 [get_ports {CLK_FDC}]

#**************************************************************
# Set Max Delay
#**************************************************************

#**************************************************************
# Set Min Delay
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
