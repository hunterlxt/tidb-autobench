# tikv-bench-autopilot

## 准备
1. 确保 user 在中控机到 tikv 节点实现了免密 ssh 登录，该 user 应获取 sudo 权限
2. 确保 /etc/ssh/ssh_config 里 StrictHostKeyChecking 为 no
3. 自定义 workload 流程，默认为 go-tpc, 对应 workload 脚本在 pre-tpcc.sh 和 run.sh 里（自定义 # workload commands 相关代码）
4. 自定义 tikv.toml 或者留空

## 安装工具（以ubuntu为例）
```
sudo apt update && sudo apt install tmux git sudo mysql-client sysbench -y && \
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/pingcap/go-tpc/master/install.sh | sh && \
curl https://tiup-mirrors.pingcap.com/install.sh | sh && \
git clone https://github.com/hunterlxt/tikv-bench-autopilot && cd tikv-bench-autopilot
```

## 运行
在 tidb 中控机进入 `tikv-bench-autopilot` 目录并开启 tmux 运行：
```
./run.sh <tidb_ip> <kvip_1> <kvip_2> <kvip_3> <tidb_device> <tikv_device> <file_sys_args> <user>
```
