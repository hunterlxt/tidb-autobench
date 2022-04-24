set -eu

# custom here
# mysql port always be 11000 (ref run-haproxy)
tiup bench tpcc --port 11000 --warehouses 2000 -T 200 prepare
