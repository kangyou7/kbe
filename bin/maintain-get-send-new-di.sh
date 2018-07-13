#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

$BIN_DIR/maintain-get-pending-pods.sh

$BIN_DIR/maintain-send-docker-image.sh

$BIN_DIR/maintain-reload-k8s-pods.sh
