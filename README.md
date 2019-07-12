 h1 利用FISCO-BCOS-2.0_RC3搭建区块链环境——企业级构建机构节点安装包

1.脚本说明
init.sh ，a1b1.sh，a12b1c2.sh，a12b1c12.sh 脚本构建FISCO-BCOS 2.0的区块链节点环境
2.执行环境
Linux系统
JAVA8+
3.下载文件与准备
  3.1 拉取脚本
  https://github.com/weinan2087-blockchindeploy/blockchainShell.git
  3.2 脚本执行的目录结构
  blockchainShell
        |—— init.sh文件
        |—— a1b1.sh文件
        |—— a12b1c2.sh文件
        |—— generator目录
        |—— console 目录
   3.3 文件说明
  generator目录
        下载地址：git clone https://github.com/FISCO-BCOS/generator.git  ，用于配置证书及初始化机构节点目录
  console目录
         下载地址：https://github.com/FISCO-BCOS/console.git   ，节点操作控制台
