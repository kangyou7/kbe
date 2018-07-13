#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echoGREEN "get pending pods"
for POD_ in $(kubectl get --all-namespaces po | grep Pending | awk '{print $1"_"$2}')
do
	## get docker image name
	PODNS=$(echo $POD_|awk -F_ '{print $1}')
	PODNM=$(echo $POD_|awk -F_ '{print $2}')
	DINM=$(kubectl describe --namespace=$PODNS po $PODNM | grep Image|awk '{print $2}')

	## pull docker image
	for D in $DINM
	do
		## backup docker image
		$BIN_DIR/maintain-backup-image.sh $D $DIB_NEW_DIR
	done
done