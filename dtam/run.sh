#!/bin/bash
docker run --gpus=0 -it \
	-v /home/valor/.Xauthority:/root/.Xauthority:rw \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	--net host \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	dtam /root/OpenDTAM/build/a.out /root/OpenDTAM/Trajectory_30_seconds
