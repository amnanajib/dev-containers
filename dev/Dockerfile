FROM nvidia/cudagl:10.1-devel-ubuntu18.04

# install basic dev (cpp + python)
RUN apt-get update && apt-get install -y \
	sudo \
	zsh \
	build-essential \
        cmake \
	libboost-all-dev \
	python3-dev \
	python3-pip \
        git \
        wget \
	locales \
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
	ffmpeg

# install opencv
WORKDIR /
ENV OPENCV_VERSION="4.2.0"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
	&& wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
	&& unzip ${OPENCV_VERSION}.zip \
	&& unzip opencv_contrib.zip \
	&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cmake -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib-${OPENCV_VERSION}/modules \
		-DBUILD_TIFF=ON \
		-DBUILD_opencv_java=OFF \
		-DWITH_CUDA=ON \
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

# set the locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# setup global virtualenv packages
RUN pip3 install virtualenv
RUN pip3 install virtualenvwrapper

# setup dev user
RUN useradd -ms /bin/zsh dev
RUN echo 'dev:dev' | chpasswd
RUN usermod -a -G sudo dev
RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dev
ENV HOME /home/dev

# setup shell
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# setup tmux
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# setup vim
USER root
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:jonathonf/vim
RUN apt-get update && apt-get install -y vim
USER dev
RUN mkdir -p ${HOME}/.vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim

# python dev
USER root
RUN apt-get install -y python-pip
USER dev
RUN pip install virtualenv --user
RUN pip install virtualenvwrapper --user
ENV WORKON_HOME ${HOME}/.virtualenvs
RUN mkdir -p $WORKON_HOME
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh \
		&& mkvirtualenv -p python3 dev \
		&& workon dev \
		&& pip install 'python-language-server[all]' \
		&& pip install torch torchvision \
		&& pip install tensorflow-gpu \
		&& pip install tensorflow_probability \
		&& pip install ipython \
		&& pip install ipdb \
		&& pip install jupyter \
		&& pip install tqdm \
		&& pip install tfquaternion \
		&& pip install numpy-quaternion \
		&& pip install scikit-learn \
		&& pip install scipy \
		&& pip install jupyter \
		&& pip install h5py \
		&& pip install docopt \
		&& pip install python-box \
		&& pip install h5py \
		&& pip install matplotlib \
		&& pip install seaborn \
		&& pip install virtualenv \
		&& pip install virtualenvwrapper"
RUN echo "source ${HOME}/.virtualenvs/dev/bin/virtualenvwrapper.sh" >> ~/.zshrc
RUN echo "source ${HOME}/.virtualenvs/dev/bin/activate" >> ~/.zshrc

# c++ dev
USER root
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main"
RUN apt-get update && apt-get install -y clangd-9 gdb
RUN cp /usr/bin/clangd-9 /usr/bin/clangd

# make workspace
USER dev
RUN mkdir -p ${HOME}/workspace
WORKDIR ${HOME}/workspace
