#!/bin/bash

source CONFIG.sh

if [ "$#" -lt 1 ]; then
  CONTAINER=$CONTAINERN
else
  CONTAINER=$1
fi

docker start -ai $CONTAINER
