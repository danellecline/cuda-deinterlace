FROM nvidia/cuda:10.1-devel-ubuntu18.04

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,video,utility

WORKDIR /tmp

RUN apt-get update -qq && apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    libtool \
    pkg-config \
    wget \
    yasm \
    git

WORKDIR /tmp/ffmpeg

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && cd nv-codec-headers && git checkout n9.1.23.1 && make && make install

RUN git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg && cd ffmpeg && git checkout n4.3.1 && ./configure \
    --disable-ffplay \
    --disable-doc \
    --disable-devices \
    --enable-cuda-sdk \
    --enable-cuvid \
    --enable-nvenc \
    --enable-nonfree \
    --enable-libnpp \
    --enable-cuda-nvcc \
    --enable-cuda-llvm \
    --extra-cflags='-I/usr/local/cuda/include' \
    --extra-ldflags='-L/usr/local/cuda/lib64' \
     &&  make -j$(nproc --all) && make install

#RUN rm -rf /tmp/ffmpeg
