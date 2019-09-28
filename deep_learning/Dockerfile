FROM tensorflow/tensorflow:1.13.1-gpu-py3

RUN apt-get update
RUN apt-get install sudo -y
RUN apt-get install zsh -y
RUN apt-get install wget -y
RUN apt-get install python3-pip python3-dev python-pip -y
RUN apt-get install git -y
RUN apt-get install locales -y
RUN apt-get install tmux -y
RUN apt-get install vim -y

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN pip install virtualenv
RUN pip install virtualenvwrapper

RUN useradd -ms /bin/zsh dev
RUN echo 'dev:dev' | chpasswd
RUN usermod -a -G sudo dev
RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dev
ENV HOME /home/dev

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
ENV WORKON_HOME ${HOME}/.virtualenvs
RUN mkdir -p $WORKON_HOME
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh \
		&& mkvirtualenv -p python3 python-deep \
		&& workon python-deep \
		&& pip install 'python-language-server[all]' \
		&& pip install ipdb \
		&& pip install tqdm \
		&& pip install tensorflow-gpu \
		&& pip install tensorpack \
		&& pip install tensorflow_probability \
		&& pip install tfquaternion \
		&& pip install numpy-quaternion \
		&& pip install sklearn \
		&& pip install scipy \
		&& pip install jupyter \
		&& pip install h5py \
		&& pip install docopt \
		&& pip install python-box \
		&& pip install jupyter \
		&& pip install h5py \
		&& pip install matplotlib \
		&& pip install seaborn \
		&& pip install virtualenv \
		&& pip install virtualenvwrapper"
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.zshrc
RUN echo "source ${HOME}/.virtualenvs/python-deep/bin/activate" >> ~/.zshrc

RUN mkdir -p ${HOME}/workspace
RUN git clone https://github.com/taimir/configs.git ${HOME}/workspace/configs
RUN cp ${HOME}/workspace/configs/vim/.vimrc ${HOME}/.
RUN cp ${HOME}/workspace/configs/zsh/.zshrc ${HOME}/.
RUN cp ${HOME}/workspace/configs/tmux/.tmux.conf ${HOME}/.

RUN mkdir -p ${HOME}/.vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
RUN git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

WORKDIR ${HOME}
