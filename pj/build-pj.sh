#!/bin/sh

BASE_DIR=$(pwd)

# Create config_site.h file in path
echo "#define PJ_CONFIG_IPHONE 1
#define PJ_HAS_IPV6 1
#include <pj/config_site_sample.h>" > pjlib/include/pj/config_site.h


# Compile Library and Build For Default iPhone 4 use armv7 architecture
ARCH='-arch armv7' ./configure-iphone && make dep && make clean && make


# Build For iPhone 5, use armv7s architecture
ARCH='-arch armv7s' ./configure-iphone && make dep && make clean && make


# Build For iPhone 5s, use arm64 architecture
ARCH='-arch arm64' ./configure-iphone && make dep && make clean && make


# Build For Simulator, use i386 architecture
export DEVPATH=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
ARCH="-arch i386" CFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" LDFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" ./configure-iphone
make dep && make clean && make


# Build For Simulator, use x86_64 architecture
export DEVPATH=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
ARCH="-arch x86_64" CFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" LDFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" ./configure-iphone
make dep && make clean && make


# Create (arm64,armv7,armv7s,i386, x86_64, unified) Folder
if [ ! -d libs/arm64 ];
then
mkdir -p libs/arm64
echo "arm64 Folder created"
else
echo "arm64 Folder exists"
fi

if [ ! -d libs/armv7 ];
then
mkdir -p libs/armv7
echo "armv7 Folder created"
else
echo "armv7 Folder exists"
fi

if [ ! -d libs/armv7s ];
then
mkdir -p libs/armv7s
echo "armv7s Folder created"
else
echo "armv7s Folder exists"
fi

if [ ! -d libs/i386 ];
then
mkdir -p libs/i386
echo "i386 Folder created"
else
echo "i386 Folder exists"
fi

if [ ! -d libs/x86_64 ];
then
mkdir -p libs/x86_64
echo "x86_64 Folder created"
else
echo "x86_64 Folder exists"
fi

if [ ! -d libs/unified ];
then
mkdir -p libs/unified
echo "unified Folder created"
else
echo "unified Folder exists"
fi


# Copy From pjlib folder to Libs

cp pjlib/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp pjlib/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp pjlib/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp pjlib/lib/*-i386-apple-darwin_ios.a libs/i386/
cp pjlib/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/

# Copy From pjlib-util folder to Libs

cp pjlib-util/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp pjlib-util/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp pjlib-util/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp pjlib-util/lib/*-i386-apple-darwin_ios.a libs/i386/
cp pjlib-util/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/

# Copy From pjmedia folder to Libs

cp pjmedia/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp pjmedia/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp pjmedia/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp pjmedia/lib/*-i386-apple-darwin_ios.a libs/i386/
cp pjmedia/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/

# Copy From pjnath folder to Libs

cp pjnath/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp pjnath/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp pjnath/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp pjnath/lib/*-i386-apple-darwin_ios.a libs/i386/
cp pjnath/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/

# Copy From pjsip folder to Libs

cp pjsip/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp pjsip/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp pjsip/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp pjsip/lib/*-i386-apple-darwin_ios.a libs/i386/
cp pjsip/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/

# Copy From third_party folder to Libs

cp third_party/lib/*-arm64-apple-darwin_ios.a libs/arm64/
cp third_party/lib/*-armv7-apple-darwin_ios.a libs/armv7/
cp third_party/lib/*-armv7s-apple-darwin_ios.a libs/armv7s/
cp third_party/lib/*-i386-apple-darwin_ios.a libs/i386/
cp third_party/lib/*-x86_64-apple-darwin_ios.a libs/x86_64/


# Rename file name From Created folder

cd $BASE_DIR/libs/arm64/
rename 's/\-arm64\-apple\-darwin_ios//g' *.a

cd $BASE_DIR/libs/armv7/
rename 's/\-armv7\-apple\-darwin_ios//g' *.a

cd $BASE_DIR/libs/armv7s/
rename 's/\-armv7s\-apple\-darwin_ios//g' *.a

cd $BASE_DIR/libs/i386/
rename 's/\-i386\-apple\-darwin_ios//g' *.a

cd $BASE_DIR/libs/x86_64/
rename 's/\-x86_64\-apple\-darwin_ios//g' *.a


cd $BASE_DIR/libs/

# Combine Libs to united folder

export LIB_NAME="libg7221codec.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libgsmcodec.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libilbccodec.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpj.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjlib-util.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjmedia-audiodev.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjmedia-codec.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjmedia-videodev.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjmedia.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjnath.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsdp.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsip-simple.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsip-ua.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsip.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsua.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libpjsua2.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libresample.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libspeex.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libsrtp.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libyuv.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME

export LIB_NAME="libwebrtc.a"
lipo -arch armv7 armv7/$LIB_NAME -arch armv7s armv7s/$LIB_NAME -arch arm64 arm64/$LIB_NAME -arch i386 i386/$LIB_NAME -arch x86_64 x86_64/$LIB_NAME -create -output unified/$LIB_NAME



echo 'Congratulation you have built PJSIP Library successfully'
