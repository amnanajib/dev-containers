FROM ros:kinetic-ros-base

# NVIDIA OpenGL support (patch from the official images)
# https://github.com/NVIDIA/nvidia-docker/issues/534
# ======================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*

# replace with other Ubuntu version if desired
# see: https://hub.docker.com/r/nvidia/opengl/
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu

# replace with other Ubuntu version if desired
# see: https://hub.docker.com/r/nvidia/opengl/
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# End NVIDIA OpenGL support
# =========================

# Upgrade ROS and install some ROS utilities
RUN apt update
RUN apt upgrade -y
RUN apt install ros-kinetic-rqt ros-kinetic-rqt-common-plugins ros-kinetic-turtlesim ros-kinetic-rviz -y
RUN apt install ros-kinetic-ros-tutorials -y

# Install wget, vim, rosdep and ninja
RUN apt-get install -y wget vim
RUN apt-get install -y python-wstool python-rosdep
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:graphics-drivers -y && apt-get update
RUN cp /bin/bash /bin/sh

# essentials
RUN apt-get update
RUN apt-get install build-essential g++ cmake git -y
RUN apt-get install freeglut3 freeglut3-dev mesa-common-dev libglu1-mesa-dev libglew-dev libglm-dev -y

# core deps
RUN apt-get install libeigen3-dev libboost-all-dev -y
# for visualizations and dealing with images
RUN apt-get install libopencv-dev -y
# to compile with ROS
RUN apt-get install ros-kinetic-libg2o ros-kinetic-cv-bridge ros-kinetic-tf -y
# DBoW2 and g2o are part of the OrbSLAM repo

# GUI
# video dependencies
RUN apt-get install ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev -y
# image dependencies
RUN apt-get install libjpeg-dev -y
WORKDIR /root 
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /root/Pangolin
RUN mkdir build && cd build && cmake .. && cmake --build . -- -j 12
WORKDIR /root/Pangolin/build
RUN make install

# ORB_SLAM2
WORKDIR /root
RUN git clone https://github.com/raulmur/ORB_SLAM2.git ORB_SLAM2
WORKDIR /root/ORB_SLAM2
RUN chmod a+x build.sh
RUN ./build.sh
