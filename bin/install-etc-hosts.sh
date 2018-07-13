#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

cat $CONF_DIR/hosts|awk -v POS=${HOSTNAME_POST} '{print $1"\t"$2"."POS}' >> /etc/hosts
cat $CONF_DIR/hosts|awk -v POS=${HOSTNAME_POST} '{print $1"\t"$2"."POS}' >> /etc/cloud/templates/hosts.redhat.tmpl