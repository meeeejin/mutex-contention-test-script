# Remove the dump file which already exists
rm /home/mijin/dump.out

iostat -mx 1 > mutex_io.out &

# Write mutex information to file every second
while true
do
    # Get mutex information and write it to the dump file
    mysql -uroot -pvldb7988 \
        -e "SELECT EVENT_NAME, COUNT_STAR, SUM_TIMER_WAIT/1000000000 SUM_TIMER_WAIT_MS, \
            AVG_TIMER_WAIT/1000000000 AVG_TIMER_WAIT_MS \
            FROM performance_schema.events_waits_summary_global_by_event_name \
            WHERE SUM_TIMER_WAIT > 0 AND \
            EVENT_NAME LIKE 'wait/synch/mutex/innodb/%' \
            or EVENT_NAME LIKE 'wait/synch/rwlock/innodb/%' \
            ORDER BY SUM_TIMER_WAIT_MS DESC;" >> dump.out
    echo -e "" >> dump.out
    
    sleep 1
done
