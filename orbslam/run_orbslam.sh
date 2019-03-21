#!/bin/bash
nvidia-docker run -it \
	-v /home/valor/.Xauthority:/root/.Xauthority:rw \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v /var/run/media/valor/DATA:/root/DATA:rw \
	--net host \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--device /dev/dri \
	--privileged \
	taimir93/orbslam2 bash
