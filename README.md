# Set up a docker-container for object detection with darknet
using CUDA 10.2 on Ubuntu 18.04

## Pre-launch setup

- get docker (https://www.docker.com/)

- get the nvidia-docker-toolkit (https://github.com/NVIDIA/nvidia-docker)

- add ppa with latest drivers:
```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
```

- get a nvidia display driver > 440:
```bash
sudo apt-get install nvidia-driver-440
```

- clone this repo and **cd into it**

- build the docker container (this may take a while)
```bash
docker build --build-arg user=${USER} -t darknet:latest .
```

- delete dangling docker images to free space
```bash
docker rmi $(docker images -f "dangling=true" -q)
```

## Launch

- run the darknet.sh script to get into the container
```bash
sh ./darknet.sh
```

- follow https://pjreddie.com/darknet/yolo/ to use darknet

## Settings

- change path to personal files at the end of the Dockerfile [Note: COPY paths are relative do the Dockerfile]

- change path to personal files in darknet.sh

- delete the `--device` entry in darknet.sh if you don't have a webcam attached
