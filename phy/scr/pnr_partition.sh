#1. This tiny bash script is for automation of placing and routing the partitions.
#2. Instead of place and routing the six paritions one by one, you can use this script. 
#3. The script simply triggers pnr_parititon.tcl script for all the partitions in the part directory at once.
#4. It is not required to use this script for this project. But interested students can use it and see the benefits of automating tasks.
#5. Feel free to use Google or ChatGPT to understand the commands :)

partition_list="$(ls ../phy/db/part/*enc | grep -v ${TOP_NAME})"

for partition in ${partition_list}
do
	filename=$(basename -- "$partition")
	extension="${filename##*.}"
	filename="${filename%.*}"
	cd ${partition}.dat
	rm -rf pnr 
	mkdir pnr 
	nohup innovus -stylus -no_gui -batch -files ../../../scr/pnr_partition.tcl -log "../../../../log/pnr_${filename}_${TIMESTAMP}.log ../../../../log/pnr_part_${filename}_${TIMESTAMP}.cmd ../../../../log/pnr_part_${filename}_${TIMESTAMP}.logv" &
	cd ../../../../exe
done

