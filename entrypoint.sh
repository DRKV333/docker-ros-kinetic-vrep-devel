#!/bin/bash

STARTFILE="$HOME/.docker_inited"
if [ ! -e $STARTFILE ]; then
    touch $STARTFILE
    read -p "Initialize apt-get and rosdep now? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get update
        rosdep update
    fi
fi

$@
