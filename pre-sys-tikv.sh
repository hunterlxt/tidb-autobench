#!/bin/bash
set -eu

dev="/dev/${1}"
args="${2}"

mkfs.ext4 ${dev}
mkdir -p /tidb-bench
mount -o ${args} ${dev} /tidb-bench