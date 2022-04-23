#!/bin/bash
set -eu

if [ $# = 0 ]; then
    echo "Please input right sub-command:

create-fs config-ssh run-haproxy deploy-prepare run-bench install-tools

FYI: https://github.com/hunterlxt/tidb-bench-bot"  >&2
    exit 1
fi

## user interface

if [ ${1} = "create-fs" ];then
    if [ $# != 5 ]; then
        echo "create fs and deloy dir from your laptop; usage: create-fs <ip> <user> <pem> <dev_name(eg:nvme0n1)>"
        exit 1
    fi
    ./scripts/create_fs_and_dir.sh $2 $3 $4 $5
else if [ ${1} = "config-ssh" ]; then
    if [ $# != 5 ]; then
        echo "config mutual ssh for cluster from your laptop; usage: config-ssh <user> <pem> <pd_ip> <ips(comma)>"
        exit 1
    fi
    ./scripts/config_ssh_for_cluster.sh $2 $3 $4 $5
else if [ ${1} = "run-haproxy" ]; then
    if [ $# != 3 ]; then
        echo "run haproxy in background; usage: run-haproxy <mysql_port> <tidb_ip_ports(comma)>"
        exit 1
    fi
    ./scripts/run_haproxy.sh $2 $3
else if [ ${1} = "deploy-prepare" ]; then
    if [ $# != 9 ]; then
        echo "deploy tidb cluster and prepare bench data; usage: deploy-prepare <user> <tidb_version> <pd_ip> <tidb_ips(comma)> <tikv_ips(comma)> <backup_dir> <mysql_port>"
        exit 1
    fi
    ./scripts/deploy_prepare.sh $2 $3 $4 $5 $6 $7
else if [ ${1} = "run-bench" ]; then
    if [ $# != 7 ]; then
        echo "run loop bench; usage: run-bench <user> <mysql_port> <tikv_ips(comma)> <backup_dir> <tpcc/sysbench>"
        exit 1
    fi
    ./scripts/run_bench.sh $2 $3 $4 $5 $6 $7
else if [ ${1} = "install-tools" ]; then
    if [ $# != 2 ]; then
        echo "install essential tools; usage: deploy-prepare <apt/yum>"
        exit 1
    fi
    ./scripts/install_tools.sh $2
else
    echo "Please input right sub-command. FYI: https://github.com/hunterlxt/tidb-bench-bot"  >&2
    exit 1
fi
fi
fi
fi
fi
fi