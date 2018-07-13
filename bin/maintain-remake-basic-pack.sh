#!/bin/bash

INST_PATH=$(dirname $(dirname $(which $0)))

source $INST_PATH/conf/envs
source $INST_PATH/bin/.color

echoGREEN "re-Make basic-pack.tar"
cd $BASE_DIR
echo -e $BLUE" Delete basic-pack.tar"$NC
rm -f basic-pack.tar
echo -e $BLUE" Move all DI to DI_NEW"$NC
mv DI/* DI_NEW/
echo -e $BLUE" Make basic-pack.tar"$NC
tar cf basic-pack.tar bin conf DI DI_NEW rpms
