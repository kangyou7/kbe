#!/bin/bash

if [ $# -lt 3 ] ; then
	echo "Usages : $0 <Install Path> <Host IP> <role> <O/X>"
	exit
else
	INST_PATH=$1
	HOST_IP=$2
	ROLES=$3
fi

if [ $4 != "O" ] ; then
	exit
fi

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

if [ $ROLES == "worker" ] ; then
	RSURL=$(cat $CONF_DIR/rancher-server-url)
fi

echo -e ${GREEN}"Install to Remote Host${NC}["${RED}$HOST_IP${NC}"]"

echo -e ${BLUE}"1.1. make install path"${NC}
ssh $HOST_IP "mkdir -p $INST_PATH"

echo -e ${BLUE}"1.2 Copy files"${NC}
scp -r $INST_PATH/basic-pack.tar $HOST_IP:$INST_PATH/ 
ssh $HOST_IP "cd $INST_PATH;tar xvf basic-pack.tar;rm -f basic-pack.tar"

echo -e ${BLUE}"2. Install rpms"${NC}
ssh $HOST_IP "cd $RPM_DIR;yum -y localinstall *"

echo -e ${BLUE}"3. Systemd Setup"${NC}
ssh $HOST_IP "systemctl enable docker;systemctl disable firewalld;systemctl stop firewalld;systemctl start docker;systemctl enable ntpd"

echo -e ${BLUE}"4.1 /etc/hosts Setup"${NC}
ssh $HOST_IP "$BIN_DIR/install-etc-hosts.sh"

echo -e ${BLUE}"4.2 NTP Setup"${NC}
ssh $HOST_IP "echo -e \"server $NTP_SERVER\" > /etc/ntp.conf"
ssh $HOST_IP "systemctl restart ntpd"

echo -e ${BLUE}"4.2 System Setup"${NC}
ssh $HOST_IP "$BIN_DIR/install-system-setups.sh"

echo -e ${BLUE}"5 Docker images Load"${NC}
ssh $HOST_IP "$BIN_DIR/install-docker-image-load.sh"

echo -e ${BLUE}"6. Install Host Role [ ${RED}$ROLES${BLUE} ]"${NC}
if [ $ROLES == "master" ] ; then
	ssh $HOST_IP "$BIN_DIR/install-role-master.sh"
elif [ $ROLES == "master2" ] ; then
	ssh $HOST_IP "$BIN_DIR/install-role-master2.sh"
elif [ $ROLES == "worker" ] ; then
	ssh $HOST_IP "$BIN_DIR/install-role-worker.sh"
fi

echo -e ${BLUE}"7. REBOOT [ ${RED}$ROLES${BLUE} ]"${NC}
