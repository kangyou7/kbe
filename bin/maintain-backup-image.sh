#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

if [ $# -lt 1 ] ; then
   echo "Usages: $0 <Docker Image + TAG> [Backup Directory]"
   echoGREEN "ex> $0 registry.secuiot/infra/elasticsearch:6.1.1"
   exit
fi

if [ $# -eq 2 ] ; then
	DIB_NEW_DIR=$2
fi
SURL=$1
IMGNM=$(echo $SURL | sed "s/\//-/g"|sed "s/:/./g").tar.gz

echo -ne "Pull ${GREEN}$SURL${NC}"
docker pull $SURL

echo -ne "Backup ${RED}$SURL${NC} to ${GREEN}$IMGNM${NC}"
docker save $SURL |gzip > ${DIB_NEW_DIR}/$IMGNM
