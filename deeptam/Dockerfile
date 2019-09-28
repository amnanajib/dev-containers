FROM tensorflow/tensorflow:1.4.0-gpu-py3

# basic packages
RUN apt-get update
RUN apt-get install sudo -y
RUN apt-get install zsh -y
RUN apt-get install wget -y
RUN apt-get install python3-pip python3-dev python-pip -y
RUN apt-get install git -y
RUN apt-get install vim -y
RUN apt-get install locales -y
RUN apt-get install cmake -y
RUN apt-get install libboost-dev -y
RUN apt-get install libboost-python-dev -y
RUN apt-get install libeigen3-dev -y

# set the locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# make virtualenvs
RUN pip2 install virtualenv
RUN pip2 install virtualenvwrapper

# make a user
RUN useradd -ms /bin/zsh dev
RUN echo 'dev:dev' | chpasswd
RUN usermod -a -G sudo dev
RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dev
ENV HOME /home/dev

# configs & vim setup
RUN mkdir -p ${HOME}/workspace
RUN git clone https://github.com/taimir/configs.git ${HOME}/workspace/configs
RUN cp ${HOME}/workspace/configs/vim/.vimrc ${HOME}/.
RUN mkdir -p ${HOME}/.vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim

# zsh setup
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# general virtualenv setup
ENV WORKON_HOME ${HOME}/.virtualenvs
RUN mkdir -p $WORKON_HOME
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh \
		&& mkvirtualenv -p python3 python-deep \
		&& workon python-deep \
		&& pip install 'python-language-server[all]' \
		&& pip install ipdb \
		&& pip install tqdm \
		&& pip install tensorflow-gpu==1.4.0 \
		&& pip install jupyter \
		&& pip install h5py \
		&& pip install matplotlib \
		&& pip install seaborn \
		&& pip install minieigen \
		&& pip install scikit-image \
		&& pip install virtualenv \
		&& pip install virtualenvwrapper"
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.zshrc
RUN echo "source ${HOME}/.virtualenvs/python-deep/bin/activate" >> ~/.zshrc

# setup deeptam
# clone and build lmbspecialops (use branch deeptam)
WORKDIR ${HOME}/workspace
RUN git clone -b deeptam https://github.com/lmb-freiburg/lmbspecialops.git
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh \
		  && workon python-deep \
		  && cd lmbspecialops \
		  && mkdir build \
		  && cd build \
		  && cmake .. -DBUILD_WITH_CUDA=OFF \
		  && make -j 16"
ENV PYTHONPATH=${HOME}/workspace/lmbspecialops/python:${PYTHONPATH}
# clone deeptam
RUN git clone https://github.com/lmb-freiburg/deeptam.git
ENV PYTHONPATH=${HOME}/workspace/deeptam/tracking/python:${PYTHONPATH}
ENV PYTHONPATH=${HOME}/workspace/deeptam/mapping/python:${PYTHONPATH}

WORKDIR ${HOME}/workspace/deeptam
