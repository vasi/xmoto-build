#!/bin/sh -ev

for lib in '' _mixer _net _ttf; do
    if [ \! -d $SDLDIR/SDL$lib.framework -a -f $SRCDIR/SDL$lib-*.dmg ]; then
        mkdir -p $SDLDIR/mountpoint
        trap '{ hdiutil detach sdl/mountpoint; exit 1; }' EXIT
        hdiutil attach -nobrowse -noautoopen -mountpoint $SDLDIR/mountpoint \
            $SRCDIR/SDL$lib-*.dmg
        cp -R $SDLDIR/mountpoint/* $SDLDIR/
        hdiutil detach $SDLDIR/mountpoint
        trap - EXIT
    fi
done
