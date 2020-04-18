#!/bin/bash

imageTag=yolo:latest	#as described at the build process
imageName=yolo_docker			#name of the Docker-container

isRunning="$(docker inspect -f '{{.State.Running}}' $imageName)" > /dev/null 2>&1	#suppress console output
imageStatus="$(docker inspect -f '{{.State.Status}}' $imageName)" > /dev/null 2>&1

echo "Starting new container..."

sudo docker run \
	-it \
	--rm \
	--name=$imageName \
	--user=$UID \
	--env="DISPLAY" \
	--workdir="/home/$USER" \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--device="/dev/video0:/dev/video0:rwm" \
	--volume="/home/$USER/Object_detection/weights:/home/$USER/darknet/weights:ro" \
	--volume="/home/$USER/Object_detection/darknet_konsti:/home/$USER/Object_detection/darknet_konsti:ro" \
	$imageTag

#for webcam support add --device="/dev/video0:/dev/video0:rwm" \
