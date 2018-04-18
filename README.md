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

4. 수집된 mutex 정보를 이용해, buffer pool 개수와 workload에 따른 mutex contention 경향을 분석한다.

> 수정 중..
