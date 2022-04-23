set -eu

user=${1}
port=${2}
tikvs=${3}
backup=${4}

./scripts/run-mvcc-bench.sh $user $port $tikvs $backup "/home/ec2-user/quota-bin/tikv-6.0-0325/tikv-server" "config/v1" 1h 200
./scripts/run-mvcc-bench.sh $user $port $tikvs $backup "/home/ec2-user/quota-bin/tikv-6.0-0325/tikv-server" "config/v2" 1h 100