#!/bin/bash

#to run successfully, your system also needs:
	#nvidia driver > 440
	#nvidia-docker-toolkit

imageTag=darknet:latest	#as described at the build process
imageName=darknet_docker			#name of the Docker-container

isRunning="$(docker inspect -f '{{.State.Running}}' $imageName)" > /dev/null 2>&1	#suppress console output
imageStatus="$(docker inspect -f '{{.State.Status}}' $imageName)" > /dev/null 2>&1

echo "Starting new container..."

xhost +

sudo docker run \
	-it \
	--rm \
	--gpus all \
	--name=$imageName \
	--user=$UID \
	--env DISPLAY=$DISPLAY \
	--env="QT_X11_NO_MITSHM=1" \
	--workdir="/home/$USER/darknet" \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--device="/dev/video0:/dev/video0:rwm" \
	--volume="/home/$USER/Object_detection/weights:/home/$USER/darknet/weights:ro" \
	--volume="/home/$USER/Object_detection/darknet_konsti:/home/$USER/Object_detection/darknet_konsti:ro" \
	$imageTag

xhost -

#for webcam support add --device="/dev/video0:/dev/video0:rwm" \
