#!/bin/bash

FFMPEG_EXT_PATH=../ffmpeg
NDK_PATH=D:/tools/Android/android-ndk-r14b
HOST_PLATFORM=windows-x86_64
ENABLED_DECODERS=(vorbis opus flac)
ARCH=armv8-a

# ������Ե�ƽ̨������ѡ�����֧��android-23, arm�ܹ������ɵ�so���Ƿ���libs/armeabi�ļ����µģ������x86�ܹ���Ҫѡ��arch-x86
SYSROOT=$NDK_PATH/platforms/android-23/arch-arm64

# ��������·����arm-linux-androideabi-4.9���������õ�PLATFORM��Ӧ��4.9Ϊ���ߵİ汾��
TOOLCHAIN=$NDK_PATH/toolchains/llvm/prebuilt/${HOST_PLATFORM}

COMMON_OPTIONS="
    --target-os=android
    --disable-static
    --enable-shared
    --disable-doc
    --disable-programs
    --disable-everything
    --disable-avdevice
    --disable-avformat
    --disable-swscale
    --disable-postproc
    --disable-avfilter
    --disable-symver
    --disable-avresample
    --enable-swresample
    --extra-ldexeflags=-pie
    "
EXTRA_CFLAGS="-fdata-sections -ffunction-sections -fstack-protector-strong -ffast-math -fstrict-aliasing -fPIC -mabi=64 -EB -march=$ARCH -D__ANDROID_API__=23 -isystem $NDK_PATH/sysroot/usr/include -isystem $NDK_PATH/sysroot/usr/include/aarch64-linux-android"

EXTRA_LDFLAGS="-Wl,--gc-sections -Wl,-z,relro -Wl,-z,now,-mabi=64 -EB -m elf64ltsmip"


for decoder in "${ENABLED_DECODERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-decoder=${decoder}"
done

cd ../ffmpeg

echo ""
echo "--------------------"
echo "[*] Config"

#    --enable-runtime-cpudetect 
#    --enable-cross-compile 
#    "-march=armv7-a -mfloat-abi=softfp" 
#    "-Wl,--fix-cortex-a8" 


./configure \
    --libdir=android-libs/arm64-v8a \
    --enable-jni \
    --arch=$ARCH \
    --cpu=$ARCH \
    --cross-prefix=$TOOLCHAIN/bin/ \
    --cc="${TOOLCHAIN}/bin/clang" \
    --cxx="${TOOLCHAIN}/bin/clang++" \
    --sysroot=$SYSROOT \
    --enable-asm \
    --enable-neon \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS" \
    ${COMMON_OPTIONS}

echo ""
echo "--------------------"
echo "[*] make -j4"
make -j4

echo ""
echo "--------------------"
echo "[*] make install-libs"
make install-libs

make clean