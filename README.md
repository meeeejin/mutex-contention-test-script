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

3. Script를 실행한다. 각 benchmark가 실행되는 동안, mutex 관련 정보가 `result_dir` 폴더에 기록된다.

```bash
./run_tpcc.sh # TPC-C 돌리면서 mutex 정보 수집
```

```bash
./run_lb.sh # LinkBench 돌리면서 mutex 정보 수집
```

Mutex 관련 정보는 아래와 같은 방식으로 기록된다

```bash
EVENT_NAME      COUNT_STAR      SUM_TIMER_WAIT_MS       AVG_TIMER_WAIT_MS
wait/synch/mutex/innodb/buf_pool_mutex  92889   9.8649  0.0001
wait/synch/mutex/innodb/rw_lock_list_mutex      327755  5.9407  0.0000
wait/synch/mutex/innodb/fil_system_mutex        122355  5.8620  0.0000
wait/synch/mutex/innodb/log_sys_mutex   30882   1.5461  0.0000
wait/synch/mutex/innodb/trx_mutex       596     0.0109  0.0000
wait/synch/mutex/innodb/recv_sys_mutex  199     0.0098  0.0000
wait/synch/mutex/innodb/dict_sys_mutex  44      0.0097  0.0002
wait/synch/mutex/innodb/flush_list_mutex        116     0.0058  0.0000
wait/synch/mutex/innodb/sync_array_mutex        46      0.0051  0.0001
wait/synch/mutex/innodb/redo_rseg_mutex 97      0.0036  0.0000
wait/synch/mutex/innodb/trx_sys_mutex   113     0.0027  0.0000
wait/synch/mutex/innodb/lock_mutex      98      0.0020  0.0000
wait/synch/mutex/innodb/log_sys_write_mutex     40      0.0019  0.0000
wait/synch/mutex/innodb/log_flush_order_mutex   38      0.0015  0.0000
wait/synch/mutex/innodb/thread_mutex    24      0.0014  0.0001
wait/synch/mutex/innodb/lock_wait_mutex 4       0.0009  0.0002
wait/synch/mutex/innodb/trx_pool_manager_mutex  12      0.0008  0.0001
wait/synch/mutex/innodb/innobase_share_mutex    16      0.0007  0.0000
wait/synch/mutex/innodb/row_drop_list_mutex     3       0.0007  0.0002
wait/synch/mutex/innodb/trx_pool_mutex  20      0.0007  0.0000
wait/synch/mutex/innodb/srv_sys_mutex   12      0.0006  0.0000
wait/synch/mutex/innodb/buf_dblwr_mutex 9       0.0006  0.0001
wait/synch/mutex/innodb/page_cleaner_mutex      4       0.0002  0.0001
wait/synch/mutex/innodb/file_format_max_mutex   10      0.0002  0.0000
wait/synch/mutex/innodb/ibuf_mutex      3       0.0001  0.0000
wait/synch/mutex/innodb/srv_innodb_monitor_mutex        1       0.0000  0.0000
wait/synch/mutex/innodb/recv_writer_mutex       1       0.0000  0.0000
wait/synch/mutex/innodb/autoinc_mutex   1       0.0000  0.0000
...
```

4. 수집된 mutex 정보를 이용해, buffer pool 개수와 workload에 따른 mutex contention 경향을 분석한다.

> 수정 중..
