#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -e $BLUE"Install PlantUML"$NC
	docker run -d \
		--restart=always \
		--name=plantuml \ 
		-p ${PLANTUML_PORT}:8080 \
	plantuml/plantuml-server:jetty