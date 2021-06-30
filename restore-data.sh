#!/bin/bash
set -eu
name=${4}
echo "restore pd ..."
sudo rm -rf /tidb-bench/data/pd-10002 && sudo cp -r /tidb-bench/copy/pd-10002 /tidb-bench/data
sudo chmod -R 777 /tidb-bench
echo "restore tikv ..."
ssh ${name}@${1} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data && sudo chmod -R 777 /tidb-bench" &
ssh ${name}@${2} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data && sudo chmod -R 777 /tidb-bench" &
ssh ${name}@${3} "sudo rm -rf /tidb-bench/data/tikv-10004 && sudo cp -r /tidb-bench/copy/tikv-10004 /tidb-bench/data && sudo chmod -R 777 /tidb-bench" &

for pid in $(jobs -p)
do
    wait $pid
    if [ $? -eq 0 ]; then
        echo "restore finished once"
    else
        echo "restore failed"
    fi
done