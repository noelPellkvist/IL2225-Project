#1. source global variables
#2. source design variables

set_multi_cpu_usage -local_cpu ${NUM_CPUS} -cpu_per_remote_host 1 -remote_host 0 -keep_license true
set_distributed_hosts -local
#3. set vdd net
#4. set vss net
#5. read mmmc file
#6. read lef 
#7. read logic synthesis netlist
init_design
