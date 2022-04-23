#!/bin/bash
set -eu

name=${4}
conf=${5}
bin=${6}

echo "scp ${conf} ..."
scp ${conf} ${name}@${1}:/tidb-bench/deploy/tikv-10004/conf
scp ${conf} ${name}@${2}:/tidb-bench/deploy/tikv-10004/conf
scp ${conf} ${name}@${3}:/tidb-bench/deploy/tikv-10004/conf
echo "scp ${bin} ..."
scp ${bin} ${name}@${1}:/tidb-bench/deploy/tikv-10004/bin
scp ${bin} ${name}@${2}:/tidb-bench/deploy/tikv-10004/bin
scp ${bin} ${name}@${3}:/tidb-bench/deploy/tikv-10004/bin
echo "restore pd ..."
sudo rm -rf /tidb-bench/data/pd-10002 && sudo cp -r /tidb-copy/pd-10002 /tidb-bench/data
sudo chmod -R 777 /tidb-bench
echo "restore tikv ..."
ssh ${name}@${1} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data/ && sudo chmod -R 777 /tidb-bench" &
ssh ${name}@${2} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data/ && sudo chmod -R 777 /tidb-bench" &
ssh ${name}@${3} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data/ && sudo chmod -R 777 /tidb-bench" &

for pid in $(jobs -p)
do
    wait $pid
    if [ $? -eq 0 ]; then
        echo "re done" >> log.restore
    else
        echo "re error" >> log.restore
    fi
done
