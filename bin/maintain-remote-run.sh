#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

USAGES $# 2 "<FILTER> <COMMAND>\n Ex. $0 \"grep JOB:worker|grep SETTED:E\" \"echo hostname\" "
FILTER=$1
CMD=$2

echoGREEN "Remote Run"
for H in $(cat $CONF_DIR/hosts|${FILTER}|awk '{print $1}')
do
	echoRED "Remote Execute (${CMD}) on [ $H ]"
	ssh $H "$CMD"
done
