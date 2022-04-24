set -eu

user=${1}
backup=${2}
tikvs=${3}

# Here are 2 template scripts.
# You should pass the directory of the tikv config. (file name always be `tikv.toml`)
# mysql port always be 11000 (ref run-haproxy)
./scripts/run_tpcc_bench.sh $user $backup $tikvs "/home/ubuntu/tikv-server" "config/v1" "tpcc --port 11000 --warehouses 2000 -T 100 --time 1h run"
./scripts/run_tpcc_bench.sh $user $backup $tikvs "/home/ubuntu/tikv-server" "config/v2" "tpcc --port 11000 --warehouses 2000 -T 200 --time 1h run"
