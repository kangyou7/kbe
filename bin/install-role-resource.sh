#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -en $BLUE"   6.1 "
$BIN_DIR/install-gitlab-ce.sh

echo -en $BLUE"   6.2 "
$BIN_DIR/install-registry.sh

echo -en $BLUE"   6.3 "
$BIN_DIR/install-registry-web.sh

echo -en $BLUE"   6.4 "
$BIN_DIR/install-plantuml.sh

echo -e $BLUE"   6.5 Load Docker Image for INFRA"$NC
$BIN_DIR/install-docker-image-load.sh $DIB_INFRA_DIR
if [ $(docker images |grep -v REPOSITORY|grep registry.$HOSTNAME_POST|wc -l) -eq 0 ] ; then
	echo -e $RED" MUST Change TAG to registry.$HOSTNAME_POST"$NC
else
	echo -e $GREEN"Docker Infra Images Pushing to $REDregistry.$HOSTNAME_POST"$NC
	docker push $(docker images |grep registry.$HOSTNAME_POST|awk '{print $1":"$2}')
fi

echo -e $BLUE"   6.7 Install expect"$NC
cd $BASE_DIR/rpms-exp
yum localinstall -y *

echo -e $BLUE"   6.8 Install kubectl"$NC
cd $BASE_DIR/rpms-k8s
yum localinstall -y *

echo -e $BLUE"   6.9 NTP Server Setup"$NC
echo -e "server kr.pool.ntp.org\nserver time.bora.net\nserver time.kornet.net\n\nrestrict 10.178.0.0 mask 255.255.0.0 nomodify notrap" > /etc/ntp.conf
systemctl restart ntpd
