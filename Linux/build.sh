#!/bin/bash

source CONFIG.sh

docker build -t $IMAGEN $@ ..
