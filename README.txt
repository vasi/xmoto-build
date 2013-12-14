INTRODUCTION

This is a script to package X-Moto ( http://xmoto.tuxfamily.org ) for Mac OS X. It takes care of all the nastiness that folks often forget to deal with:

* Self-contained .app bundle, no installer needed
* Works on Mac OS X 10.6 and higher
* Detects locales properly
* Doesn't hardcode any paths


INSTRUCTIONS

Install Xcode 3, the prefix I prefer is /Library/Xcode3. To install it on a recent version of OS X: http://lapcatsoftware.com/articles/xcode3onmountainlion.html

Open the terminal, and cd into the parent directory of this README. Then run ./build.sh . You will end up with a nice .dmg containing X-Moto in the 'build' directory.

To build multi-arch for distribution, I recommend using dist.sh .


NOTES

* Script is verified to build X-Moto on 10.9 with Xcode 3 installed.

* Various options are in envsetup.sh. Includes:
  - Xcode 3 prefix
  - Architectures (currently i386/x86_64)
  - SDK (currently 10.6)
  - GCC optimization flags (currently -Os)

* To update the packages used by the script, edit source.sh, and remove files from 'src'.


TODO

* Submit my patches to xmoto maintainers
* Make my SVN repo cleaner
* Eventually make the system more elegant and robust
* Ensure no outside utilities (Fink, MacPorts) are being used
* Make it build with Xcode 4?
* Fix Asian font issues


PATCHES

* devel-lite: Make X-Moto chdir to the .app/Contents/Resources directory, so it can find the xmoto.bin and other such resources.

* xmoto-mac-dirs: Put prefs and such in ~/Library directories. Maybe there should be some sort of migration procedure?

* xmoto-libxml2: Don't use xml2-config, it has trouble with SDKs.

* xmoto-jpeg: Handle 'boolean' being doubly defined.


AUTHORS

Dave Vasilevsky has packaged X-Moto for Mac OS X since version 0.1.7. He is a core member of the Fink project, which ports and packages Unixy software on Mac OS X.


LICENSE

Build scripts and patches provided under a BSD License. The software built (both source and binary) are used under the licenses provided by their copyright holders--no additional rights are claimed by the build script authors.


Built software:

jpeg, libpng: Permissive licenses 
lua: MIT license
SDL libraries, ODE: GNU Lesser General Public License v2.1
gettext: GNU General Public License v3
xmoto: GNU General Public License v2


These scripts:

Copyright (c) 2008, Dave Vasilevsky
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

The names of the copyright holders may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
