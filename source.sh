#!/bin/sh -ev
mkdir -p $SRCDIR
cd $SRCDIR

if [ \! -f jpeg* ]; then
    curl -O http://www.ijg.org/files/jpegsrc.v9.tar.gz
fi

if [ \! -f libpng* ]; then
    curl -O -L http://downloads.sourceforge.net/libpng/libpng-1.6.7.tar.gz
fi

if [ \! -f lua* ]; then
    curl -O http://www.lua.org/ftp/lua-5.1.5.tar.gz
fi

if [ \! -f ode* ]; then
    curl -O -L http://downloads.sourceforge.net/opende/ode-0.12.tar.bz2
fi

if [ \! -f xmoto* ]; then
    curl -O http://download.tuxfamily.org/xmoto/xmoto/0.5.10/xmoto-0.5.10-src.tar.gz
fi

if [ \! -f SDL-1.* ]; then
    curl -O http://www.libsdl.org/release/SDL-1.2.15-OSX10.4.dmg
fi

if [ \! -f SDL_mixer* ]; then
    curl -O http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.11.dmg
fi

if [ \! -f SDL_ttf* ]; then
    curl -O http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.10.dmg
fi

if [ \! -e SDL_net* ]; then
    if hash hg 2>/dev/null; then
      hg clone -b SDL-1.2 http://hg.libsdl.org/SDL_net/
    else
      curl -O http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.7.dmg
    fi
fi

if [ \! -f gettext* ]; then
    curl -O http://ftp.gnu.org/gnu/gettext/gettext-0.18.3.1.tar.gz
fi

if [ \! -f SDLMain.m ]; then
    curl -O http://hg.libsdl.org/SDL/raw-file/SDL-1.2/src/main/macosx/SDLMain.m
fi
