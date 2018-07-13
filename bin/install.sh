#!/bin/bash

# Install PaaS by Rancher-K8S (via Docker)

if [ $(whoami) != "root" ] ; then
	echo "MUST run on root user OR execute with 'sudo' command"
	exit
fi

if [ $# -lt 2 ] ; then
	echo "Usages : sudo $0 <Install Path> <master/master2/worker/resource>"
	exit
else
	INST_PATH=$1
fi

OPT=$2

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color


for H in $(cat $CONF_DIR/hosts |grep "JOB:"$OPT|awk '{print $1}')
do

	$BIN_DIR/install-remote.sh $INST_PATH $H $OPT O

done
