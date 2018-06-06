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
PKG_VERSION="1.15.12"
PKG_SHA256="7623081b94548a47ee6839a7312af34e9322997806948b6eec421a8c6d0594c9"
PKG_LICENSE="LGPL"
PKG_SITE="https://cairographics.org/snapshots/?C=M;O=D"
PKG_URL="https://cairographics.org/snapshots/cairo-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman"
PKG_SECTION="graphics"
PKG_SHORTDESC="cairo: Multi-platform 2D graphics library"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support. Currently supported output targets include the X Window System and in-memory image buffers. PostScript and PDF file output is planned. Cairo is designed to produce identical output on all output media while taking advantage of display hardware acceleration when available."
PKG_TOOLCHAIN="configure" # ToDo
#PKG_TOOLCHAIN="autotools"

if [ "$OPENGL" != "no" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGL"
fi

if [ "$OPENGLES" != "no" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGLES"
fi

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXrender libX11 mesa"
  PKG_CAIRO_CONFIG="--x-includes="$SYSROOT_PREFIX/usr/include" \
                    --x-libraries="$SYSROOT_PREFIX/usr/lib" \
                    --enable-xlib \
                    --enable-xlib-xrender \
                    --enable-gl \
                    --enable-glx \
                    --disable-glesv2 \
                    --disable-egl \
                    --with-x"

elif [ "$DISPLAYSERVER" = "weston" ]; then
  PKG_CAIRO_CONFIG="--disable-xlib \
                    --disable-xlib-xrender \
                    --disable-gl \
                    --disable-glx \
                    --enable-glesv2 \
                    --enable-egl \
                    --without-x"
else
  PKG_CAIRO_CONFIG="--disable-xlib \
                    --disable-xlib-xrender \
                    --disable-gl \
                    --disable-glx \
                    --disable-glesv2 \
                    --disable-egl \
                    --without-x"
fi

PKG_CONFIGURE_OPTS_TARGET="$PKG_CAIRO_CONFIG \
                           --enable-silent-rules \
                           --enable-shared \
                           --disable-static \
                           --disable-gtk-doc \
                           --enable-largefile \
                           --enable-atomic \
                           --disable-gcov \
                           --disable-valgrind \
                           --disable-xcb \
                           --disable-xlib-xcb \
                           --disable-xcb-shm \
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
                           --disable-drm \
                           --disable-drm-xr \
                           --disable-gallium \
                           --disable-xcb-drm \
                           --enable-png \
                           --disable-directfb \
                           --disable-vg \
                           --disable-wgl \
                           --disable-script \
                           --enable-ft \
                           --enable-fc \
                           --enable-ps \
                           --enable-pdf \
                           --enable-svg \
                           --disable-test-surfaces \
                           --disable-tee \
                           --disable-xml \
                           --enable-pthread \
                           --enable-gobject \
                           --disable-full-testing \
                           --disable-trace \
                           --enable-interpreter \
                           --disable-symbol-lookup \
                           --enable-some-floating-point \
                           --with-gnu-ld"
