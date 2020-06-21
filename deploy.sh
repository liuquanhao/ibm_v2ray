#!/bin/bash

UUID=$(cat /proc/sys/kernel/random/uuid)
echo "uuid: " $UUID

git clone https://github.com/liuquanhao/ibm_v2ray
cd ./ibm_v2ray/v2ray_deploy
sed -i "s/id\": .*\"/id\": \"$UUID\"/g" ./v2ray/config.json
ibmcloud target --cf
ibmcloud cf install
ibmcloud cf push
