set NUM_CPUS 8
#set the top name of the design
set TOP_NAME drra_wrapper

# Directories
set OUTPUT_DIR "../phy/db"
set RPT_DIR    "../phy/rpt"
set SCR_DIR    "../phy/scr"
#we need a part directory where partitions are created
set PART_DIR   "../phy/db/part/"
set SRC_DIR    "../syn/db/"

set LEF_FILE "/opt/pdk/tsmc90/tcbn90g_110a/digital/Back_End/lef/tcbn90g_110a/lef/tcbn90g_9lm.lef"
set MMMC_FILE         "${SCR_DIR}/mmmc.tcl"
set NETLIST_FILE       "${SRC_DIR}/${TOP_NAME}.v"
set SDC_FILES          "${SRC_DIR}/${TOP_NAME}.sdc"
