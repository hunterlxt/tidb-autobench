# tidb-autobench 中文版本

一套用于测试基于 tikv 集群的循环 Bench 的工具集，在项目根目录直接执行 `./tidb-autobench.sh <sub-command>` 查看各自具体的使用方法。建议按照下列顺序依次运行。

## 子命令概述
* **config-ssh**: （可选）使用该工具可以方便地在你的笔记本为集群配置互信，以实现中控机免密 ssh 到其它机器。
* **install-tools**: （可选）安装其他子命令需要的前置软件，诸如 tiup，haproxy 等，你也可以自行安装。
* **create-fs**: （可选）在目标 ip 机器上对指定的盘进行格式化并挂载到特定测试目录，你可以不通过该工具完成，但自行配置目录时注意集群始终部署在系统根目录下的 /tidb-autobench。
* **run-haproxy**: 在执行机器后台启动 haproxy 服务，该命令必须执行，因为测试客户端只访问中控机的固定 mysql 端口。
* **deploy-prepare**: 部署 TiDB 集群并灌入预热数据集，最后进行物理文件（pd，tikv）备份到指定目录。导入数据前务必查看编辑默认的 custom-prepare.sh 文件，使生成的数据集尺寸符合你的需要。根据是否开启 haproxy 注意端口配置。不支持单机多实例混布。
* **run-bench**: 运行一系列的性能测试，运行前务必查看编辑默认的 custom-run.sh 文件，支持自定义每轮测试的参数，tikv 执行文件，tikv 配置等。可以参照已有的命令自定义需要的参数，运行结果在 logs 目录。暂时仅支持 tpcc 模式

# tidb-autobench English Version

A set of tools that simplifies TiDB's circular Bench. You can directly execute subcommands to view their specific usage methods. It is recommended to run in the following order.

## Subcommand overview
* **config-ssh**: Use this tool to easily configure to achieve password-free ssh from the central control machine to all machines, and you can also complete the ssh password-free operation by yourself
* **install-tools**: Install pre-installed software required by other subcommands, such as tiup, haproxy, etc.
* **create-fs**: Conveniently mount the file system to the specified directory on the target machine, you can do it without this tool, but when configuring the directory yourself, pay attention to always write the data to /tidb-autobench
* **run-haproxy**: Start the haproxy service in the background of the execution machine, suitable for deploying multiple tidb-servers
* **deploy-prepare**: Deploy the TiDB cluster and inject the pre-warmed data set, and finally perform physical file backup. Before importing data, be sure to review and edit the default custom-prepare.sh file to make the size of the generated dataset meet your needs. Pay attention to the port configuration according to whether haproxy is turned on
* **run-bench**: Run a series of performance tests. Be sure to check and edit the default custom-run.sh file before running. It temporarily supports customizing each round of test time, tikv file, and tikv configuration. You can refer to the existing ones. Command custom parameters. The result of the operation is in the targets directory. Temporarily only supports tpcc mode
