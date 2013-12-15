export PATH=/usr/bin:/bin:/usr/sbin:/sbin

export SRCDIR=$BASEDIR/src
export SDLDIR=$BASEDIR/sdl
export PATCHDIR=$BASEDIR/patch
export RSRCDIR=$BASEDIR/resources

export PREFIX=$VARDIR/prefix

if [ -z "$ARCHES" ]; then
  export MACOSX_DEPLOYMENT_TARGET=10.8
  export SDKROOT=$(xcrun --show-sdk-path --sdk macosx10.8)
  export ARCHES="-arch x86_64"
fi

if [ -z "$OPT" ]; then
    export OPT='-O0 -g'
fi

export INCPATH="-I$PREFIX/include"

export CC="cc"
export CXX="c++"
export CFLAGS="$OPT $ARCHES $INCPATH"
export CXXFLAGS="$CFLAGS"

export PARALLEL=`sysctl hw.ncpu | perl -ne 's/\D//g; print $_+1'`
