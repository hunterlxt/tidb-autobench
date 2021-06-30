#!/bin/bash
set -eu

# ./pre-sys-tidb.sh nvme0n1

dev="/dev/${1}"
echo "${dev}"
sudo mkdir -p /tidb-bench
sudo chmod -R 777 /tidb-bench
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys