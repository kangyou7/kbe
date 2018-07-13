#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -e $BLUE"Install Registry"$NC
docker run -d \
	--restart=always \
	--name=${REGISTRY_NAME} \
	-v ${REGISTRY_DIR}:/var/lib/registry \
	-p ${REGISTRY_PORT}:5000 \
	-e REGISTRY_STORAGE_DELETE_ENABLED=true \
registry:${REGISTRY_VER}
