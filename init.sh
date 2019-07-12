#!/bin/bash

export user_check=$1

# handle check env
if [ "$1" = "check" ];then
 cd generator
 sh ./scripts/install.sh > tmpOut.log
 result=$(cat tmpOut.log)
else
 echo parm is null !
 exit 1
fi

if [ `grep -c "successful" tmpOut.log` -eq '1' ]; then 
 echo "check successful!"
else 
 echo $result
 exit 1 
fi
echo $result
rm -rf tmpOut.log

# download fisco-bcos
./generator --download_fisco ./meta
./meta/fisco-bcos -v

echo check ok 


