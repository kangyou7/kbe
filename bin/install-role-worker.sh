#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

if [ -f $CONF_DIR/rancher-server-url ] ; then 
	SVR_URL=$(cat $CONF_DIR/rancher-server-url)
else
	echo -e $RED"There is no $CONF_DIR/rancher-server-url file"$NC
	exit
fi

echo -e $BLUE"   5.1 Install Rancher Agent"$NC
docker run --rm \
	--privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /var/lib/rancher:/var/lib/rancher \
	-e CATTLE_DETECT_CLOUD_PROVIDER=false \
 rancher/agent:${RANCHER_AGENT_VER} \
	${SVR_URL}

sleep 20

reboot
		
#docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.9 http://10.178.144.16:8100/v1/scripts/BFB44A9EF2FFC99CB933:1514678400000:Ee1oLpsLYMT6VLeYhSaypWc4Dc