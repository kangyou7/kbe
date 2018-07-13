#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

COMMON_LVNAME="disk1"
COMMON_MOUNTDISK="/disk1"

USAGES $# 3 "<create/extend> <VolumeGroup name> <device path>\n Ex. $0 extend data /dev/sdc1"

COMMON_VGNAME=$2
DEV=$3

if [ $1 == "create" ] ; then 
	echo -e $BLUE"Create PV -> VG -> LV"$NC
	pvcreate $DEV
	vgcreate $COMMON_VGNAME $DEV
	lvcreate -l100%FREE --name=$COMMON_LVNAME $COMMON_VGNAME
	echo -e $BLUE"Make Filesystem of XFS"$NC
	mkfs.xfs /dev/mapper/${COMMON_VGNAME}-${COMMON_LVNAME}
	echo -e $BLUE"Add Disk to /etc/fstab"$NC
	echo -e "\n/dev/mapper/${COMMON_VGNAME}-${COMMON_LVNAME}\t/disk1\txfs\tdefaults 0 0" >> /etc/fstab
	echo -e $BLUE"Mount Disk"$NC
	mkdir -p /disk1
	mount -a
elif [ $1 == "extend" ] ; then 
	echo -e $BLUE"Create PV -> Extend VG -> Extend LV(w/ fs extend)"$NC
	pvcreate $DEV
	vgextend $COMMON_VGNAME $DEV
	lvextend -l +100%FREE -r /dev/$COMMON_VGNAME/${COMMON_LVNAME}
fi