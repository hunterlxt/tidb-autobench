#!/bin/bash
set -eu

name=${4}

ulimit -n 524288

# workload commands (custom your prepare method)
/home/${name}/.go-tpc/bin/go-tpc tpcc -P 10000 -T 64 --warehouses 5000 prepare
echo "prepare finish"
sleep 600
echo "pd prepare ..."
tiup cluster stop test -y
sudo mkdir -p /tidb-bench/copy
sudo cp -r /tidb-bench/data/pd-10002 /tidb-bench/copy/
echo "tikv prepare ..."
ssh ${name}@${1} "sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy/"
ssh ${name}@${2} "sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy/"
ssh ${name}@${3} "sudo mkdir -p /tidb-bench/copy && sudo cp -r /tidb-bench/data/tikv-10004 /tidb-bench/copy/"
echo "tikv prepare done"