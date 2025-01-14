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
source ../../synopsys_dc.setup;                    

#2. set the TOP_NAME of the design
set TOP_NAME drra_wrapper;

# Directories for output material
set REPORT_DIR  ../../rpt_bottomup;      # synthesis reports: timing, area, etc.
set OUT_DIR ../../syn/db;           # output files: netlist, sdf sdc etc.
set SOURCE_DIR ../../rtl;           # rtl code that should be synthesised
set SYN_DIR ../;              # synthesis directory, synthesis scripts constraints etc.

#define the process
proc nth_pass {n} {
	#3. import the global variables for the process
	global REPORT_DIR OUT_DIR SOURCE_DIR SYN_DIR;   	

	set prev_n [expr {$n - 1}]
	exec rm -rf ${OUT_DIR}/pass${n}
	exec mkdir -p ${OUT_DIR}/pass${n}
	remove_design -all
	
	#4. Anayze the files in ${SOURCE_DIR}/pkg_hierarchy.txt. These files only contain variable definitions so you don't need to elaborate them
	#Read and segment {SOURCE_DIR}/pkg_hierarchy.txt
	set hierarchy_files [split [read [open ${SOURCE_DIR}/pkg_hierarchy.txt r]] "\n"]
	foreach filename [lrange ${hierarchy_files} 0 end-1] {
	    #puts "${filename}"
		#Analyse each file
	    analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
	}
	puts "\n\n\n=============\n"


	#analyze -f vhdl state_vector.vhdl
	
	#Next we will compile divider_pipe first, ${SOURCE_DIR}/mtrf/DPU/divider_pipe.vhd. As the divider is a big structure We would like to import constraints in the next pass over divider pipe
	#5. analyze divider_pipe
	analyze -format VHDL -lib WORK ${SOURCE_DIR}/mtrf/DPU/divider_pipe.vhd
	#6. elaborate divider_pipe
	elaborate divider_pipe -lib WORK -update
	#7. set the current design to divider_pipe, Is done automaticly by elaborate
	#current_design = divider_pipe	
	#8. link
	link

	#throw {ARITH DIVZERO {divide by zero}} {divide by zero}
		
	#9. uniquify
	uniquify
	puts "Test 1"
	#10 source the top constraints file
	if  {$n > 1} {
	    #11. source constraints of divider pipe from previous pass
		source ${REPORT_DIR}/divider_pipe_${prev_n}_constratints.sdc
	}
	#11. compile
	compile
	

	puts "\n\n\n=============\n"
	# We will compile the "silego" entity, which is identical for all the tiles. We will also import its constraints for the next pass.
	#12. analyze silego, use silego_hierarchy.
	set hierarchy_files [split [read [open ${SOURCE_DIR}/silego_hierarchy.txt r]] "\n"]
	foreach filename [lrange ${hierarchy_files} 0 end-1] {
	    analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
	}
	#13. elaborate silego
	elaborate silego -lib WORK -update
	#14. set the current design to silego
	#current_design = silego
	#throw {ARITH DIVZERO {divide by zero}} {divide by zero}
	#15. link
	link
	#16. uniquify
	uniquify
	#17. source the top constraints file
	if {$n > 1} {
		puts "loading previos constraints"
		source ${REPORT_DIR}/silego_${prev_n}_constratints.sdc
		#18. source the silego constraints file from the previous pass
    	}
	#19. set dont touch attribute for divider_pipe
	dont_touch divider_pipe true
	#20. compile
	compile

	puts "\n\n\n=============\n"

	#21. analyze Silago_top
	#22. elaborate Silago_top
	#23. set current design to Silago_top
	#24. link
	#25. uniquify
	#26. source the top constraints
	#27. set dont touch for silego and divider pipe
	#28. compile

	# Repeat 21. to 28. for the remaining unique tile designs: Silago_bot, Silago_top_left_corner, Silago_top_right_corner, Silago_bot_left_corner, Silago_bot_right_corner

	array set remaining_designs {
		Silago_top
		Silago_bot
		Silago_top_left_corner
		Silago_top_right_corner
		Silago_bot_left_corner
		Silago_bot_right_corner
	}
	foreach design [array names remaining_designs] {
   		puts "\n=======Will now compile: $design ======\n" 
		analyze -format VHDL -lib WORK $design	
		elaborate $design -lib WORK -update
		current_design $design
		link
		uniquify

		#We source the top constraints
		source ${SYN_DIR}/constraints.sdc
		dont_touch divider_pipe true
		dont_touch silego true
		
		compile
	}
	

puts "\n\n\n=============\n"


	#29. analyze drra_wrapper
    	#30. elaborate drra_wrapper
	#31. set current design to drra_wrapper
	analyze -format VHDL -lib WORK drra_wrapper
	elaborate drra_wrapper -lib WORK -update
	#32. set dont touch for divider pipe and ALL tiles
	dont_touch divider_pipe true
	dont_touch silego true
	foreach design [array names remaining_designs] {
   		dont_touch $design true
	}
	#33. source constraints
puts "\n\n\n=======Finished Compilation nr $n ======\n"
puts "Reporting"
	source ${SYN_DIR}/constraints.sdc
    	#34. report timing of drra wrapper in the current pass
	set file_path "${REPORT_DIR}/drra_wrapper_timing_${n}.txt"
	report_timing > $file_path





    	#36. characterize constraints of silego and divider_pipe
	current_design divider_pipe
	set file_path "${REPORT_DIR}/divider_pipe_${n}_constratints.sdc"
	report_constraints > $file_path

	current_design silego
	set file_path "${REPORT_DIR}/silego_${n}_constratints.sdc"
	report_constraints > $file_path

	#35. write_ddc from the current pass
	write -hierarchy -format ddc -output ${OUT_DIR}/drra_wrapper_${n}.ddc


}

#EXECUTE N PASSES OF THE ABOVE FUNCTION. DECIDE ON A REASONABLE N.
#We test with 2 passes
nth_pass 1
#nth_pass 2 
#nth_pass 3

#37. Set current design to drra_wrapper 
current_design drra_wrapper
#38. Report the final timing, power, area.
report_constraints > ${REPORT_DIR}/drra_wrapper_constratints.sdc
report_area > ${REPORT_DIR}/drra_wrapper_area.txt
report_cell > ${REPORT_DIR}/drra_wrapper_cells.txt
report_timing > ${REPORT_DIR}/drra_wrapper_timing.txt
report_power > ${REPORT_DIR}/drra_wrapper_power.txt


#39. Write the netlist, ddc, sdc and sdf.
write -hierarchy -format ddc -output ${OUT_DIR}/drra_wrapper.ddc
write -hierarchy -format verilog -output ${OUT_DIR}/drra_wrapper.v
