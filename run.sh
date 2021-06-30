#!/bin/bash
set -eu

ip=${1}
ip1=${2}
ip2=${3}
ip3=${4}
dev_tidb=${5}
dev_tikv=${6}
file_sys_args=${7}
user=${8}
version="v5.0.0"

./pre-sys.sh ${dev_tidb} ${dev_tikv} ${file_sys_args} ${ip1} ${ip2} ${ip3} ${user}
./pre-cluster-config.sh ${ip} ${ip1} ${ip2} ${ip3} ${user}
tiup cluster deploy test ${version} config.yaml --user ${user} -y

scp tikv.toml ${user}@${ip1}:/tidb-bench/deploy/tikv-10004/conf
scp tikv.toml ${user}@${ip2}:/tidb-bench/deploy/tikv-10004/conf
scp tikv.toml ${user}@${ip3}:/tidb-bench/deploy/tikv-10004/conf
tiup cluster start test
# turn on clustered_index
sleep 1
echo "setting mysql ..."
mysql -u root -h 127.0.0.1 -P 10000 -e "set @@global.tidb_enable_clustered_index = ON"
./pre-tpcc.sh ${ip1} ${ip2} ${ip3} ${user}
# workload commands (custom your run method)
tiup cluster start test
/home/${user}/.go-tpc/bin/go-tpc tpcc -P 10000 -T 800 --warehouses 5000 --time 4h run > 800-threads.log
tiup cluster stop test -y
./restore-data.sh ${ip1} ${ip2} ${ip3} ${user}
tiup cluster start test
/home/${user}/.go-tpc/bin/go-tpc tpcc -P 10000 -T 200 --warehouses 5000 --time 4h run > 200-threads.log
tiup cluster stop test -y
./restore-data.sh ${ip1} ${ip2} ${ip3} ${user}
tiup cluster start test
/home/${user}/.go-tpc/bin/go-tpc tpcc -P 10000 -T 50 --warehouses 5000 --time 4h run > 50-threads.log
tiup cluster stop test -y