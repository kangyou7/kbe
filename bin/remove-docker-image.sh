#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "Usages : $0 <grep keyword>"
	echo " Ex. $0 dsp-svc-control"
	exit
fi
KW=$1
docker images|grep $KW

echo -n "This Will Remove all image except latest 1 image. It's Correct? (y/n) "
read AA
if [ $AA == "y" ] ; then
   docker rmi -f $(docker images|grep ${KW}|tail -$(docker images|grep ${KW}|wc -l|xargs expr -1 +)|awk '{print $3}')
fi
