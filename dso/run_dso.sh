#!/bin/bash
nvidia-docker run -it \
	-v /home/valor/workspace/dso/sequence_07:/root/data:rw \
	-v /home/valor/.Xauthority:/root/.Xauthority:rw \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	--net host \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--device /dev/dri \
	taimir93/dso bash

# run command
# ./dso_dataset files=../data/images calib=../data/camera.txt gamma=../data/pcalib.txt vignette=../data/vignette.png preset=0 mode=0
