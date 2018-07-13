#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

USAGES $# 2 "<Original URL> <NEW URL>\n Ex. $0 registry.secuiot registry.dsp\n  ${RED}DO NOT change name with '/'"

OURL=$1
NURL=$2

for T in $(docker images |grep -v REPOSITORY|grep $OURL|awk '{print $1":"$2}')
do
	NT=$(echo $T|sed "s/$OURL/$NURL/g")
	echo -e ${GREEN}${T}${NC}" TAG will Change to "${RED}$NT${NC}
	docker tag $T $NT
	echo "remove $T TAG"
	docker rmi $T
done