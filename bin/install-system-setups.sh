#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echo -e $BLUE"System Limits"$NC
echo -e "*\t\tsoft\tnofile\t200000\n*\t\thard\tnofile\t\t200000" >> /etc/security/limits.conf

echo -e $BLUE"SELINUX disabled"$NC
sed -i "s/SELINUX=permissive/SELINUX=disabled/g" /etc/sysconfig/selinux
sed -i "s/SELINUX=enforce/SELINUX=disabled/g" /etc/sysconfig/selinux

echo -e $BLUE"Docker insecure registry"$NC
sed -i "s/{}/{\n\t\"insecure-registries\"\: \[\"registry.secuiot\"\]\n}/g" /etc/docker/daemon.json
