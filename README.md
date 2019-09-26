# ros-kinetic-vrep-devel

This is a ROS development environment packed into a Docker image, for easy setup. The image contains the desktop version of ROS along with the EDU version of V-REP for running simulations. (Please review the V-REP EDU license before use.)

Loosly based on this project: https://github.com/gandrein/docker-ros-kinetic-simulation-tools

# Setup

This repo contains a set of scrips, both for bash and Windows cmd, to make the setup process even easier.

## Linux

1. Install Docker (On Ubuntu: `sudo apt install docker.io`) 
2. Clone this repo: `git clone https://github.com/DRKV333/docker-ros-kinetic-vrep-devel`
3. Change `SRCPATH` in [Linux/CONFIG.sh](Linux/CONFIG.sh) to the folder you want to store your source code in.
4. Run [Linux/Create.sh](Linux/Create.sh)
5. You can start the container with [Linux/Start.sh](Linux/Start.sh)

Depending on how your Docker is set up, you might need to run these scripts with `sudo`.

## Windows

1. Install [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
2. During the first launch, Docker will prompt you to install Hyper-V
3. Install [Xming](https://sourceforge.net/projects/xming/)
4. Clone this repo: `git clone https://github.com/DRKV333/docker-ros-kinetic-vrep-devel` (or download as zip)
5. Change `SRCPATH` in [Windows/CONFIG.bat](Windows/CONFIG.bat) to the folder you want to store your source code in.
6. Make sure Docker Desktop is running
7. Run [Windows/Create.bat](Windows/Create.bat)
8. Start Xming using Xlaunch (default configuration should be fine)
9. You can start the container with [Windows/Start.bat](Windows/Start.bat)
