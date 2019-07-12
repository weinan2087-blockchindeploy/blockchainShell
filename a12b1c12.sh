#!/bin/bash

#########################################
###  [ orga，orgb，orgc，12，1，12 ]  ###
#########################################

export_a_ip=127.0.0.1
export_a0_p2p_port=30300
export_a0_channel_port=20200
export_a0_rpc_port=8545
export_a1_p2p_port=30301
export_a1_channel_port=20201
export_a1_rpc_port=8546

export_b_ip=127.0.0.1
export_b0_p2p_port=30302
export_b0_channel_port=20202
export_b0_rpc_port=8547
export_b1_p2p_port=30303
export_b1_channel_port=20203
export_b1_rpc_port=8548

export_c_ip=127.0.0.1
export_c0_p2p_port=30304
export_c0_channel_port=20204
export_c0_rpc_port=8549
export_c1_p2p_port=30305
export_c1_channel_port=20205
export_c1_rpc_port=8550


# 1. check param 
if [ ! -n "$1" ] ;then
    error ! echo first parameter cannot be null 
    exit 1
fi
if [ ! -n "$2" ] ;then
    error ! echo second parameter cannot be null 
    exit 1
fi
if [ ! -n "$3" ] ;then
    error ! echo third parameter cannot be null 
    exit 1
fi
if [ ! -d "console" ]; then
    echo error ! not a console directory in `pwd`
    exit 1
fi
if [ ! -d "generator" ]; then
    echo error ! not a generator directory in `pwd`
    exit 1
fi

# 2. generator orga or orgb
cp -r generator $1 && cp -r generator $2
echo generator $1 $2 catalog ok

# 3. init chain ca
cd generator
./generator --generate_chain_certificate ./dir_chain_ca
echo init ca ok

# 3.1 generator orga ca
./generator --generate_agency_certificate ./dir_$1_ca ./dir_chain_ca $1
cp ./dir_chain_ca/ca.crt ./dir_$1_ca/$1/agency.crt ./dir_$1_ca/$1/agency.key ../$1/meta

# 3.2 generator orgb ca
./generator --generate_agency_certificate ./dir_$2_ca ./dir_chain_ca $2
cp ./dir_chain_ca/ca.crt ./dir_$2_ca/$2/agency.crt ./dir_$2_ca/$2/agency.key ../$2/meta
echo init $1 $2 ok

# 4. config node_deployment.ini
cd ../$1
sed -i "s/127.0.0.1/$export_a_ip/" conf/node_deployment.ini
sed -i "s/30300/$export_a0_p2p_port/" conf/node_deployment.ini
sed -i "s/20200/$export_a0_channel_port/" conf/node_deployment.ini
sed -i "s/8545/$export_a0_rpc_port/"   conf/node_deployment.ini
sed -i "s/30301/$export_a1_p2p_port/" conf/node_deployment.ini
sed -i "s/20201/$export_a1_channel_port/" conf/node_deployment.ini
sed -i "s/8546/$export_a1_rpc_port/"   conf/node_deployment.ini
cd ../$2
sed -i "s/127.0.0.1/$export_b_ip/" conf/node_deployment.ini
sed -i "s/30300/$export_b0_p2p_port/" conf/node_deployment.ini
sed -i "s/20200/$export_b0_channel_port/" conf/node_deployment.ini
sed -i "s/8545/$export_b0_rpc_port/"   conf/node_deployment.ini
sed -i "s/30301/$export_b1_p2p_port/" conf/node_deployment.ini
sed -i "s/20201/$export_b1_channel_port/" conf/node_deployment.ini
sed -i "s/8546/$export_b1_rpc_port/"   conf/node_deployment.ini
echo init $1 $2 node_deployment ok

# 5. generator orga(God)/orgb config file
# 5.1 generator orga files
cd ../$1
./generator --generate_all_certificates ./$1_node_files
echo generator $1 config files ok
# copy orga files to meta of orgb
cp ./$1_node_files/peers.txt ../$2/meta/peers_$1.txt
echo copy $1 files to meta of $2  ok

# 5.2 generator orgb files
cd ../$2
./generator --generate_all_certificates ./$2_node_files
echo generator $2 config files ok
cp ./$2_node_files/cert*.crt ../$1/meta/
cp ./$2_node_files/peers.txt ../$1/meta/peers_$2.txt
echo copy $2 files to meta of $1  ok

# 5.3 generator orga god file
cd ../$1
sed -i "s/127.0.0.1:30300/$export_a_ip:$export_a0_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30301/$export_a_ip:$export_a1_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30302/$export_b_ip:$export_b0_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30303/$export_b_ip:$export_b1_p2p_port/"	conf/group_genesis.ini
./generator --create_group_genesis ./group
echo $1 create_group_genesis ok

# 5.4 copy $1 god file to meta of $2
cp ./group/group.1.genesis ../$2/meta
echo copy $1 god file to meta of $2 ok

# 6. generator nodes package
# 6.1 generator nodes package for orga
./generator --build_install_package ./meta/peers_$2.txt ./$1_nodes_package  && ls -rlt
echo build_install_package $1 ok

# 6.2 generator nodes package for orgb
cd ../$2
./generator --build_install_package ./meta/peers_$1.txt ./$2_nodes_package  && ls -rlt
echo build_install_package $2 ok

# 7. generator orgc catalog
cd ..
cp -r generator $3
echo generator $3 catalog ok
# 7.1 generator orgc ca
cd generator
./generator --generate_agency_certificate ./dir_$3_ca ./dir_chain_ca $3  && ls -rlt
echo generator orgc ca ok

# 7.2 copy orgc files to meta of orga
cp ./dir_chain_ca/ca.crt ./dir_$3_ca/$3/agency.crt ./dir_$3_ca/$3/agency.key ../$3/meta/
echo copy orgc files to meta of orga ok

# 7.3 copy orga peers.txt and ca to meta of orgc
cd ../$1
cp ./$1_node_files/cert*.crt ../$3/meta/
cp ./$1_node_files/peers.txt ../$3/meta/peers_$1.txt

# 7.3 config orgc node_deployment.ini
cd ../$3
sed -i "s/127.0.0.1/$export_c_ip/"		conf/node_deployment.ini
sed -i "s/_id=1/_id=2/"				conf/node_deployment.ini
sed -i "s/30300/$export_c0_p2p_port/"		conf/node_deployment.ini
sed -i "s/20200/$export_c0_channel_port/"	conf/node_deployment.ini
sed -i "s/8545/$export_c0_rpc_port/"		conf/node_deployment.ini
sed -i "s/30301/$export_c1_p2p_port/"		conf/node_deployment.ini
sed -i "s/20201/$export_c1_channel_port/"	conf/node_deployment.ini
sed -i "s/8546/$export_c1_rpc_port/"		conf/node_deployment.ini
echo config orgc node_deployment.ini ok

# 7.4 generator orgc config files
./generator --generate_all_certificates ./$3_node_files

# 7.5 copy orgc peers.txt to meta of orga
cp ./$3_node_files/peers.txt ../$1/meta/peers_$3.txt
echo generator orgc config files ok   copy orgc peers.txt to meta of orgac ok

echo  generator group 2 god file
sed -i "s/_id=1/_id=2/"						conf/group_genesis.ini
sed -i "s/127.0.0.1:30300/$export_a_ip:$export_a0_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30301/$export_a_ip:$export_a1_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30302/$export_c_ip:$export_c0_p2p_port/"	conf/group_genesis.ini
sed -i "s/127.0.0.1:30303/$export_c_ip:$export_c1_p2p_port/"	conf/group_genesis.ini
echo update port for group_genesis.ini ok 
./generator --create_group_genesis ./group

# 7.6 copy orga group.2.genesis to meta of orga
cp ./group/group.2.genesis ../$1/meta/
echo copy orga group.2.genesis to meta of orga ok

# 7.7 generator nodes package for orgc
./generator --build_install_package ./meta/peers_$1.txt ./$3_nodes_package
echo build_install_package $3 ok

echo add orga nodes to gruop 2
cd ../$1
./generator --add_group ./meta/group.2.genesis ./$1_nodes_package
./generator --add_peers ./meta/peers_$3.txt ./$1_nodes_package
echo add orga nodes to gruop 2 ok

# 8.add group 1 god file to orgc
./generator --add_group ./group/group.1.genesis ../$3/$3_nodes_package

# 9.console config 
# 9.1 copy console to org catalog
cd ../
cp -r console ./$1 && cp -r console ./$2 && cp -r console ./$3
# 9.2 generator orgs sdk and copy it to console catalog
cd $1 && ./generator --get_sdk_file ./sdk
cp sdk/applicationContext.xml sdk/ca.crt sdk/node.crt sdk/node.key console/conf/
cd ../$2 && ./generator --get_sdk_file ./sdk
cp sdk/applicationContext.xml sdk/ca.crt sdk/node.crt sdk/node.key console/conf/
cd ../$3 && ./generator --get_sdk_file ./sdk
cp sdk/applicationContext.xml sdk/ca.crt sdk/node.crt sdk/node.key console/conf/
echo generator orgs sdk and copy it to console catalog ok

# 10. generator nodes install package
cd ../
date_str=`date +%Y%m%d%M`
tar -zcvf $1_nodes_installPackage_$date_str.tar.gz ./$1/$1_nodes_package
tar -zcvf $2_nodes_installPackage_$date_str.tar.gz ./$2/$2_nodes_package
tar -zcvf $3_nodes_installPackage_$date_str.tar.gz ./$3/$3_nodes_package
if [ ! -d "dist" ]; then
	mkdir dist
fi 
mv $1_nodes_installPackage_$date_str.tar.gz $2_nodes_installPackage_$date_str.tar.gz $3_nodes_installPackage_$date_str.tar.gz -t dist

if [ $? != 0 ];then
 echo "generator Failed! "
 exit 1
else
 echo "generator success! "
 exit 0
fi
