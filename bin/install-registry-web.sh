#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -e $BLUE"Install Registry Web UI"$NC
	docker run -d \
		--restart=always \
		--name=registry-web \
		-p ${REGISTRY_WEB_PORT}:8080 \
		--link ${REGISTRY_NAME} \
		-e REGISTRY_URL=${REGISTRY_URL} \
		-e REGISTRY_NAME=${REGISTRY_NAME} \
	hyper/docker-registry-web