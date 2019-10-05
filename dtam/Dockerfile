from nvidia/cudagl:9.0-devel-ubuntu16.04

# basic setup
RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install wget
RUN apt-get -y software-properties-common
RUN add-apt-repository -y "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main"
RUN add-apt-repository -y "ppa:jonathonf/vim"
RUN apt-get -y install vim
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update
RUN apt-get -y install clangd-10
RUN cp /usr/bin/clangd-10 /usr/bin/clangd

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
