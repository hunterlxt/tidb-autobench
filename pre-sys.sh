#!/bin/bash
set -eu

dev_tidb="${1}"
dev_tikv="${2}"
args="${3}"
ip1="${4}"
ip2="${5}"
ip3="${6}"
name=${7}

echo "pre-sys-tidb ..."
./pre-sys-tidb.sh ${dev_tidb}

echo "pre-sys-tikv ..."
scp pre-sys-tikv.sh ${name}@${ip1}:/home/${name}
scp pre-sys-tikv.sh ${name}@${ip2}:/home/${name}
scp pre-sys-tikv.sh ${name}@${ip3}:/home/${name}

ssh ${name}@${ip1} "sudo chmod 777 pre-sys-tikv.sh && sudo ./pre-sys-tikv.sh ${dev_tikv} ${args}" &
ssh ${name}@${ip2} "sudo chmod 777 pre-sys-tikv.sh && sudo ./pre-sys-tikv.sh ${dev_tikv} ${args}" &
ssh ${name}@${ip3} "sudo chmod 777 pre-sys-tikv.sh && sudo ./pre-sys-tikv.sh ${dev_tikv} ${args}" &

for pid in $(jobs -p)
do
    wait $pid
    if [ $? -eq 0 ]; then
        echo "pre-sys-tikv finished once"
    else
        echo "pre-sys-tikv failed"
    fi
done