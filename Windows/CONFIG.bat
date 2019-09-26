@echo off

rem Name of the docker image to load. Used by create.sh
rem Do not change this
set IMAGEN="drkv/docker-ros-kinetic-vrep-devel"

rem Name of the conatiner created by create.sh and ran by start.sh
rem You can override it by passing an argument to create.sh/start.sh
rem set CONTAINERN="ros-kinetic-vrep-devel"
set CONTAINERN="ros-kinetic-vrep-devel"

rem Path of the folder mounted to ~/catkin_ws/src in the container. Used by create.sh
rem Note, that this CANNOT be easily changed once the container is created.
set SRCPATH="%userprofile%\Documents\catkin_ws\src"
