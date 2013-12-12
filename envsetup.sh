export XC3ROOT=${XC3ROOT-/Library/Xcode3}
export PATH=$XC3ROOT/usr/bin:$PATH

export SRCDIR=$BASEDIR/src
export SDLDIR=$BASEDIR/sdl
export PATCHDIR=$BASEDIR/patch
export RSRCDIR=$BASEDIR/resources

export PREFIX=$VARDIR/prefix

if [ -z "$ARCHES" ]; then
  # 10.4 Universal PPC/Intel
  export MACOSX_DEPLOYMENT_TARGET=10.4
  export SDK=$XC3ROOT/SDKs/MacOSX10.4u.sdk
  export GCC_VERSION=4.0
  export ARCHES="-arch i386 -arch ppc"
fi

if [ -z "$OPT" ]; then
    export OPT='-O0 -g'
fi

export INCPATH="-isysroot $SDK -I$PREFIX/include"
export SYSLIBROOT="-Wl,-syslibroot,$SDK"

export CC=gcc-$GCC_VERSION
export CXX=g++-$GCC_VERSION
export CFLAGS="$OPT $ARCHES $INCPATH"
export CXXFLAGS="$CFLAGS"

export PARALLEL=`sysctl hw.ncpu | perl -ne 's/\D//g; print $_+1'`
