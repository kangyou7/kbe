#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -en $BLUE"   6.1 Install mysql(w/ galera)"$NC
HN=$(cat /etc/hostname)
MYIP=$(cat $CONF_DIR/hosts|grep $HN|awk '{print $1}')
$BIN_DIR/install-mysql-galera.sh $MYIP

sleep 5

echo -en $BLUE"   6.2 DB DDL"$NC
docker exec -it rancher-mysql "mysql -u root -p${MYSQL_ROOT_PASS} -e \"CREATE DATABASE IF NOT EXISTS ${RANCHER_DB_NAME} COLLATE = 'utf8_general_ci' CHARACTER SET = 'utf8';
GRANT ALL ON ${RANCHER_DB_NAME}.* TO '${RANCHER_DB_USER}'@'%' IDENTIFIED BY '${RANCHER_DB_PASS}';
GRANT ALL ON ${RANCHER_DB_NAME}.* TO '${RANCHER_DB_USER}'@'localhost' IDENTIFIED BY '${RANCHER_DB_PASS}';\""

echo -en $BLUE"   6.3 Rancher Server"$NC
docker run -d \
		--restart=unless-stopped \
		--name rancher-server \
		-e CATTLE_PROMETHEUS_EXPORTER=true \
		-p ${RANCHER_PORT}:8080 -p 9108:9108 \
		--link rancher-mysql:${RANCHER_DB_HOST} \
	rancher/server:${RANCHER_SERVER_VER} \
		--db-host ${RANCHER_DB_HOST} \
		--db-port ${RANCHER_DB_PORT} \
		--db-user ${RANCHER_DB_USER} \
		--db-pass ${RANCHER_DB_PASS} \
		--db-name ${RANCHER_DB_NAME}
