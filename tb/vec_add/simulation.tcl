#1. Set the source directory

vlib work
vlib dware

set TOP_NAME SilagoNN
set RUN_TIME "1us"

set REPORT_DIR ../../syn/rpt;
set OUT_DIR ../../syn/db;
set SOURCE_DIR ../../rtl;
set SYN_DIR ../../syn;
set TB_DIR .;

#2. Compile dware libraries into "dware"
set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
	vcom -2008 -work dware ${SOURCE_DIR}/${filename}
}
set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy_verilog.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    vlog -work dware ${SOURCE_DIR}/${filename}
}

#3. Compile silagonn design into "work"
set hierarchy_files [split [read [open ${SOURCE_DIR}/silagonn_hierarchy.txt r]] "\n"]

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    # puts "${filename}"
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work work ${SOURCE_DIR}/${filename}
    } else {
        vlog -v2001 -work work ${SOURCE_DIR}/${filename}
    }
}

#4. Compile ./const_package.vhd 
vcom -2008 -work work ${TB_DIR}/const_package.vhd

#5. Compile ./testbench.vhd 
vcom -2008 -work work ${TB_DIR}/testbench.vhd

#6. Open the simulation
vsim -voptargs=+acc work.testbench

#7. The below command will load the desired signals waveform. We are interested to see if the DPU<0,0> is adding the input numbers.
do wave.do
#8. Run simulation for 1000ns
run 1000ns
