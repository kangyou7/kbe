#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

#USAGES $# 1 "<install path> check text"

for H in $(cat $CONF_DIR/hosts|grep JOB:worker|grep SETTED:E|awk '{print $2}')
do
	echo -ne $BLUE"Set k8s node's label for ${NC}[ ${RED}$H${NC} ] : " 
#	AA=$(kubectl get nodes --show-labels |grep $H| awk '{print $6}'|sed "s/,/\n/g"|grep dsaas-|sed "s/=true//g"|awk '{printf $1","}')
#	AA=${AA:0:$(expr ${#AA} - 1)}

	NODE_NAME=$(kubectl get nodes |grep $H| awk '{print $1}')
	
	BB=$(cat conf/hosts|grep JOB:worker|grep $H|awk '{for( II=1;II<=NF;II++){if( substr($II,0,3) == "TAG"){ print $II}}}'|cut -d':' -f2)
	echo -e ${GREEN}"$BB"${NC}
	
	for LAB in $(echo $BB|sed "s/,/\n/g")
	do
		kubectl label --overwrite node $NODE_NAME $LAB=true
	done
done