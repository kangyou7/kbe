#!/bin/bash

## Usages : ssh-key-copy.sh <User ID> <Password>
## User ID MUST be sudoer
## MUST edit conf/hosts file
## MUST add conf/authorized_keys file ( follow below )
### 1. ssh-keygen
### 1.1 three times input <Enter> key  - id_rsa making w/ no password
### 2. cp ~/.id_rsa.pub $CONF_DIR/authorized_keys

if [ $# -lt 2 ] ; then
	echo "Usages : $0 <User ID> <Password>"
	exit
fi

INST_PATH=$(dirname $(dirname $(which $0)))

USR1=$1
PWD=$2

### Setup Environments
source $INST_PATH/conf/envs
source $BIN_DIR/.color

if [ -f $CONF_DIR/authorized_keys ] ; then 
	AK=$(cat $CONF_DIR/authorized_keys)
else
	echo -e $RED"MUST $CONF_DIR/authorized_keys Needed for SSH key copy automation"$NC
	exit
fi

### get host ip except reource host
for HOST in $(cat $CONF_DIR/hosts|grep -v resource|awk '{print $1}')
do
	echo -e "ssh KEY copy to ${GREEN}$(cat $CONF_DIR/hosts|grep $HOST|awk '{print $2}')${NC}"
	$BIN_DIR/ssh-key-copy.exp $HOST $USR1 $PWD "$AK"
done
