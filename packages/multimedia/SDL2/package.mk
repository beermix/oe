################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="SDL2"
PKG_VERSION="2.0.7"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://www.libsdl.org/release/SDL2-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="SDL-mirror-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain cmake:host yasm:host alsa-lib systemd dbus"
PKG_SECTION="multimedia"
PKG_SHORTDESC="SDL2: A cross-platform Graphic API"
PKG_LONGDESC="Simple DirectMedia Layer is a cross-platform multimedia library designed to provide fast access to the graphics framebuffer and audio device. It is used by MPEG playback software, emulators, and many popular games, including the award winning Linux port of 'Civilization: Call To Power.' Simple DirectMedia Layer supports Linux, Win32, BeOS, MacOS, Solaris, IRIX, and FreeBSD."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="-parallel"

PKG_CMAKE_OPTS_TARGET="-DSDL_STATIC=OFF \
		       -DDUMMYAUDIO=OFF \
		       -DOSS=OFF \
		       -DRPATH=OFF \
		       -DVIDEO_DUMMY=OFF \
		       -DDISKAUDIO=OFF"
if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXrandr"

  PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_TARGET -DVIDEO_X11_XINERAMA=OFF -DVIDEO_X11_XVM=OFF"
fi

if [ ! "$OPENGL" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL glu"
fi

if [[ "$PROJECT" =~ "RPi" ]]; then
  PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_TARGET -DVIDEO_X11=OFF"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

post_makeinstall_target() {
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/sdl2-config

  rm -rf $INSTALL/usr/bin
}
