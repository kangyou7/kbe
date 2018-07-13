#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -e $BLUE"Install Gitlab-ce"$NC
	docker run -d \
		--restart=always \
		--name=rancher-gitlab \
		--env GITLAB_OMNIBUS_CONFIG="external_url '${GITLAB_URL}'; gitlab_rails['lfs_enabled'] = true;" \
		-v ${GITLAB_CONF_DIR}:/etc/gitlab \
		-v ${GITLAB_DATA_DIR}:/var/opt/gitlab \
		-v ${GITLAB_LOG_DIR}:/var/log/gitlab \
		-p ${GITLAB_WEB_PORT}:${GITLAB_WEB_PORT} \
	gitlab/gitlab-ce:${GITLAB_VER}