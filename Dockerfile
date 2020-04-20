FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive
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

RUN mkdir -p /home/flode/opencv_build
WORKDIR /home/flode/opencv_build
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

WORKDIR /home/flode/opencv_build/opencv_contrib
RUN git checkout master
WORKDIR /home/flode/opencv_build/opencv
RUN git checkout master
RUN mkdir -p build
WORKDIR /home/flode/opencv_build/opencv/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_CUDA=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -D OPENCV_EXTRA_MODULES_PATH=/home/flode/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
RUN make -j6
RUN make install
RUN pkg-config --modversion opencv4


RUN git clone https://github.com/AlexeyAB/darknet.git /home/flode/darknet
WORKDIR /home/flode/darknet
RUN sed -i 's/OPENCV=0/OPENCV=1/' Makefile
RUN sed -i 's/GPU=0/GPU=1/' Makefile
RUN sed -i 's/CUDNN=0/CUDNN=1/' Makefile
RUN sed -i 's!NVCC=nvcc!NVCC=/usr/local/cuda/bin/nvcc!' Makefile
RUN sed -i '140aLDFLAGS+= -L/usr/lib/x86_64-linux-gnu' Makefile
RUN sed -i '140aLDFLAGS+= -L/usr/local/cuda/lib64/stubs' Makefile

#see https://stackoverflow.com/questions/39287744/ubuntu-16-04-nvidia-toolkit-8-0-rc-darknet-compilation-error-expected
#and https://github.com/pjreddie/darknet/issues/1923

#RUN /usr/local/cuda/bin/nvcc --version
RUN make

COPY candy.data /home/flode/darknet/data
	
	#dann im Dockerfile-Verzeichnis neues image bauen
		#'docker build -t ros:kinetic_custom .'
	#nach dem bauen altes image loeschen mit 
		#'docker rmi $(docker images -f "dangling=true" -q)'
	#evtl. neuer tag des images muss ins bash script!
	


