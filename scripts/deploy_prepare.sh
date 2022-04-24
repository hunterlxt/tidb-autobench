#!/bin/bash
set -eu

# only 1 pd server and all util deloyed on this node.
user=${1}
ver=${2}
pd=${3}
tidbs=${4}
tikvs=${5}
backup_dir=${6}

tikv_args=`echo ${tikvs} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`
function ssh_tikvs_to_backup() {
    for ip in $*
    do
        echo "tikv $ip backup ..."
        ssh ${user}@${ip} "sudo mkdir -p $backup_dir && sudo rm -rf $backup_dir && sudo mkdir -p $backup_dir && sudo cp -r /tidb-autobench/data/tikv-10000 $backup_dir" &
    done
}

./scripts/generate_tiup_config.sh $user $pd $tidbs $tikvs

tiup cluster deploy test $ver targets/config.yaml --user $user --ssh system -y
tiup cluster start test
sleep 5

# Set custom SQL variable
mysql -u root -h 127.0.0.1 -P 11000 -e "set @@global.tidb_enable_clustered_index = ON"

./custom-prepare.sh

echo "data prepare finish"
sleep 720


echo "pd $pd backup ..."
tiup cluster stop test -R tidb,pd,tikv -y
sudo mkdir -p $backup_dir
sudo rm -rf $backup_dir
sudo mkdir -p $backup_dir
sudo cp -r /tidb-autobench/data/pd-10002 $backup_dir

ssh_tikvs_to_backup $tikv_args

for pid in $(jobs -p)
do
    wait $pid
    mkdir -p logs
    if [ $? -eq 0 ]; then
        echo `date` >> logs/prepare.done.log
    else
        echo `date` >> logs/prepare.error.log
    fi
done

sleep 120

echo "=== Finished ==="
