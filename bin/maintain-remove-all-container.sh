#!/bin/bash

echo "Remove all Docker Container"

docker rm -f $(docker ps -a |grep -v CONTAINER|awk '{print $1}')

