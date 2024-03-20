#! /usr/bin/env bash

PJ_DIR=${PWD}
ANDROID_JNI=pjsip-apps/src/pjsua/android/jni
SWIG=pjsip-apps/src/swig
LIBS=${PJ_DIR}/libs/android
ROOT_LIBS=/tmp/pj/android
LOG=$PJ_DIR/android_result.log

echo "#define PJ_CONFIG_ANDROID 1
#define PJ_HAS_SSL_SOCK 1
#define PJSIP_HAS_TLS_TRANSPORT 1
#include <pj/config_site_sample.h>" > pjlib/include/pj/config_site.h

if [ $# -eq 1 ] && [ "$1" == "clean" ] ; then
    make clean
    if [ -d "${ANDROID_JNI}" ] ; then
        echo "Clean ANDROID_JNI"
        cd ${ANDROID_JNI}
        make clean
        cd ${PJ_DIR}
    fi
    if [ -d "${SWIG}" ] ; then
        echo "Clean SWIG"
        cd ${SWIG}
        make clean
        cd ${PJ_DIR}
    fi
    echo "Clean All"
    rm -rf ${LIBS}
    rm -rf $ROOT_LIBS
    echo "rm -rf ${LIBS}"
    echo "rm -rf $ROOT_LIBS"
    exit 1
fi

rm -f $LOG
rm -rf $ROOT_LIBS
rm -rf $LIBS
mkdir -p $ROOT_LIBS
mkdir -p ${LIBS}

export OPENSSL_HOME=/Users/young/workspace/Libraries/OpenSSL/output/android
#export OPENSSL_HOME=/Users/young/workspace/openssl-1.1.0h/openssl-lib
#export OPENSSL_HOME=/tmp/openssl_android

for ARCH in armeabi-v7a arm64-v8a
#for ARCH in arm64-v8a
do
    echo "Building for ${ARCH}"

    echo "cleanup exsiting binary files"
    make clean
    if [ -d "${ANDROID_JNI}" ];
    then
        cd ${ANDROID_JNI}
        make clean
        cd ${PJ_DIR}
    fi
    if [ -d "${SWIG}" ];
    then
        cd ${SWIG}
        make clean
        cd ${PJ_DIR}
    fi

    echo "OpenSSL ${OPENSSL_HOME}/${ARCH}"

    case "${ARCH}" in
        armeabi-v7a)
            TARGET_ABI=armeabi-v7a APP_PLATFORM=android-24 ./configure-android --use-ndk-cflags --with-ssl=${OPENSSL_HOME}/${ARCH} >> "$LOG"
            ;;
        arm64-v8a)
            TARGET_ABI=arm64-v8a APP_PLATFORM=android-24 ./configure-android --use-ndk-cflags --with-ssl=${OPENSSL_HOME}/${ARCH} >> "$LOG"
            ;;
    esac

    make dep >> "$LOG" && make >> "$LOG"
    echo "Building for ${ARCH} done"

    echo "Build pjsua2 sample application"
    cd ${SWIG}
    make >> $LOG
    cd ${PJ_DIR}
    if [ ! -d "${LIBS}/${ARCH}" ];
    then
        mkdir -p ${LIBS}/${ARCH}
    fi
    if [ ! -d "$ROOT_LIBS/${ARCH}" ]; then
        mkdir -p $ROOT_LIBS/${ARCH}
    fi
    cp ${SWIG}/java/android/pjsua2/src/main/jniLibs/${ARCH}/*.so ${LIBS}/${ARCH}
    cp ${SWIG}/java/android/pjsua2/src/main/jniLibs/${ARCH}/*.so $ROOT_LIBS/${ARCH}
    echo "Building android application for ${ARCH} done"

    #echo "Build pjsua sample application with telnet interface"
    #export EXCLUDE_APP=0
    #cd ${ANDROID_JNI}
    #make
    #cd ${PJ_DIR}
    #echo "Building sample application with telnet interface for ${ARCH} done"
done


echo "All done"
