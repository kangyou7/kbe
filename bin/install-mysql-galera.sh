#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

USAGES $# 1 "<HostIP> [Cluster Master IP]\n Ex. $0 10.178.144.22 10.178.144.16\n $RED Master server doesn't need ClusterIP\n non-Master server MUST need ClusterIP(=Master Server IP)$NC"
## Master server doesn't need ClusterIP
## non-Master server MUST need ClusterIP(=Master Server IP)


MAS=$1
SND=$2
HN=$(cat /etc/hostname)

docker run -d \
	--name rancher-mysql \
	-h $HN \
	-v ${MYSQL_HOST_DIR}:/var/lib/mysql \
	-p ${MYSQL_PORT}:3306 \
	-p 4567:4567 \
	-p 4568:4568 \
	-p 4444:4444 \
	-e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS} \
 erkules/galera \
 --wsrep-cluster-name=rancher-cluster \
 --wsrep-cluster-address=gcomm://$SND \
 --wsrep-node-address=$MAS