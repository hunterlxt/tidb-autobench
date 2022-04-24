#!/bin/bash
set -eu

user=${1}
backup=${2}
tikvs=${3}
bin=${4}
conf=${5}
tpcc_args=${6}


./scripts/restore_bench_data.sh $user "${conf}/tikv.toml" $bin $backup $tikvs
tiup cluster start test
sleep 60
mkdir -p logs
tiup bench $tpcc_args > logs/"`date` ${tpcc_args}".log
tiup cluster stop test -R tidb,pd,tikv -y
