#!/bin/sh -ev

export OPT='-Os'

# 10.4 Universal PPC/Intel
export MACOSX_DEPLOYMENT_TARGET=10.4
export SDK=/Developer/SDKs/MacOSX10.4u.sdk
export GCC_VERSION=4.0
export ARCHES="-arch i386 -arch ppc"
./build.sh 32bit

# 10.6 64-bit
export MACOSX_DEPLOYMENT_TARGET=10.6
export SDK=/Developer/SDKs/MacOSX10.6.sdk
export GCC_VERSION=4.2
export ARCHES="-arch x86_64"
./build.sh 64bit

merge() {
    lipo -create -output 64bit/build/X-Moto.app/Contents/$1 \
        64bit/build/X-Moto.app/Contents/$1 32bit/build/X-Moto.app/Contents/$1
}

# merge 'em with lipo
merge MacOS/xmoto
for lib in intl jpeg ode png; do
    merge Libraries/lib$lib.dylib
done

# zip it
VERS=`perl -ne 'print "$1\n" if /^VERSION\s\D*(\d.*\d)/' \
    64bit/build/xmoto*/Makefile`
ditto -ck --sequesterRsrc --keepParent 64bit/build/X-Moto.app \
    "xmoto-$VERS-macosx.zip"
