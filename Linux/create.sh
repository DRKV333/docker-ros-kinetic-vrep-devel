#!/bin/bash

source CONFIG.sh

if [ "$#" -lt 1 ]; then
  CONTAINER=$CONTAINERN
else
  CONTAINER=$1
fi

shift 1

# Deterimine configured user for the docker image
docker_user=$(docker image inspect --format '{{.Config.User}}' $IMAGEN)
if [ "$docker_user" = "" ]; then
    dHOME_FOLDER="/root"
else
    dHOME_FOLDER="/home/$docker_user"    
fi

docker create \
    --name=$CONTAINER \
    --net=host \
    --ipc=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=$dHOME_FOLDER/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME/.Xauthority:$dHOME_FOLDER/.Xauthority \
    -v $SRCPATH:$dHOME_FOLDER/catkin_ws/src \
    -it $IMAGEN "$@"
