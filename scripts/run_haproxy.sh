#!/bin/bash

port=${1}
tidbs=${2}

function get_node_config {
    echo "   server tidb-${2} ${1}"
}

function generate() {
    num=1
    for ip in $*
    do
        echo "`get_node_config ${ip} ${num}`" >> targets/haproxy.cfg
        num=`expr $num + 1`
    done
}

mkdir -p targets

echo "global
   maxconn     4096
   nbthread    64 

listen tidb-cluster                        
   bind 0.0.0.0:${port}
   retries 10000                        
   timeout connect  300000s                     
   timeout client 300000s                   
   timeout server 300000s                     
   mode tcp                                
   balance leastconn" > targets/haproxy.cfg


tidb_args=`echo ${tidbs} | awk -F ',' '{for(i=1;i<=NF;i++) {
    print $i
}}'`

generate $tidb_args

sudo haproxy -f targets/haproxy.cfg &

echo "=== Finished ==="