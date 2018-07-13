#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echoGREEN "send config/bin file"
for H in $(cat $CONF_DIR/hosts|grep JOB:worker|grep SETTED:E|awk '{print $1}')
do
	echoRED "Send Scripts & Config [ $H ]"
	scp -q $BIN_DIR/* $H:$BIN_DIR/
	scp -q $CONF_DIR/* $H:$CONF_DIR/
done
