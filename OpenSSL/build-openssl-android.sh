#!/bin/sh

OPENSSL_VERSION=1.1.0h

API_LEVEL32=19
API_LEVEL=21

BUILD_DIR=/tmp/openssl_android_build
OUT_DIR=/tmp/openssl_android
rm -f *.log

#BUILD_TARGETS="armeabi armeabi-v7a arm64-v8a x86 x86_64"
BUILD_TARGETS="armeabi-v7a arm64-v8a"

if [ ! -d openssl-${OPENSSL_VERSION} ]
then
    if [ ! -f openssl-${OPENSSL_VERSION}.tar.gz ]
    then
        wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz || exit 128
    fi
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz || exit 128
fi

cd openssl-${OPENSSL_VERSION} || exit 128

##### remove output-directory #####
rm -rf $OUT_DIR

##### build-function #####
build_the_thing() {
    TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64
    export PATH=$TOOLCHAIN/$TRIBLE/bin:$TOOLCHAIN/bin:"$PATH"
    #echo $PATH
    echo "build_the_thing $1 make clean"
    make clean >"$(pwd)/../$1.log"
    #./Configure $SSL_TARGET $OPTIONS -fuse-ld="$TOOLCHAIN/$TRIBLE/bin/ld" "-gcc-toolchain $TOOLCHAIN" && \
    echo "build_the_thing $1 Configure"
    ./Configure $SSL_TARGET $OPTIONS -fuse-ld="$TOOLCHAIN/$TRIBLE/bin/ld"
    echo "build_the_thing $1 make"
    make >>"../$1.log" 2>&1
    echo "build_the_thing $1 make install"
    make install DESTDIR=$DESTDIR >>"../$1.log" 2>&1 || exit 128
}

##### set variables according to build-tagret #####
for build_target in $BUILD_TARGETS
do
    case $build_target in
    armeabi)
        TRIBLE="arm-linux-androideabi"
        TC_NAME="arm-linux-androideabi-4.9"
        #OPTIONS="--target=armv5te-linux-androideabi -mthumb -fPIC -latomic -D__ANDROID_API__=$API_LEVEL"
        OPTIONS="--target=armv5te-linux-androideabi -mthumb -fPIC -latomic -D__ANDROID_API__=$API_LEVEL32"
        DESTDIR="/$BUILD_DIR/armeabi"
        SSL_TARGET="android-arm"
    ;;
    armeabi-v7a)
        TRIBLE="arm-linux-androideabi"
        TC_NAME="arm-linux-androideabi-4.9"
        OPTIONS="--target=armv7a-linux-androideabi -Wl,--fix-cortex-a8 -fPIC -D__ANDROID_API__=$API_LEVEL32"
        DESTDIR="/$BUILD_DIR/armeabi-v7a"
        SSL_TARGET="android-arm"
    ;;
    x86)
        TRIBLE="i686-linux-android"
        TC_NAME="x86-4.9"
        OPTIONS="-fPIC -D__ANDROID_API__=${API_LEVEL32}"
        DESTDIR="/$BUILD_DIR/x86"
        SSL_TARGET="android-x86"
    ;;
    x86_64)
        TRIBLE="x86_64-linux-android"
        TC_NAME="x86_64-4.9"
        OPTIONS="-fPIC -D__ANDROID_API__=${API_LEVEL}"
        DESTDIR="/$BUILD_DIR/x86_64"
        SSL_TARGET="android-x86_64"
    ;;
    arm64-v8a)
        TRIBLE="aarch64-linux-android"
        TC_NAME="aarch64-linux-android-4.9"
        OPTIONS="-fPIC -D__ANDROID_API__=${API_LEVEL}"
        DESTDIR="/$BUILD_DIR/arm64-v8a"
        SSL_TARGET="android-arm64"
    ;;
    esac

    rm -rf $DESTDIR
    build_the_thing "${build_target}"
    #### copy libraries1 and includes to output-directory #####
    echo "Copy ${build_target} Libraries1"
    mkdir -p $OUT_DIR/$build_target/include
    cp -R $DESTDIR/usr/local/include/* $OUT_DIR/$build_target/include
    mkdir -p $OUT_DIR/$build_target/lib
    cp -R $DESTDIR/usr/local/lib/*.so* $OUT_DIR/$build_target/lib
    cp -R $DESTDIR/usr/local/lib/*.a $OUT_DIR/$build_target/lib
done

echo Success
