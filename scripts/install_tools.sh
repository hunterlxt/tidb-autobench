#!/bin/bash
set -eu

cmd=$1

if [ $cmd != "apt" ] && [ $cmd != "yum" ];then
    echo "Warn: only support apt and yum"
    exit 1
fi

if [ $cmd = "apt" ]; then
    sudo apt install -y sysbench tmux git mysql-client curl vim wget unzip
fi

if [ $cmd = "yum" ]; then
    sudo yum install -y sysbench tmux git mysql curl vim wget unzip
fi

curl https://tiup-mirrors.pingcap.com/install.sh | sh
mkdir - p targets
wget https://github.com/haproxy/haproxy/archive/refs/tags/v2.5.0.zip -P targets
unzip targets/v2.5.0.zip -d targets
cd targets/haproxy-2.5.0
make clean
make -j 16 TARGET=linux-glibc
sudo echo 'export PATH=/app/haproxy/bin:$PATH' >> /etc/profile
sudo make install
cd ../..

echo "=== Finished ==="