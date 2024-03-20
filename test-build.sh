#! /usr/bin/env bash

ARCHS="armv7 arm64"
CMD=""
for LIB_NAME in liba.a libb.a
do
    CMD="lipo "
    for ARCH in ${ARCHS}
    do
        CMD="$CMD -arch $ARCH $ARCH/$LIB_NAME"
    done
    echo "$CMD"
done

for TEST in arm64 armv7
do
    echo "TEST is ${TEST}"
    rename "s/\-${TEST}\-apple\-darwin_ios//g" *.a
    if [ "${TEST}" == "abc" ]; then
        echo "equal"
    fi
done
PJ_DIR=${PWD}
ANDROID_JNI=pjsip-apps/src/pjsua/android/jni
if [ $# -eq 1 ] && [ "$1" == "aaa" ]; then
    echo "parameter is aaa"
    exit 1
fi

if [ -z $1 ]; then
    echo "param 1 is emptyi"
else
    echo "param is $1"
fi
if [ -z $2 ]; then
    echo "param 2 is empty"
fi

if [ -d "${ANDROID_JNI}" ];
then
    echo "111"
    cd ${ANDROID_JNI}
    cd ${PJ_DIR}
    touch done.txt
fi
echo "All done"

