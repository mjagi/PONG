# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
# create_clock -name external_clock -period 10.00 [get_ports clk]

# Constraints for MOUSE
set_property PACKAGE_PIN C17 [get_ports {ps2_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {ps2_clk}]
set_property PULLUP true [get_ports ps2_clk]
set_property PACKAGE_PIN B17 [get_ports {ps2_data}]
set_property IOSTANDARD LVCMOS33 [get_ports {ps2_data}]
set_property PULLUP true [get_ports ps2_data]

# Constraints for RESET
set_property PACKAGE_PIN U18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

#7 segment display
set_property PACKAGE_PIN W7 [get_ports {sseg_ca[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[0]}]
set_property PACKAGE_PIN W6 [get_ports {sseg_ca[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[1]}]
set_property PACKAGE_PIN U8 [get_ports {sseg_ca[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[2]}]
set_property PACKAGE_PIN V8 [get_ports {sseg_ca[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[3]}]
set_property PACKAGE_PIN U5 [get_ports {sseg_ca[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[4]}]
set_property PACKAGE_PIN V5 [get_ports {sseg_ca[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[5]}]
set_property PACKAGE_PIN U7 [get_ports {sseg_ca[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[6]}]

# set_property PACKAGE_PIN V7 [get_ports {sseg_ca[7]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[7]}]

set_property PACKAGE_PIN U2 [get_ports {sseg_an[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[0]}]
set_property PACKAGE_PIN U4 [get_ports {sseg_an[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[1]}]
set_property PACKAGE_PIN V4 [get_ports {sseg_an[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[2]}]
set_property PACKAGE_PIN W4 [get_ports {sseg_an[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[3]}]

# Constraints for BUTTON
set_property PACKAGE_PIN T17 [get_ports {button}]
set_property IOSTANDARD LVCMOS33 [get_ports {button}]

# Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
set_property PACKAGE_PIN P19 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]

# Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

# Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

# Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

# Constraints for PCLK_MIRROR
#set_property PACKAGE_PIN J1 [get_ports {pclk_mirror}]
#set_property IOSTANDARD LVCMOS33 [get_ports {pclk_mirror}]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {r[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {r[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {r[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {r[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {g[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {g[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {g[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
##Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {g[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

##Pmod Header JXADC
##Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {b[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
##Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports {b[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
##Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {b[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
##Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {b[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]
##Sch name = XA1_N
set_property PACKAGE_PIN K3 [get_ports {vs}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
##Sch name = XA2_N
set_property PACKAGE_PIN M3 [get_ports {hs}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {hs}]
##Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {JXADC[6]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
##Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {JXADC[7]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]
