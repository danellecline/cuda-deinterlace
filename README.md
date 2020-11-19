# About 

Fast CUDA FFMPEG deinterlacer. Note that requires specific CUDA driver versions.
Works on DiGiTS-Dev-Box-Fish as of 9-18-20  

# Credits

Many thanks to https://github.com/Svechnikov for his example Dockerfile.

# Requirements

 - NVIDIA graphics card 
 - CUDA Driver Version: 440.100, Version: 10.1 
 - [Docker](www.docker.com)


# Build for CUDA 10.1

```
docker build -t mbari/cuda-deinterlace:10.1 .
```

# Examples

Convert prores to deinterlaced compressed h264

 * -map_metadata 0:g  	Copies global metadata
 * -c:v h264_nvenc       	Use CUDA enabled h264 encoder
 * -vf yadif=1		De-interlace and convert to progressive scan
 * -vf format=yuv420p	Drop 10-bit encoding (not supported)
 * -an			Drop the audio
 * -movflags faststart	Move the mov atom to the start of the file for fast playback. Happens at the end of transcoding in second pass
 * CUDA_VISIBLE_DEVICES=0  Run on device 0

```
docker run -e CUDA_VISIBLE_DEVICES=0 -it -u $(id -u):$(id -g) \
	-v $PWD:/io -v /mnt/M3/:/mnt/M3 --rm mbari/cuda-deinterlace:10.1 \
	ffmpeg -y -hwaccel cuvid -i /mnt/M3/master/DocRicketts/2016/11/0904/D0904_20161113T020253Z_prores.mov \
        -map_metadata 0:g -c:v h264_nvenc -preset slow -movflags faststart \
	-vf bwdif=0,format=yuv420p -movflags faststart \
	/io/bwdifD0569_20131213T224337Z_00-00-01-00TC_h264.mp4

docker run -e CUDA_VISIBLE_DEVICES=0 -it -u $(id -u):$(id -g) \
	-v $PWD:/io --rm mbari/cuda-deinterlace:10.1 \
	ffmpeg -y -hwaccel cuvid -i /io/D0569_20131213T224337Z_00-00-01-00TC_prores.mov \
        -map_metadata 0:g -c:v h264_nvenc -preset slow -movflags faststart \
	-vf bwdif=0,format=yuv420p -movflags faststart \
	/io/bwdifD0569_20131213T224337Z_00-00-01-00TC_h264.mp4
```

Convert prores to deinterlaced prores using the bwdif filter. 
Prores does not currently have encode/decode CUDA support 

```
docker run -it -v $PWD:/io --rm mbari/cuda-deinterlace:10.1  -u $(id -u):$(id -g) \
	ffmpeg -y -i /io/D0569_20131213T224337Z_00-00-01-00TC_prores.mov \
        -map_metadata 0:g -c:v prores -vf bwdif=0,format=yuv420p -movflags faststart \
	/io/bwdifD0569_20131213T224337Z_00-00-01-00TC_h264.mov
```

