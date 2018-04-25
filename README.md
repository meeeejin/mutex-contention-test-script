# Script for mutex contention test

- for graduation thesis (@YangWonSuk0227)
- Buffer pool instance 개수를 변화시켰을 때, workload에 따른 mutex contention 분석

## Prerequisite

본 repository에서 제공하는 script 실행을 위해선 아래의 프로그램들을 미리 설치해야 한다.

- [MySQL server](https://github.com/meeeejin/til/blob/master/mysql/build-and-install-the-source-code-5.7.md)
- [TPC-C](https://github.com/Percona-Lab/tpcc-mysql)
- [LinkBench](https://github.com/facebookarchive/linkbench)
- sysstat (`sudo apt-get install sysstat`)

## How to run the scripts

1. 먼저, repository를 clone 한다.

```bash
git clone https://github.com/meeeejin/mutex-contention-test-script
```

2. Clone한 repository의 scripts 폴더로 들어간 후, `run_tpcc.sh` 또는 `run_lb.sh`의 변수 값들을 알맞은 값들로 수정한다.

```bash
cd mutex-contention-test-script/scripts
vi run_tpcc.sh # TPC-C script 파일 수정
vi run_lb.sh # linkBench script 파일 수정
```

3. InnoDB mutex 및 sxlock 인스턴스가 활성화되도록, 아래의 performance-schema-instrument rule을 MySQL의 configure 파일(`my.cnf`)에 추가한다.

```bash
performance-schema-instrument='wait/synch/mutex/innodb/%=ON'
performance-schema-instrument='wait/synch/sxlock/innodb/%=ON'
```

3. Script를 실행한다. 각 benchmark가 실행되는 동안, mutex 관련 정보가 `result_dir` 폴더에 기록된다.

```bash
./run_tpcc.sh # TPC-C 돌리면서 mutex 정보 수집
```

```bash
./run_lb.sh # LinkBench 돌리면서 mutex 정보 수집
```

Mutex 및 swlock 관련 정보는 아래와 같은 방식으로 기록된다

```bash
EVENT_NAME      COUNT_STAR      SUM_TIMER_WAIT_MS       AVG_TIMER_WAIT_MS
wait/synch/sxlock/innodb/checkpoint_lock        4       13.1749 3.2937
wait/synch/mutex/innodb/buf_pool_mutex  92891   10.4717 0.0001
wait/synch/mutex/innodb/rw_lock_list_mutex      327766  5.7679  0.0000
wait/synch/mutex/innodb/fil_system_mutex        122369  5.6782  0.0000
wait/synch/mutex/innodb/dict_sys_mutex  62      5.3440  0.0862
wait/synch/sxlock/innodb/hash_table_locks       62703   4.6289  0.0001
wait/synch/mutex/innodb/log_sys_mutex   30884   1.4442  0.0000
wait/synch/mutex/innodb/trx_mutex       1305    0.0258  0.0000
wait/synch/sxlock/innodb/index_tree_rw_lock     309     0.0226  0.0001
wait/synch/mutex/innodb/sync_array_mutex        179     0.0143  0.0001
wait/synch/mutex/innodb/recv_sys_mutex  199     0.0112  0.0001
wait/synch/mutex/innodb/thread_mutex    24      0.0109  0.0005
wait/synch/sxlock/innodb/fil_space_latch        127     0.0068  0.0001
wait/synch/mutex/innodb/flush_list_mutex        116     0.0062  0.0001
wait/synch/mutex/innodb/redo_rseg_mutex 116     0.0055  0.0000
wait/synch/mutex/innodb/innobase_share_mutex    48      0.0045  0.0001
wait/synch/mutex/innodb/trx_sys_mutex   141     0.0039  0.0000
wait/synch/sxlock/innodb/dict_table_stats       16      0.0024  0.0001
wait/synch/mutex/innodb/log_sys_write_mutex     40      0.0021  0.0001
wait/synch/mutex/innodb/lock_mutex      98      0.0019  0.0000
wait/synch/mutex/innodb/trx_pool_manager_mutex  35      0.0017  0.0000
wait/synch/mutex/innodb/trx_pool_mutex  43      0.0016  0.0000
wait/synch/sxlock/innodb/dict_operation_lock    6       0.0016  0.0003
wait/synch/mutex/innodb/log_flush_order_mutex   38      0.0012  0.0000
wait/synch/sxlock/innodb/btr_search_latch       19      0.0011  0.0001
wait/synch/mutex/innodb/lock_wait_mutex 4       0.0010  0.0003
wait/synch/sxlock/innodb/trx_purge_latch        4       0.0010  0.0002
wait/synch/mutex/innodb/buf_dblwr_mutex 9       0.0009  0.0001
wait/synch/mutex/innodb/row_drop_list_mutex     3       0.0007  0.0002
wait/synch/mutex/innodb/srv_sys_mutex   12      0.0004  0.0000
wait/synch/mutex/innodb/page_cleaner_mutex      4       0.0003  0.0001
wait/synch/mutex/innodb/ibuf_mutex      3       0.0002  0.0001
wait/synch/mutex/innodb/file_format_max_mutex   10      0.0002  0.0000
wait/synch/mutex/innodb/srv_innodb_monitor_mutex        1       0.0001  0.0001
wait/synch/mutex/innodb/recv_writer_mutex       1       0.0001  0.0001
wait/synch/sxlock/innodb/fts_cache_rw_lock      0       0.0000  0.0000
wait/synch/sxlock/innodb/fts_cache_init_rw_lock 0       0.0000  0.0000
wait/synch/sxlock/innodb/trx_i_s_cache_lock     0       0.0000  0.0000
wait/synch/sxlock/innodb/index_online_log       0       0.0000  0.0000
wait/synch/mutex/innodb/autoinc_mutex   1       0.0000  0.0000
...
```

4. 수집된 mutex 정보를 이용해, buffer pool 개수와 workload에 따른 mutex contention 경향을 분석한다.

> 수정 중..
