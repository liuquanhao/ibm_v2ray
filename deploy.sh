#!/bin/bash


cat >  ./v2ray_deploy/manifest.yml  << EOF
applications:
  - path: .
    name: liuxu-v2ray 
    random-route: true
    memory: 256M
EOF

git clone https://github.com/liuquanhao/ibm_v2ray

cd ./ibm_v2ray/v2ray_deploy
UUID=$(cat /proc/sys/kernel/random/uuid)
sed -i "s/id\": .*\"/id\": \"$UUID\"/g" ./v2ray/config.json
ibmcloud target --cf
ibmcloud cf install
ibmcloud cf push
