# OPENGL
FROM nvidia/opengl:1.1-glvnd-devel as opengl
FROM nvidia/cuda:8.0-devel-ubuntu16.04
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=opengl /usr/local/include /usr/local/include
COPY --from=opengl /usr/local/lib /usr/local/lib

RUN apt-get update && apt-get install -y \
	build-essential \
        cmake \
	python3 \
	python3-pip \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
	libeigen3-dev \
	libpng++-dev \
	python3-numpy

WORKDIR /
ENV OPENCV_VERSION="3.2.0"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
	&& wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
	&& unzip ${OPENCV_VERSION}.zip \
	&& unzip opencv_contrib.zip \
	&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cmake -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib-${OPENCV_VERSION}/modules \
		-DBUILD_TIFF=ON \
		-DBUILD_opencv_java=OFF \
		-DWITH_CUDA=OFF \
		-DWITH_OPENGL=ON \
		-DWITH_OPENCL=ON \
		-DWITH_IPP=ON \
		-DWITH_TBB=ON \
		-DWITH_EIGEN=ON \
		-DWITH_V4L=ON \
		-DBUILD_TESTS=OFF \
		-DBUILD_PERF_TESTS=OFF \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
		-DPYTHON_EXECUTABLE=$(which python3) \
		-DPYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
		-DPYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
		.. \
	&& make -j8 install \
	&& rm /${OPENCV_VERSION}.zip \
	&& rm -r /opencv-${OPENCV_VERSION} \
	&& rm /opencv_contrib.zip \
	&& rm -r /opencv_contrib-${OPENCV_VERSION}

# boost
RUN apt-get install -y libboost-all-dev

# c++ dev
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y clangd-9 gdb
RUN cp /usr/bin/clangd-9 /usr/bin/clangd
RUN add-apt-repository ppa:jonathonf/vim
RUN apt-get update && apt-get install -y vim zsh
#RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
