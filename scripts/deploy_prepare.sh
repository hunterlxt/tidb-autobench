#!/bin/bash
set -eu

# only 1 pd server and all util deloyed on this node.
user=${1}
ver=${2}
pd=${3}
tidbs=${4}
tikvs=${5}
backup_dir=${6}
port=${7}
bench_mode=${8}

./scripts/generate_tiup_config.sh

tiup cluster deploy test $ver targets/config.yaml --user $user -y
tiup cluster start test
sleep 5

# Set custom SQL variable
mysql -u root -h 127.0.0.1 -P 11000 -e "set @@global.tidb_enable_clustered_index = ON"

if [ $bench_mode = "tpcc" ];then
    tiup bench tpcc --port 11000 --warehouses 1200 -T 400 prepare
fi




/home/${name}/.go-tpc/bin/go-tpc tpcc -P 11000 -T 100 --warehouses 3000 prepare
echo "prepare finish"
sleep 600
echo "pd prepare ..."
tiup cluster stop test -y

sleep 60

tiup cluster stop test -y

sudo mkdir -p /tidb-copy/
sudo rm -rf /tidb-copy/
sudo mkdir -p /tidb-copy/
sudo cp -r /tidb-bench/data/pd-10002 /tidb-copy/

echo "tikv prepare ..."
ssh ${name}@${ip1} "sudo mkdir -p /tidb-bench/copy && sudo rm -rf /tidb-bench/copy && sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy" &
ssh ${name}@${ip2} "sudo mkdir -p /tidb-bench/copy && sudo rm -rf /tidb-bench/copy && sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy" &
ssh ${name}@${ip3} "sudo mkdir -p /tidb-bench/copy && sudo rm -rf /tidb-bench/copy && sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy" &
echo "tikv prepare done"

for pid in $(jobs -p)
do
    wait $pid
    if [ $? -eq 0 ]; then
        echo "tpcc done" >> log.pre.tpcc
    else
        echo "tpcc error" >> log.pre.tpcc
    fi
done

sleep 120