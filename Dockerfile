# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Base stage
# Installs everything and sets up the user
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
FROM ubuntu:xenial AS base

ARG vrepfile=V-REP_PRO_EDU_V3_6_2_Ubuntu16_04
ARG user=docker
ARG shell=/bin/bash
ARG workspace="/home/${user}/catkin_ws"

# Add repository for ros-kinetic and gcc9

RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list \
 && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
 && echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main" > /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-xenial.list \
 && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 60C317803A41BA51845E371A1E9377A2BA9EF27F

# Install packages

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
 software-properties-common python-software-properties \
 lsb-release mesa-utils build-essential \
 git sudo ssh wget curl unzip htop nano \
 gnome-terminal terminator \
 gcc-9 g++-9 \
 python-rosdep python-rosinstall \
 python3-pip python-pip python-catkin-tools \
 ros-kinetic-desktop-full \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set gcc9 as default

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 20 --slave /usr/bin/g++ g++ /usr/bin/g++-9

# Configure ROS

RUN rosdep init && echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

# Create user

RUN useradd -ms ${shell} ${user} \
 && echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" \
 && chmod 0440 "/etc/sudoers.d/${user}"
ENV USER=${user}

USER ${user}
WORKDIR /home/${user}

# Install V-REP

RUN wget -nv http://www.coppeliarobotics.com/files/${vrepfile}.tar.xz \
 && tar -xf ${vrepfile}.tar.xz \
 && rm ${vrepfile}.tar.xz
ENV VREP_ROOT=/home/${user}/${vrepfile}

# Create catkin workspace
# (Also run a build to create /devel)

ENV CATKIN_TOPLEVEL_WS=${workspace}
RUN mkdir -p ${workspace}/src && . /opt/ros/kinetic/setup.sh && catkin init --workspace ${workspace} && catkin build --workspace ${workspace}

# Add env setup for user

RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc \
 && echo "source ${workspace}/devel/setup.bash" >> ~/.bashrc \
 && echo "export PATH=/${VREP_ROOT}/:\$PATH" >> ~/.bashrc \
 && echo "alias ws_setup='source ${workspace}/devel/setup.bash'" >> ~/.bashrc

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Interface Buid stage
# Rebuilds the V-VREP ROS Interface, because the included one is broken...
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
FROM base AS interface-buid

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
 ros-kinetic-tf2-sensor-msgs xsltproc \
 && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

RUN cd ${CATKIN_TOPLEVEL_WS}/src \
 && git clone --recursive https://github.com/CoppeliaRobotics/v_repExtRosInterface.git vrep_ros_interface \
 && . /opt/ros/kinetic/setup.sh && catkin build --workspace ${CATKIN_TOPLEVEL_WS}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Final stage
# Install the ROS Interface and setup entrypoint
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

FROM base

COPY --from=interface-buid ${CATKIN_TOPLEVEL_WS}/devel/lib/libv_repExtRosInterface.so ${VREP_ROOT}

# Final setup

EXPOSE 22
ENV QT_X11_NO_MITSHM=1

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
CMD ["terminator"]

