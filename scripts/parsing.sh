#!/bin/bash

result_dir="/home/yangws/test_result"

buf_instance=( "1" "4" "8" "16" "32" )
mutex_name=( "buf_pool_mutex" "redo_resg_mutex" "buf_dblwr_mutex" \
		"fil_system_mutex" "lock_mutex" "log_sys_mutex" )
#		"index_tree_rw_lock" "fil_space_latch" "btr_search_latch" "hash_table_locks" )

cd ${result_dir}

for i in "${buf_instance[@]}"
do
    for j in "${mutex_name[@]}"
    do
        grep ${j} mutex_buf_${i}.out | awk '{ print $3 }' > temp.out
        awk 'NR==1{p=$1;next} 
            {print $1-p; p=$1} 
            #END{print p}' temp.out > ${j}_buf_${i}.out
        rm temp.out
    done
done
