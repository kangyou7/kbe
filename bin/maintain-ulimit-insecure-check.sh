#!/bin/bash

echo "System Limit & insecure Registry Setup Value"
ssh $1 "ulimit -n;docker info|grep secuiot;sestatus"

echo "System Limit & Docker Setup file's contents"

ssh $1 "cat /etc/security/limits.conf|tail -2;cat /etc/docker/daemon.json;cat /etc/sysconfig/selinux"

echo -n "Do you want a Reboot this Host [$1]? (y/n) "
read YN
if [ $YN == "y" ] ; then
	ssh $1 "reboot"
fi
