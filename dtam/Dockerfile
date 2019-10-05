from nvidia/cudagl:9.0-devel-ubuntu16.04

# basic setup
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install vim
RUN apt-get -y install wget

# dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install qtbase5-dev
RUN apt-get -y install libopencv-dev
RUN apt-get -y install cmake
RUN apt-get -y install build-essential
RUN apt-get -y install libboost-system-dev
RUN apt-get -y install libboost-thread-dev

WORKDIR /root
# compile opencv from source, for cuda
RUN git clone -b 3.2-cuda9.0 https://github.com/taimir/opencv.git
RUN bash -c "cd opencv && mkdir build && cd build && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" .. && make -j8 && make install"

## clone and build OpenDTAM
RUN git clone -b cv3.2-cuda9.0 https://github.com/taimir/OpenDTAM-3.1.git OpenDTAM
# OpenDTAM expects opencv 3.1, see if I can use 3.2
RUN bash -c "cd OpenDTAM && mkdir build && cd build && cmake ../Cpp && make -j8"
