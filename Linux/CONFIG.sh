#!/bin/bash

# Name of the docker image to load. Used by create.sh
# Do not change this
IMAGEN="drkv/docker-ros-kinetic-vrep-devel"

# Name of the conatiner created by create.sh and ran by start.sh
# You can override it by passing an argument to create.sh/start.sh
CONTAINERN="ros-kinetic-vrep-devel"

# Path of the folder mounted to ~/catkin_ws/src in the container. Used by create.sh
# Note, that this CANNOT be easily changed once the container is created.
SRCPATH="$HOME/catkin_ws/src"
