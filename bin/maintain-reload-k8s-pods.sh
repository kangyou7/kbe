#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echoGREEN "reload pods"
for POD_ in $(kubectl get --all-namespaces po | grep Pending | awk '{print $1"_"$2}')
do
	
	PODNS=$(echo $POD_|awk -F_ '{print $1}')
	PODNM=$(echo $POD_|awk -F_ '{print $2}')
	echoRED "Delete Pods [ $PODNS / $PODNM ] (this action will re-start pod)"
	kubectl delete --namespace=$PODNS po $PODNM
done