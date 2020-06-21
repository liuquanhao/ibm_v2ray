#!/bin/bash

git clone https://github.com/liuquanhao/ibm_v2ray

cd ./ibm_v2ray/v2ray_deploy
ibmcloud target --cf
ibmcloud cf install
ibmcloud cf push
