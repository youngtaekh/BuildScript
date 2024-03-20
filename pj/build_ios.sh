#!/bin/sh

BASE_DIR=$(pwd)
OPEN_SSL=/Users/young/workspace/Libraries/OpenSSL/output/ios
ROOT_LIBS=/tmp/pj/ios
LOG=$BASE_DIR/ios_result.log

ARCHS="armv7 arm64"

# Create config_site.h file in path
echo "#define PJ_CONFIG_IPHONE 1
#define PJ_HAS_SSL_SOCK 1
#include <pj/config_site_sample.h>" > pjlib/include/pj/config_site.h

echo "Delete libs folder"
rm -rf libs/ios
rm -rf $ROOT_LIBS
rm -f $LOG

for IOS_TARGET_PLATFORM in $ARCHS
do
    echo "Building for ${IOS_TARGET_PLATFORM}"
    if [ "${IOS_TARGET_PLATFORM}" == "armv7" ]; then

        # Compile Library and Build For Default iPhone 4 use armv7 architecture
        ARCH='-arch armv7' MIN_IOS="-miphoneos-version-min=10.0" ./configure-iphone --with-ssl=${OPEN_SSL}/armv7/ >> $LOG

    elif [ "${IOS_TARGET_PLATFORM}" == "armv7s" ]; then

        # Build For iPhone 5, use armv7s architecture
        ARCH='-arch armv7s' ./configure-iphone

    elif [ "${IOS_TARGET_PLATFORM}" == "arm64" ]; then

        # Build For iPhone 5s, use arm64 architecture
        export MIN_IOS="-miphoneos-version-min=10.0"
        ARCH='-arch arm64' ./configure-iphone --with-ssl=${OPEN_SSL}/arm64/ >> $LOG

    elif [ "${IOS_TARGET_PLATFORM}" == "i386" ]; then

        # Build For Simulator, use i386 architecture
        export DEVPATH=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
        ARCH="-arch i386" CFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" LDFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" ./configure-iphone

    elif [ "${IOS_TARGET_PLATFORM}" == "x86_64" ]; then

        # Build For Simulator, use x86_64 architecture
        export DEVPATH=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
        ARCH="-arch x86_64" CFLAGS="-O2 -m32 -mios-simulator-version-min=5.0"LDFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" ./configure-iphone

    fi
    make dep >> $LOG && make clean >> $LOG && make >> $LOG

    # Create (arm64,armv7,armv7s,i386, x86_64, unified) Folder
    if [ ! -d libs/ios/${IOS_TARGET_PLATFORM} ]; then
        mkdir -p libs/ios/${IOS_TARGET_PLATFORM}
        echo "${IOS_TARGET_PLATFORM} Folder created"
    fi

    # Copy From library folder to Libs
    cp pjlib/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/
    cp pjlib-util/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/
    cp pjmedia/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/
    cp pjnath/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/
    cp pjsip/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/
    cp third_party/lib/*-${IOS_TARGET_PLATFORM}-apple-darwin_ios.a libs/ios/${IOS_TARGET_PLATFORM}/

    # Rename file name From Created folder
    cd $BASE_DIR/libs/ios/$IOS_TARGET_PLATFORM
    rename "s/\-${IOS_TARGET_PLATFORM}\-apple\-darwin_ios//g" *.a
    cd $BASE_DIR/
done

cd $BASE_DIR/libs/ios/
if [ ! -d all_arch ]; then
    mkdir all_arch
    echo "all_arch folder created"
fi
if [ ! -d $ROOT_LIBS ]; then
    mkdir -p $ROOT_LIBS
fi

echo "Copy OpenSSL Library"
cp $OPEN_SSL/openssl-universal/*.a all_arch
cp $OPEN_SSL/openssl-universal/*.a $ROOT_LIBS

# Combine Libs to united folder

for LIB_NAME in g7221codec gsmcodec ilbccodec pj pjlib-util pjmedia-audiodev pjmedia-codec pjmedia-videodev pjmedia pjnath pjsdp pjsip-simple pjsip-ua pjsip pjsua pjsua2 resample speex srtp yuv webrtc
do
    CMD=""
    for ARCH in $ARCHS
    do
        CMD="$CMD -arch $ARCH $ARCH/lib$LIB_NAME.a"
    done
    CMD="$CMD -create -output all_arch/lib$LIB_NAME.a"
    lipo $CMD
    cp all_arch/lib$LIB_NAME.a $ROOT_LIBS/
    echo "$CMD"
done

echo 'Congratulation you have built PJSIP Library successfully'
