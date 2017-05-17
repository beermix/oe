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
PKG_VERSION="1.15.4"
PKG_URL="https://www.cairographics.org/snapshots/cairo-$PKG_VERSION.tar.xz"
#PKG_VERSION="1.14.8"
#PKG_URL="http://cairographics.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman libXrender libSM libX11 mesa glu"
PKG_SECTION="graphics"
PKG_SHORTDESC="cairo: Multi-platform 2D graphics library"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support. Currently supported output targets include the X Window System and in-memory image buffers. PostScript and PDF file output is planned. Cairo is designed to produce identical output on all output media while taking advantage of display hardware acceleration when available."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
CPPLAGS="$CPPLAGS -DCAIRO_NO_MUTEX=1"
LIBS="$LIBS -latomic"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_lzo2_lzo2a_decompress=no \
                           ac_cv_lib_bfd_bfd_openr=no \
                           --x-includes="$SYSROOT_PREFIX/usr/include" \
                           --x-libraries="$SYSROOT_PREFIX/usr/lib" \
                           --enable-xlib \
                           --enable-xlib-xrender \
                           --enable-gl \
                           --enable-xcb \
                           --enable-tee \
                           --enable-glx \
                           --with-x \
                           --enable-silent-rules \
                           --enable-statoc \
                           --enable-shared \
                           --enable-static"
