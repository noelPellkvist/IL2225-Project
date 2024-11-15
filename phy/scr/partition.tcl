foreach part_hinst ${all_partition_hinst_list} {
# 1. create partitions for ALL design blocks
}
#2. align partitions
#3. assign partition pins
#4. assign io pins
set_db budget_virtual_opt_engine none
set_db budget_constant_model true
set_db budget_include_latency true
#5. create timing budget for MASTER partitions. The rest are cloned.
#6. commit partitions
#7. write partitions

