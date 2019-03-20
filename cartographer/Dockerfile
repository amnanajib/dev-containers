FROM ros:kinetic-ros-base

# Install sudo (user is root) and wget, vim, rosdep and ninja
RUN apt update && apt-get install sudo -y
RUN apt-get install -y wget vim
RUN apt-get install -y python-wstool python-rosdep ninja-build
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:graphics-drivers -y && apt-get update
RUN sudo cp /bin/bash /bin/sh

# Add a sudo user
RUN useradd -m dev && echo "dev:dev" | chpasswd && adduser dev sudo
RUN echo "dev ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/dev && chmod 0440 /etc/sudoers.d/dev
USER dev

# Set ROS env variables for dev
ENV CMAKE_PREFIX_PATH /opt/ros/kinetic
ENV LD_LIBRARY_PATH /opt/ros/kinetic/lib
ENV PATH /opt/ros/kinetic/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PKG_CONFIG_PATH /opt/ros/kinetic/lib/pkgconfig
ENV PYTHONPATH /opt/ros/kinetic/lib/python2.7/dist-packages
ENV ROS_DISTRO kinetic
ENV ROS_ETC_DIR /opt/ros/kinetic/etc/ros
ENV ROS_MASTER_URI http://localhost:11311
ENV ROS_PACKAGE_PATH /opt/ros/kinetic/share
ENV ROS_ROOT /opt/ros/kinetic/share/ros
ENV ROS_VERSION 1

# Create a new workspace in 'catkin_ws'.
WORKDIR /home/dev
RUN mkdir catkin_ws
WORKDIR /home/dev/catkin_ws
RUN wstool init src

# Merge the cartographer_ros.rosinstall file and fetch code for dependencies.
RUN wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
RUN wstool update -t src

# Install proto3.
RUN src/cartographer/scripts/install_proto3.sh

# Remove traces of previous ROS init
RUN sudo rm /etc/ros/rosdep/sources.list.d/20-default.list

# Dependencies and build
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"
RUN sudo rosdep init 
RUN /bin/bash -c "rosdep update && rosdep install -y --from-paths src --ignore-src --rosdistro=kinetic && catkin_make_isolated --install --use-ninja && source install_isolated/setup.bash"

# Add initial setup file
ADD entrypoint.sh /home/dev/.

# Finally, upgrade ROS and install some ROS utilities
RUN sudo apt upgrade -y
RUN sudo apt install ros-kinetic-rqt ros-kinetic-rqt-common-plugins ros-kinetic-turtlesim -y
RUN sudo apt install ros-kinetic-ros-tutorials -y

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Entrypoint
ENTRYPOINT []
