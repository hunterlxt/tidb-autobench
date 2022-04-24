#!/bin/bash
set -eu

user=${1}
conf=${2}
bin=${3}
backup_dir=${4}
tikvs=${5}

tikv_args=`echo ${tikvs} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`
function scp_to_tikvs() {
    for ip in $*
    do
        echo "tikv $ip scp ..."
        scp ${conf} ${user}@${ip}:/tidb-autobench/deploy/tikv-10000/conf
        scp ${bin} ${user}@${ip}:/tidb-autobench/deploy/tikv-10000/bin
        echo "restore tikv $ip bench data ..."
        ssh ${user}@${ip} "sudo rm -rf /tidb-autobench/data/tikv-10000 && sudo cp -r ${backup_dir}/tikv-10000 /tidb-autobench/data/ && sudo chmod -R 777 /tidb-autobench" &
    done
}

echo "restore pd ..."
sudo rm -rf /tidb-autobench/data/pd-10002 && sudo cp -r ${backup_dir}/pd-10002 /tidb-autobench/data
sudo chmod -R 777 /tidb-autobench
echo "restore pd done"

scp_to_tikvs $tikv_args

for pid in $(jobs -p)
do
    wait $pid
    mkdir -p logs
    if [ $? -eq 0 ]; then
        echo `date` >> logs/restore.done.log
    else
        echo `date` >> logs/restore.error.log
    fi
done
