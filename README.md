### 利用FISCO-BCOS-2.0_RC3搭建区块链环境——企业级构建机构节点安装包

##### 1.脚本说明
    init.sh ，a1b1.sh，a12b1c2.sh，a12b1c12.sh 脚本构建FISCO-BCOS 2.0的区块链节点环境
    无需按照官方逐步执行，通过脚本即可一步完成，实现不同场景的（FISCO-BCOS企业级）区块链环境的构建，一步构建完成并生成节点安装包，节点安装包内含有对应控制台配置、节点SDK证书等，启动后可直接操作控制台。
    注：安装包中的节点证书为官方提供的测试证书，生产环境需要自己单独制作。
##### 2.执行环境
    Linux系统
    JAVA8+
##### 3.下载文件与准备
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
     [下载地址](git clone https://github.com/FISCO-BCOS/generator.git)，用于配置证书及初始化机构节点目录
    console目录
    下载地址：https://github.com/FISCO-BCOS/console.git   ，节点操作控制台

##### 4.脚本执行说明
* sh init.sh  
环境依赖检查，在执行其它脚本前需保证该脚本执行全部通过，否则其他脚本无法执行。
* sh a1b1.sh    机构A名称  机构B名称
<br>构建两机构，每个机构两个节点，相同账本（群组1）的区块链环境，执行后的节点结构如下图所示：
![一个群组](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/_images/tutorial_step_1.png)
* sh a12b1c2.sh    机构B名称   机构B名称  机构C名称
<br>构建三机构，每个机构两个节点，两组账本的区块链环境，执行后的节点结构如下图所示：
![两个群组](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/_images/tutorial_step_2.png)
* sh a12b1c12.sh    机构B名称  机构B名称  机构B名称
<br>构建三机构，每个机构两个节点，两组账本的区块链环境，执行后的节点结构如下图所示：
![两个群组](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/_images/tutorial_step_3.png)
##### 5.构建后目录及说明
    5.1 dist目录 
        节点构建完成成功后，会在当前目录下生成dist目录，里面包含节点的运行安装安装包；同时，也会在 blockchainShell目录下生成解压后的机构节点安装包，可进行测试。
    5.2 控制台和sdk客户端证书
        在节点安装包和已解压的目录里面，已经存在节点控制台和sdk目录，无另需配置可直接使用。
