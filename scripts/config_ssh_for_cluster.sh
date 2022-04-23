#!/bin/bash
set -eu

user=${1}
pem=${2}
pd_ip=${3}
ips=${4}
pem_name=$(basename $pem)

ips_args=`echo ${ips} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`
scp -i ${pem} ${pem} ${user}@${pd_ip}:/home/${user}
ssh -i ${pem} ${user}@${pd_ip} "echo "StrictHostKeyChecking no" >>  ~/.ssh/config"
ssh -i ${pem} ${user}@${pd_ip} "ssh-keygen"
pub_key=`ssh -i ${pem} ${user}@${pd_ip} "cat /home/${user}/.ssh/id_rsa.pub"`

function config_ssh_for_others() {
    for ip in $*
    do
        ssh -i ${pem} ${user}@${pd_ip} "ssh -i /home/${user}/${pem_name} ${user}@${ip} "echo "${pub_key}" >> /home/${user}/.ssh/authorized_keys""
    done
}

ssh -i ${pem} ${user}@${pd_ip} "echo "${pub_key}" >> /home/${user}/.ssh/authorized_keys"
config_ssh_for_others ${ips_args}

echo "=== Finished ==="
