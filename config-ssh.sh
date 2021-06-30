#!/bin/bash
set -eu

key=${1}
ip1=${2}
ip2=${3}
ip3=${4}
ip4=${5}
name=${6}

ssh -i ${key} ${name}@${ip1} "ssh-keygen"
pub_key=`ssh -i ${key} ${name}@${ip1} "cat /home/${name}/.ssh/id_rsa.pub"`
ssh -i ${key} ${name}@${ip2} "echo "${pub_key}" > /home/${name}/.ssh/authorized_keys"
ssh -i ${key} ${name}@${ip3} "echo "${pub_key}" > /home/${name}/.ssh/authorized_keys"
ssh -i ${key} ${name}@${ip4} "echo "${pub_key}" > /home/${name}/.ssh/authorized_keys"