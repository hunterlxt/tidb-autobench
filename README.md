# tidb-autobench 中文版本

一套简化 TiDB 循环 Bench 的工具集，可以直接执行子命令以查看各自具体的使用方法。

## 子命令概述
* **install-tools**: 安装其他子命令需要的前置软件，诸如 tiup，haproxy 等
* **create-fs**: 在目标机器上方便地挂载文件系统到指定目录，你可以不通过该工具完成，但自行配置目录时注意数据始终写入 /tidb-autobench
* **config-ssh**: 使用该工具可以方便地配置以实现中控机免密 ssh 到所有机器
* **run-haproxy**: 在执行机器后台启动 haproxy 服务
* **deploy-prepare**: 部署 TiDB 集群并灌入预热数据集，最后进行物理文件备份。导入数据前务必查看编辑默认的 prepare-core.sh 文件，使生成的数据集尺寸符合你的需要。
* **run-bench**: 运行一系列的性能测试，运行前务必查看编辑默认的 bench-core.sh 文件，暂时支持自定义每轮测试时间，tikv 文件，tikv 配置。运行结果在 targets 目录。

## run-bench 命令
该命令需要编辑 bench-core.sh 文件，可以参照已有的命令自定义参数，暂时仅支持 mvcc 模式。


# tidb-autobench English Version

A set of tools that simplifies TiDB's circular Bench. You can directly execute subcommands to view their specific usage methods.

## Subcommand overview
* **install-tools**: Install the pre-installed software required by other subcommands, such as tiup, haproxy, etc.
* **create-fs**: Mount the file system to the specified directory on the target machine easily
* **config-ssh**: Use this tool to easily configure to achieve password-free ssh from the central control machine to all machines
* **run-haproxy**: start the haproxy service in the background of the execution machine
* **deploy-prepare**: Deploy the TiDB cluster and fill in the pre-warmed data set, and finally perform physical file backup. Before importing data, be sure to review and edit the default prepare-core.sh file to make the size of the generated dataset meet your needs.
* **run-bench**: Run a series of performance tests. Be sure to check and edit the default bench-core.sh file before running. It temporarily supports customizing each round of test time, tikv file, and tikv configuration. Bench result is placed in targets dir.

## run-bench command
This command needs to edit the bench-core.sh file, you can refer to the existing command to customize the parameters, temporarily only support mvcc mode.