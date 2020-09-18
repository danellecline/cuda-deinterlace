# About 

Fast CUDA FFMPEG deinterlacer

# Credits

Many thanks to https://github.com/Svechnikov for his example Dockerfile.

# Requirements

 - NVIDIA graphics card 
 - CUDA drivers installed - either 9.0 or 10.1
 - [Docker](www.docker.com)


# Build for CUDA 10.1

```
docker build --build-arg TAG=cuda:10.1-devel-ubuntu18.04 -t mbari/cuda-deinterlace:10.1 .
```

# Build for CUDA 9.0

```
docker build --build-arg TAG=9.0-devel-ubuntu16.04 -t mbari/cuda-deinterlace:9.0 .
```
