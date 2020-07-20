# Android-FFmpeg

## 准备工作

1 下载并安装MinGW，或CygWin
   并安装make等工具

2 下载并解压NDK
   建议使用较低版本的ndk（如r14）


## 编译FFmpeg for exo

1 sync ffmpeg代码
   cd jni
   ./git-clone-ffmpeg.sh4
   
2 使用ndk toolchain编译ffmpeg
   cd build
   ./build-armv7a.sh
   
3 编译ffmpeg接口for exoplayer extension
   cd ..
   ${NDK_PATH}/ndk-build APP_ABI="armeabi-v7a" -j4
