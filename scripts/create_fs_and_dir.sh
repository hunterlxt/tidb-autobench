#!/bin/bash
set -eu

ip=${1}
user=${2}
pem=${3}
dev="/dev/${4}"

ssh -i ${pem} ${user}@${ip} "sudo mkfs.ext4 ${dev} &&
sudo mkdir -p /tidb-bench &&
sudo mount ${dev} /tidb-bench &&
sudo chmod -R 777 /tidb-bench
"

echo "=== Finished ==="
