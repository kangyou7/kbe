#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))
source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

USAGES $# 2 "<create/extend> <device path>\n Ex. $0 extend /dev/sdc1\n${RED}MUST Set conf/envs's HADOOP section${NC}"

DEV=$2

if [ $1 == "create" ] ; then 
	echo -e $BLUE"Create PV -> VG -> LV"$NC
	pvcreate $DEV
	vgcreate $HADOOPDATA_VGNAME $DEV
	lvcreate -l100%FREE --name=$HADOOPDATA_LVNAME $HADOOPDATA_VGNAME
	echo -e $BLUE"Make Filesystem of XFS"$NC
	mkfs.xfs /dev/mapper/${HADOOPDATA_VGNAME}-${HADOOPDATA_LVNAME}
	echo -e $BLUE"Add Disk to /etc/fstab"$NC
	echo -e "\n/dev/mapper/${HADOOPDATA_VGNAME}-${HADOOPDATA_LVNAME}\t/disk1\txfs\tdefaults 0 0" >> /etc/fstab
	echo -e $BLUE"Mount Disk"$NC
	mkdir -p /disk1
	mount -a
elif [ $1 == "extend" ] ; then 
	echo -e $BLUE"Create PV -> Extend VG -> Extend LV(w/ fs extend)"$NC
	pvcreate $DEV
	vgextend $HADOOPDATA_VGNAME $DEV
	lvextend -l +100%FREE -r /dev/$HADOOPDATA_VGNAME/${HADOOPDATA_LVNAME}
fi