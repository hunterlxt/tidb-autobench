#!/bin/bash

# only 1 pd server and all util deloyed on this node.
user=${1}
pd=${2}
tidbs=${3}
tikvs=${4}

function get_node_config {
    echo "  - host: $1
    port: 10000
    status_port: 10001"
}

function generate() {
    for ip in $*
    do
        echo "`get_node_config ${ip}`" >> targets/config.yaml
    done
}

mkdir -p targets

echo "global:
  user: "${user}"
  ssh_port: 22
  deploy_dir: "/tidb-autobench/deploy"
  data_dir: "/tidb-autobench/data"
monitored:
  node_exporter_port: 10004
  blackbox_exporter_port: 10005
pd_servers:
  - host: $pd
    client_port: 10002
    peer_port: 10003
monitoring_servers:
  - host: $pd
    port: 10011
grafana_servers:
  - host: $pd
    port: 10010" > targets/config.yaml

tidb_args=`echo ${tidbs} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`

tikv_args=`echo ${tikvs} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`

echo "tidb_servers:" >> targets/config.yaml
generate $tidb_args
echo "tikv_servers:" >> targets/config.yaml
generate $tikv_args
