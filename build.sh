#!/bin/sh -ev

export BASEDIR="$PWD"
if [ -n "$1" ]; then
    export VARDIR="$BASEDIR/$1"
    mkdir -p $VARDIR
    cd $VARDIR
else
    export VARDIR=$BASEDIR
fi

. $BASEDIR/envsetup.sh
trap '{ cd $BASEDIR; exit 1; }' EXIT
$BASEDIR/source.sh
$BASEDIR/dmg.sh
mkdir -p build; cd build

# devel-lite: The minimal SDLmain implementation
if [ \! -f $PREFIX/lib/libSDLmain.a ]; then
    rm -rf devel-lite; cp -R $SDLDIR/devel-lite devel-lite
    cp $SRCDIR/SDLMain.m devel-lite/ # Fix 10.9 -psn issue
    pushd devel-lite
    
    # Patch devel-lite so we chdir to the Resources dir
    patch -p0 < $PATCHDIR/devel-lite.patch
    
    $CC $CFLAGS -I$SDLDIR/SDL.framework/Headers -c -ObjC SDLMain.m
    ar cru libSDLmain.a SDLMain*.o && ranlib libSDLmain.a
    mkdir -p $PREFIX/lib && ln -f libSDLmain.a $PREFIX/lib/
    
    popd
fi

# jpeg
if [ \! -f $PREFIX/lib/libjpeg.dylib ]; then
    if [ \! -d jpeg* ]; then tar xf $SRCDIR/jpeg*; fi
    pushd jpeg*
    
    ./configure --prefix=$PREFIX --enable-shared --enable-static \
        --disable-dependency-tracking
    make -j$PARALLEL LDFLAGS="$SYSLIBROOT $ARCHES"
    make install
    
    popd
fi

# png
if [ \! -f $PREFIX/lib/libpng.dylib ]; then
    if [ \! -d libpng* ]; then tar xf $SRCDIR/libpng*; fi
    pushd libpng*
    
    CFLAGS="$OPT $ARCHES" CPPFLAGS="$INCPATH" LDFLAGS="$ARCHES $SYSLIBROOT" \
        ./configure --prefix=$PREFIX --disable-dependency-tracking
    make -j$PARALLEL && make install
    
    popd
fi

# lua
if [ \! -f $PREFIX/lib/liblua.a ]; then
    if [ \! -d lua* ]; then tar xf $SRCDIR/lua*; fi
    pushd lua*

    make -j$PARALLEL PLAT=macosx CC=$CC CFLAGS="$CFLAGS" \
        MYLDFLAGS="$ARCHES $SYSLIBROOT"
    make install INSTALL_TOP=$PREFIX
    
    popd
fi

# ode
if [ \! -f $PREFIX/lib/libode.dylib ]; then
    if [ \! -d ode* ]; then tar xf $SRCDIR/ode*; fi
    pushd ode*
    
    ./configure --prefix=$PREFIX --disable-dependency-tracking \
        --enable-double-precision --disable-demos --enable-shared
    make -j$PARALLEL && make install

    popd
fi

# gettext
if [ \! -f $PREFIX/lib/libintl.dylib ]; then
    if [ \! -d gettext* ]; then tar xf $SRCDIR/gettext*; fi
    pushd gettext*
    
    CFLAGS="$CFLAGS -I/usr/include/libxml2" \
        ./configure --prefix=$PREFIX --disable-java --disable-csharp \
        --disable-dependency-tracking
    make -j$PARALLEL && make install
    
    popd
fi

# install names
for lib in jpeg png ode intl; do
    install_name_tool -id @executable_path/../Libraries/lib$lib.dylib \
        $PREFIX/lib/lib$lib.dylib
done

# xmoto
if [ \! -f $PREFIX/bin/xmoto ]; then
    dir=`find . -maxdepth 1 -name xmoto\* -type d | head -n1`
    if [ \! -d "$dir" ]; then tar xf $SRCDIR/xmoto*; fi
    dir=`find . -maxdepth 1 -name xmoto\* -type d | head -n1`
    pushd $dir
    
#    ln -sf "/System/Library/Fonts/儷黑 Pro.ttf" asian.ttf
    cat $PATCHDIR/xmoto-*.patch | patch -p1 --forward || [ 1 = $? ]
    
    if [ \! -f configure ]; then
    	# Fix aclocal breakage
    	sed -e "s, /usr/share/autoconf, $XC3ROOT/usr/share/autoconf," \
    		< $XC3ROOT/usr/share/autoconf/autom4te.cfg \
    		> autom4te.cfg
    	AUTOM4TE_CFG="$PWD/autom4te.cfg" autoreconf -i
    fi
    
    if [ \! -f Makefile ]; then
        DYLD_FALLBACK_FRAMEWORK_PATH=$SDLDIR \
            DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib \
            OBJC="$CC" OBJCFLAGS="$CFLAGS" \
            CPPFLAGS="-DdDOUBLE -I$PREFIX/include -I/usr/include/libxml2 -F$SDLDIR" \
            LDFLAGS="-L$PREFIX/lib $ARCH_OPT $SYSLIBROOT -F$SDLDIR -Wl,-rpath,@executable_path/../Frameworks" \
            LIBS="-lxml2" \
            ./configure --prefix=$PREFIX --disable-dependency-tracking \
            --with-apple-opengl-framework \
            --with-sdl-framework=$SDLDIR/SDL.framework \
            --disable-sdltest \
            --with-internal-xdg=1 \
            --with-gamedatadir=. --with-localesdir='./locale' --with-x=no
#           --with-asian-ttf-file=Textures/Fonts/asian.ttf
    fi
    
    # if we're running xmoto -pack, we need to be able to find the libs
    # even though their install_paths are designed for the .app
    DYLD_FALLBACK_FRAMEWORK_PATH=$SDLDIR \
        DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib make -j$PARALLEL
    make install
#    cp asian.ttf $PREFIX/share/xmoto/Textures/Fonts/
    
    popd
fi

# detect the version
if [ \! -f xmoto*/Makefile ]; then
    echo "Can't detect version!"
    exit 1
fi
VERS=`perl -ne 'print "$1\n" if /^VERSION\s\D*(\d.*\d)/' xmoto*/Makefile`

# dot app
if [ \! -e X-Moto.app ]; then    
    mkdir -p X-Moto.app/Contents/{Frameworks,Resources}
    cp -f $RSRCDIR/PkgInfo X-Moto.app/Contents/
    cp -f $RSRCDIR/xmoto.icns X-Moto.app/Contents/Resources/
    cp -Rf $PREFIX/share/xmoto/* X-Moto.app/Contents/Resources/

    # update the version in the Info.plist
    sed -e "s/%VERS%/$VERS/g" $RSRCDIR/Info.plist > \
      X-Moto.app/Contents/Info.plist

    # include the frameworks
    for frm in SDL SDL_mixer SDL_ttf SDL_net; do
      rsync -a --exclude=.svn $SDLDIR/$frm.framework \
        X-Moto.app/Contents/Frameworks/
      # only for runtime, headers not needed
      rm -rf X-Moto.app/Contents/Frameworks/$frm.framework/Versions/A/Headers
    done

    # locales: include only the xmoto.mo
    rsync -av --include 'xmoto.mo' --include '*/' --exclude '*' \
        --prune-empty-dirs $PREFIX/share/locale/ \
        X-Moto.app/Contents/Resources/locale/
    $BASEDIR/locales.rb X-Moto.app/Contents/Resources/locale
    
    # code
    mkdir -p X-Moto.app/Contents/{Libraries,MacOS}
    for lib in jpeg png ode intl; do
        cp -Hf $PREFIX/lib/lib$lib.dylib X-Moto.app/Contents/Libraries/
    done
    cp -f xmoto*/src/xmoto X-Moto.app/Contents/MacOS/
    # strip X-Moto.app/Contents/MacOS/xmoto
fi

trap - EXIT
