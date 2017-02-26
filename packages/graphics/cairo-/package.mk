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

PKG_NAME="cairo"
PKG_VERSION="1.14.8"
PKG_SITE="http://cairographics.org/"
PKG_URL="http://cairographics.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman"
PKG_SECTION="graphics"
PKG_SHORTDESC="cairo: Multi-platform 2D graphics library"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support. Currently supported output targets include the X Window System and in-memory image buffers. PostScript and PDF file output is planned. Cairo is designed to produce identical output on all output media while taking advantage of display hardware acceleration when available."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -D_DEFAULT_SOURCE"
  export CPPLAGS="$CPPLAGS -DCAIRO_NO_MUTEX=1"
  #export LIBS="$LIBS -latomic"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
                           --disable-static \
                           --disable-gtk-doc \
                           --enable-largefile \
                           --enable-atomic \
                           --disable-valgrind \
                           --disable-qt \
                           --disable-quartz \
                           --disable-quartz-font \
                           --disable-quartz-image \
                           --disable-win32 \
                           --disable-win32-font \
                           --disable-skia \
                           --disable-os2 \
                           --disable-beos \
                           --disable-cogl \
                           --disable-gallium \
                           --enable-png \
                           --enable-ft \
                           --enable-fc \
                           --enable-ps \
                           --enable-pdf \
                           --enable-svg \
                           --disable-test-surfaces \
                           --enable-pthread \
                           --disable-full-testing \
                           --disable-trace \
                           --enable-interpreter \
                           --enable-some-floating-point \
                           --with-gnu-ld"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXrender libX11 mesa glu"
  PKG_CONFIGURE_OPTS_TARGET+=" --x-includes="$SYSROOT_PREFIX/usr/include" \
                               --x-libraries="$SYSROOT_PREFIX/usr/lib" \
                               --enable-xlib \
                               --enable-xlib-xrender \
                               --enable-gl \
                               --enable-glx \
                               --disable-glesv2 \
                               --disable-egl \
                               --with-x \
                               --disable-drm \
                               --disable-xlib-xcb"

elif [ "$DISPLAYSERVER" = "weston" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-xlib \
                               --disable-xlib-xrender \
                               --disable-gl \
                               --disable-glx \
                               --enable-glesv2 \
                               --enable-egl \
                               --without-x"
fi
