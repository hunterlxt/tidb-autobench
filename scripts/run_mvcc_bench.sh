#!/bin/bash
set -eu

ip1=${1}
ip2=${2}
ip3=${3}
user=${4}
bin_path=${5}
ver=${6}
time=${7}
thread=${8}

./restore-data.sh ${ip1} ${ip2} ${ip3} ${user} "tomls/${ver}/tikv.toml" ${bin_path}
tiup cluster start test
sleep 60
/home/${user}/.go-tpc/bin/go-tpc tpcc -P 11000 -T ${thread} --warehouses 3000 --time "${time}" run > 300-${time}-${ver}.log
tiup cluster stop test -R tidb,pd,tikv -y