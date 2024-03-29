#Project name                                 -- EDIT
set project screen_example
# Top module name                             -- EDIT
set top_module top_pong
# FPGA device
set target xc7a35tcpg236-1
# Bitstream location
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

# Print how to use the script
proc usage {} {
puts "===========================================================================\n
usage: vivado -mode tcl -source [info script] -tclargs \[open/rebuild/sim/bit/prog\]\n
\topen    - open project and start gui\n
\trebuild - clear build directory and create the project again from sources, then open gui\n
\tsim     - run simulation\n
\tbit     - generate bitstream\n
\tprog    - load bitstream to FPGA\n
If a project is already created in the build directory, run.tcl opens it. Otherwise, creates a new one.
==========================================================================="
}

# Create project
proc create_new_project {project target top_module} {
    file mkdir build
    create_project ${project} build -part ${target} -force
    
    # Specify .xdc files location             -- EDIT
    read_xdc {
        constraints/vga_example.xdc
		constraints/clk_wiz_0.xdc
		constraints/clk_wiz_0_board.xdc
		constraints/clk_wiz_0_late.xdc
		constraints/clk_wiz_0_ooc.xdc
    }

    # Specify verilog design files location   -- EDIT
    read_verilog {
        rtl/top_pong.v
		rtl/vga_timing.v
		rtl/draw_background.v
		rtl/draw_rect.v
		rtl/rst_d.v
		rtl/delay.v
		rtl/clk_wiz_0.v
		rtl/clk_wiz_0_clk_wiz.v
		rtl/Mouse_delay.v
		rtl/top_ctl.v
		rtl/control.v
		rtl/game_ctl.v
		rtl/cred_ctl.v
		rtl/menu_ctl.v
		rtl/if_menu.v
		rtl/score_res.v
		rtl/draw_ball.v
		rtl/draw_ball_ctl.v
		rtl/draw_cred_ctl.v
		rtl/draw_cred_char.v
        rtl/image_rom.v
		rtl/char_rom_16x6_cred.v
        rtl/char_rom_16x1_start.v
        rtl/char_rom_16x1_credits.v
        rtl/char_rom_16x1_colors.v
        rtl/char_rom_16x2_diff.v
		rtl/font_rom.v
		rtl/draw_rect_char.v
		rtl/ring_counter.v
		rtl/sseg_conv.v
		rtl/sseg_mux.v
		rtl/point_display.v
		rtl/clk_divider.v
    }
    
    # Specify vhdl design files location      -- EDIT
     read_vhdl {
         rtl/MouseCtl.vhd    
		 rtl/Ps2Interface.vhd
         rtl/MouseDisplay.vhd
     }
    
    # Specify files for memory initialization -- EDIT
     read_mem {
         rtl/image_rom.data
     }

    # Specify simulation files location       -- EDIT
    add_files -fileset sim_1 {
        sim/testbench.v
		sim/tiff_writer.v
    }

    set_property top ${top_module} [current_fileset]
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
}

# Open existing project
proc open_existing_project {project} {
    open_project build/$project.xpr
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
}

# If project already exists, open it. Otherwise, create it.
proc open_or_create_project {project target top_module} {
    if {[file exists build/$project.xpr] == 1} {
        open_existing_project $project 
    } else {
        create_new_project $project $target $top_module
    }
}


# Load bitstream to FPGA
proc program_fpga {bitstream_file} {
    if {[file exists $bitstream_file] == 0} {
        puts "ERROR: No bitstream found"
    } else {
        open_hw
        connect_hw_server
        current_hw_target [get_hw_targets *]
        open_hw_target
        current_hw_device [lindex [get_hw_devices] 0]
        refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

        set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

        program_hw_devices [lindex [get_hw_devices] 0]
        refresh_hw_device [lindex [get_hw_devices] 0]
    }
}

# Simulation
proc simulation {} {
    launch_simulation
    # run all
}

# Generate bitstream
proc bitstream {} {
    # Run synthesis
    reset_run synth_1
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1
    
    # Run implemenatation up to bitstream generation
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
}

## MAIN
if {$argc == 1} {
    switch $argv {
        open {
            open_or_create_project $project $target $top_module    
            start_gui
        }
        rebuild {
            create_new_project $project $target $top_module    
            start_gui
        }
        sim {
            open_or_create_project $project $target $top_module    
            simulation
            start_gui
        }
        bit {
            open_or_create_project $project $target $top_module    
            bitstream
            exit
        }
        prog {
            program_fpga $bitstream_file
            exit
        }
        default {
            usage
            exit 1
        }
    }
} else {
    usage
    exit 1
}
