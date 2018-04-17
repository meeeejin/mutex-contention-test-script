#!/bin/bash

data_dir="/home/yangws/test_data"
log_dir="/home/yangws/test_log"
backup_dir="/home/yangws/data_backup"
result_dir="/home/yangws/test_result"

mysql_dir="/home/yangws/mysql-5.7.21"
tpcc_dir="/home/yangws/tpcc-mysql"

current_dir=$(pwd)

buf_instance=( "1" "4" "8" "16" "32" )
passwd="1234"

echo "Start TPCC to test mutex contention"

for i in "${buf_instance[@]}"
do
    # If the result file already exists, remove it
    rm ${result_dir}/mutex_buf_${i}.out

    # Remove existing data
    rm -rf ${data_dir}/*
    rm -rf ${log_dir}/*

    # Copy data
    cp -r ${backup_dir}/data/* ${data_dir}/
    cp -r ${backup_dir}/log/* ${log_dir}/

    # Run MySQL server
    echo "RUN MYSQL SERVER"
    cd ${mysql_dir}
    ./bin/mysqld_safe --innodb_buffer_pool_instances=$i &>/dev/null &disown

    sleep 5s

    # Run TPC-C benchmark
    echo "START TPCC BENCHMARK"
    cd ${tpcc_dir}
    iostat -mx 1 > ${result_dir}/iostat_buf_${i}.out &
    ./runBench.sh | tee ${result_dir}/tpcc_buf_${i}.out

    cd ${current_dir}
    ./monitoring.sh ${i}

    killall -9 iostat

    # Shutdown MySQL server
    ps cax | grep mysql > /dev/null
    if [ $? -eq 0 ]; then
        cd ${mysql_dir}
        ./bin/mysqladmin -uroot -p${passwd} shutdown
    fi
done


