#!/bin/sh -ev

export OPT='-Os'

# 10.6 Intel
export MACOSX_DEPLOYMENT_TARGET=10.6
export SDKID=MacOSX10.6.sdk
export GCC_VERSION=4.2
export ARCHES="-arch i386 -arch x86_64"
./build.sh intel

merge() {
    lipo -create -output $2/build/X-Moto.app/Contents/$1 \
        $2/build/X-Moto.app/Contents/$1 $3/build/X-Moto.app/Contents/$1
}

# merge 'em with lipo
mergeall() {
    merge MacOS/xmoto $1 $2
    for lib in intl jpeg ode png; do
        merge Libraries/lib$lib.dylib $1 $2
    done
}

# No need to merge, we have just one target
#mergeall 64bit 32bit

# zip it
VERS=`perl -ne 'print "$1\n" if /^VERSION\s\D*(\d.*\d)/' \
    intel/build/xmoto*/Makefile`
ditto -ck --sequesterRsrc --keepParent intel/build/X-Moto.app \
    "xmoto-$VERS-macosx.zip"
