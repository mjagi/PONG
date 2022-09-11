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


##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {red[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {red[0]}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {red[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {red[1]}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {red[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {red[2]}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {red[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {red[3]}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {green[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {green[0]}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {green[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {green[1]}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {green[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {green[2]}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {green[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {green[3]}]

##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {blue[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {blue[0]}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {blue[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {blue[1]}]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {blue[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {blue[2]}]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports {blue[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {blue[3]}]
##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {hs2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {hs2}]
##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {vs2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {vs2}]
##Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {ps2_clk_sec}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ps2_clk_sec}]
##Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {ps2_data_sec}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ps2_data_sec}]

