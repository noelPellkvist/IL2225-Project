################################################################################
# Design Compiler bottom-up logic synthesis script
################################################################################
#
# This script is meant to be executed with the following directory structure
#
# project_top_folder
# |
# |- db: store output data like mapped designs or physical files like GDSII
# |
# |- phy: physical synthesis material (scripts, pins, etc)
# |
# |- rtl: contains rtl code for the design, it should also contain a
# |       hierarchy.txt file with the all the files that compose the design
# |
# |- syn: logic synthesis material (this script, SDC constraints, etc)
# |
# |- sim: simulation stuff like waveforms, reports, coverage etc.
# |
# |- tb: testbenches for the rtl code
# |
# |- exe: the directory where it should be executed. This keeps all the temp files
#         created by DC in that directory
#
#
# The standard way of executing the is from the project_top_folder
# with the following command
#
# $ dc_shell -f ../syn/dc_flat.tcl
################################################################################

#1. source setup file to extract global libraries
#2. set the TOP_NAME of the design

# Directories for output material
set REPORT_DIR  ../syn/rpt;      # synthesis reports: timing, area, etc.
set OUT_DIR ../syn/db;           # output files: netlist, sdf sdc etc.
set SOURCE_DIR ../rtl;           # rtl code that should be synthesised
set SYN_DIR ../syn;              # synthesis directory, synthesis scripts constraints etc.

#define the process
proc nth_pass {n} {
	#3. import the global variables for the process

	set prev_n [expr {$n - 1}]
	exec rm -rf ${OUT_DIR}/pass${n}
	exec mkdir -p ${OUT_DIR}/pass${n}
	remove_design -all
	
	#4. Anayze the files in ${SOURCE_DIR}/pkg_hierarchy.txt. These files only contain variable definitions so you don't need to elaborate them
	
	#Next we will compile divider_pipe first, ${SOURCE_DIR}/mtrf/DPU/divider_pipe.vhd. As the divider is a big structure We would like to import constraints in the next pass over divider pipe
	#5. analyze divider_pipe
	#6. elaborate divider_pipe
	#7. set the current design to divider_pipe
	#8. link
	#9. uniquify
	#10 source the top constraints file
	if  {$n > 1} {
	    #11. source constraints of divider pipe from previous pass
	}
	#11. compile
	
	# We will compile the "silego" entity, which is identical for all the tiles. We will also import its constraints for the next pass.
	#12. analyze silego, use silego_hierarchy.
	#13. elaborate silego
	#14. set the current design to silego
	#15. link
	#16. uniquify
	#17. source the top constraints file
	if {$n > 1} {
		#18. source the silego constraints file from the previous pass
    	}
	#19. set dont touch attribute for divider_pipe
	#20. compile

	#21. analyze Silago_top
        #22. elaborate Silago_top
	#23. set current design to Silago_top
	#24. link
	#25. uniquify
	#26. source the top constraints
	#27. set dont touch for silego and divider pipe
	#28. compile

	# Repeat 21. to 28. for the remaining unique tile designs: Silago_bot, Silago_top_left_corner, Silago_top_right_corner, Silago_bot_left_corner, Silago_bot_right_corner
	
	#29. analyze drra_wrapper
    	#30. elaborate drra_wrapper
	#31. set current design to drra_wrapper
	#32. set dont touch for divider pipe and ALL tiles
    	#33. source constraints
    	#34. report timing of drra wrapper in the current pass
	#35. write_ddc from the current pass
    	#36. characterize constraints of silego and divider_pipe
}

#EXECUTE N PASSES OF THE ABOVE FUNCTION. DECIDE ON A REASONABLE N.

#37. Set current design to drra_wrapper 
#38. Report the final timing, power, area.

#39. Write the netlist, ddc, sdc and sdf.
