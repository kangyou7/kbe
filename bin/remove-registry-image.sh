#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

REGISTRY_URL="http://$LOCAL_REGISTRY"
LEVEL="/test"
PROJECT_NAME=$1

USAGES $# 1 "<Project Name> [-,infra,test,stage,prod]\n Ex. $0 dsp-svc-control test\n If you want to remove image on / write - on 2nd parameter"

if [ $# -gt 1 ] ; then
   LEVEL="/"$2
fi
if [ $2 == "-" ] ; then
   LEVEL=""
fi

TAGS=$(curl -s ${REGISTRY_URL}/v2${LEVEL}/${PROJECT_NAME}/tags/list|jq '.tags'|grep -v "\["|grep -v "\]"|sort|sed "s/\ \ \"//g"|sed "s/\",//g")

for TAG in $TAGS
do
   TAG=$(echo $TAG|sed "s/\"//g")
   echo -n "Delete ${PROJECT_NAME} [ $TAG ] (y/n) : "
   read inp
   if [ ${#inp} -gt 0 ] ; then
      if [ $inp == "y" ] ; then
         curl -v -X GET -H "Accept: application/vnd.docker.distribution.manifest.v2+json" ${REGISTRY_URL}/v2${LEVEL}/${PROJECT_NAME}/manifests/${TAG} 2> /tmp/digest.registry 1> /dev/null

         DIGEST=$(grep Docker-Content-Digest /tmp/digest.registry | awk '{print $3}')

         echo $DIGEST
         SND=$(echo -e "curl -v -X DELETE ${REGISTRY_URL}/v2${LEVEL}/${PROJECT_NAME}/manifests/${DIGEST}")
         echo $SND > /tmp/runcurl
         dos2unix /tmp/runcurl
         /bin/bash /tmp/runcurl
      fi
   fi
done

