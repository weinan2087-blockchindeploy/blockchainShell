#!/bin/bash

# 1. check catalog
if [ ! -d "console" ]; then
    echo error ! not a console directory in `pwd`
    exit 1
fi
if [ ! -d "generator" ]; then
    echo error ! not a generator directory in `pwd`
    exit 1
fi

# handle check env
cd generator
sh ./scripts/install.sh > tmpOut.log
result=$(cat tmpOut.log)

if [ `grep -c "successful" tmpOut.log` -eq '1' ]; then 
 echo "check successful!"
else 
 echo $result
 exit 1 
fi
echo $result
rm -rf tmpOut.log

# download fisco-bcos
if [ ! -f "meta/fisco-bcos" ]; then
    ./generator --download_fisco ./meta
    ./meta/fisco-bcos -v
fi

if [ $? != 0 ];then
 echo "check env Failed! "
 exit 1
else
 echo "check env success! "
 exit 0
fi
