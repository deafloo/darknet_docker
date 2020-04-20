FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

ARG user=flode

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y git

RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y pkg-config
RUN apt-get install -y libgtk-3-dev
RUN apt-get install -y libavcodec-dev
RUN apt-get install -y libavformat-dev
RUN apt-get install -y libswscale-dev
RUN apt-get install -y libv4l-dev
RUN apt-get install -y libxvidcore-dev
RUN apt-get install -y libx264-dev
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libtiff-dev
RUN apt-get install -y gfortran
RUN apt-get install -y openexr
RUN apt-get install -y libatlas-base-dev
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-numpy
RUN apt-get install -y libtbb2
RUN apt-get install -y libtbb-dev
RUN apt-get install -y libdc1394-22-dev

RUN mkdir -p /home/$user/opencv_build
WORKDIR /home/$user/opencv_build
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

WORKDIR /home/$user/opencv_build/opencv_contrib
#change 'master' for your preferred opencv_contrib-version, must be same as opencv-version
RUN git checkout master
WORKDIR /home/$user/opencv_build/opencv
#change 'master' for your preferred opencv-version, must be same as opencv_contrib-version
RUN git checkout master
RUN mkdir -p build
WORKDIR /home/$user/opencv_build/opencv/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_CUDA=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -D OPENCV_EXTRA_MODULES_PATH=/home/$user/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

#set -jX the number of CPU-cores in your machine
RUN make -j6
RUN make install

#edit this if you use opencv < 4
RUN pkg-config --modversion opencv4


RUN git clone https://github.com/AlexeyAB/darknet.git /home/$user/darknet
WORKDIR /home/$user/darknet
RUN sed -i 's/OPENCV=0/OPENCV=1/' Makefile
RUN sed -i 's/GPU=0/GPU=1/' Makefile
RUN sed -i 's/CUDNN=0/CUDNN=1/' Makefile
RUN sed -i 's!NVCC=nvcc!NVCC=/usr/local/cuda/bin/nvcc!' Makefile
RUN sed -i '140aLDFLAGS+= -L/usr/lib/x86_64-linux-gnu' Makefile
RUN sed -i '140aLDFLAGS+= -L/usr/local/cuda/lib64/stubs' Makefile

#see https://stackoverflow.com/questions/39287744/ubuntu-16-04-nvidia-toolkit-8-0-rc-darknet-compilation-error-expected
#and https://github.com/pjreddie/darknet/issues/1923

RUN make

#[OPTIONAL] copy your personal yolo data and config into the container
COPY candy.data /home/$user/darknet/data
	


