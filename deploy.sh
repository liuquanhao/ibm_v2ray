#!/bin/bash

## 环境变量
IBM_CLI_BAG=ibmcloud.tar.gz
V2RAY_BAG=v2ray-linux-64.zip
IBM_CLI_URL=https://clis.cloud.ibm.com/download/bluemix-cli/1.1.0/linux64/archive
V2RAY_URL=https://github.com/v2ray/v2ray-core/releases/download/v4.25.0/${V2RAY_BAG}
UUID=$(cat /proc/sys/kernel/random/uuid)

echo "设置IBM环境..."
read -p "请输入你的应用名称：" IBM_APP_NAME
read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
if [ -z "${IBM_MEM_SIZE}" ];then
    IBM_MEM_SIZE=256
fi
read -p "请输入你需要部署的端口（范围：1024-65535，默认8080)：" IBM_APP_PORT
if [ -z "${IBM_APP_PORT}" ];then
    IBM_APP_PORT=8080
fi
echo "应用名称：${IBM_APP_NAME}"
echo "内存大小：${IBM_MEM_SIZE}"
echo "部署端口：${IBM_APP_PORT}"
echo "配置完成..."

echo "初始化部署环境..."
git clone -q https://github.com/liuquanhao/ibm_v2ray

echo "下载ibmcloud中..."
cd ./ibm_v2ray/
wget -qO ${IBM_CLI_BAG} ${IBM_CLI_URL}
tar xf ${IBM_CLI_BAG} 
rm ${IBM_CLI_BAG}

echo "下载v2ray中..."
cd ./v2ray_deploy/
wget -q ${V2RAY_URL}
unzip -q ${V2RAY_BAG} -d v2ray
rm ${V2RAY_BAG}

echo "初始化配置中..."
cat > manifest.yml  << EOF
applications:
  - path: .
    name: ${IBM_APP_NAME}
    random-route: true
    memory: ${IBM_MEM_SIZE}M
EOF
cat > v2ray/config.json << EOF
{
  "inbounds": [
    {
      "port": ${IBM_APP_PORT},
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
	    "id": "${UUID}",
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "network":"ws"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
ibmcloud target --cf
ibmcloud cf install
ibmcloud cf push
echo "*******************************"
echo "将这个v2ray uuid设置到你的客户端: " ${UUID}
echo "*******************************"
echo "部署完成"
