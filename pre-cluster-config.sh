#!/bin/bash

name=${5}

echo "
global:
  user: "${name}"
  ssh_port: 22
  deploy_dir: "/tidb-bench/deploy"
  data_dir: "/tidb-bench/data"
monitored:
  node_exporter_port: 10020
  blackbox_exporter_port: 10021
pd_servers:
  - host: ${1}
    client_port: 10002
    peer_port: 10003
tidb_servers:
  - host: ${1}
    port: 10000
    status_port: 10001
tikv_servers:
  - host: ${2}
    port: 10004
    status_port: 10005
  - host: ${3}
    port: 10004
    status_port: 10005
  - host: ${4}
    port: 10004
    status_port: 10005
monitoring_servers:
  - host: ${1}
    port: 10011
grafana_servers:
  - host: ${1}
    port: 10010
" > config.yaml