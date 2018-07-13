#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echoGREEN "send docker image"
for H in $(cat $CONF_DIR/hosts|grep JOB:worker|grep SETTED:E|awk '{print $1}')
do
	echoRED "Send & Load DI [ $H ]"
	scp $DIB_NEW_DIR/* $H:$DIB_NEW_DIR/
	### docker load
	ssh $H "$BIN_DIR/install-docker-image-load.sh $DIB_NEW_DIR"
done
