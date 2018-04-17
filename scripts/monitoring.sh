#!/bin/bash

result_dir="/home/yangws/test_result"
mysql_dir="/home/yangws/mysql-5.7.21"
passwd="1234"

end=$((SECONDS+3600))

# Write mutex information to file every second
while [ $SECONDS -lt $end ]
do
    # Get mutex information and write it to the result file
    mysql -uroot -p${passwd} \
        -e "SELECT EVENT_NAME, COUNT_STAR, SUM_TIMER_WAIT/1000000000 SUM_TIMER_WAIT_MS, \
            AVG_TIMER_WAIT/1000000000 AVG_TIMER_WAIT_MS \
            FROM performance_schema.events_waits_summary_global_by_event_name \
            WHERE SUM_TIMER_WAIT > 0 AND \
            EVENT_NAME LIKE 'wait/synch/mutex/innodb/%' \
            or EVENT_NAME LIKE 'wait/synch/rwlock/innodb/%' \
            ORDER BY SUM_TIMER_WAIT_MS DESC;" >> ${result_dir}/mutex_buf_$1.out
    echo -e "" >> ${result_dir}/mutex_buf_$1.out
    
    sleep 1
done
