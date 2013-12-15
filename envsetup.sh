export XC3ROOT=${XC3ROOT-/Library/Xcode3}
export PATH=$XC3ROOT/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin

export SRCDIR=$BASEDIR/src
export SDLDIR=$BASEDIR/sdl
export PATCHDIR=$BASEDIR/patch
export RSRCDIR=$BASEDIR/resources

export PREFIX=$VARDIR/prefix

if [ -z "$ARCHES" ]; then
  # 10.4 Universal PPC/Intel
  export MACOSX_DEPLOYMENT_TARGET=10.6
  export SDKID=MacOSX10.6.sdk
  export GCC_VERSION=4.2
  export ARCHES="-arch x86_64"
fi

if [ -z "$OPT" ]; then
    export OPT='-O0 -g'
fi

export SDK=$XC3ROOT/SDKs/$SDKID
export INCPATH="-isysroot $SDK -I$PREFIX/include"
export SYSLIBROOT="-Wl,-syslibroot,$SDK"

export CC=gcc-$GCC_VERSION
export CXX=g++-$GCC_VERSION
export CFLAGS="$OPT $ARCHES $INCPATH"
export CXXFLAGS="$CFLAGS"

export PARALLEL=`sysctl hw.ncpu | perl -ne 's/\D//g; print $_+1'`
