source ../phy/scr/global_variables.tcl
source ../phy/scr/design_variables.tcl

cd ../phy/db/part
read_db ${TOP_NAME}

foreach module $master_partition_module_list {
	#1. read ilm master partitions
}
#2. flatten ilms

#3. place 
#4. ccopt
#5. route

#6. write the place and routed db
