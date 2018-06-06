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

PKG_NAME="freetype"
PKG_VERSION="2.9"
PKG_SHA256="e6ffba3c8cef93f557d1f767d7bc3dee860ac7a3aaff588a521e081bc36f4c8a"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freetype.org"
PKG_URL="http://download.savannah.gnu.org/releases/freetype/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib libpng freetype:host"
PKG_DEPENDS_HOST="zlib:host libpng:host"
PKG_SECTION="print"
PKG_SHORTDESC="freetype: TrueType font rendering library"
PKG_LONGDESC="The FreeType engine is a free and portable TrueType font rendering engine. It has been developed to provide TT support to a great variety of platforms and environments."
PKG_TOOLCHAIN="configure"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="LIBPNG_CFLAGS=-I$SYSROOT_PREFIX/usr/include \
                           LIBPNG_LDFLAGS=-L$SYSROOT_PREFIX/usr/lib \
                           --with-zlib \
                           --with-harfbuzz=no"

# host specific configure options
PKG_CONFIGURE_OPTS_HOST="LIBPNG_CFLAGS=-I$TOOLCHAIN/include \
                           LIBPNG_LDFLAGS=-L$TOOLCHAIN/lib \
                           --with-zlib \
                           --with-harfbuzz=no"

post_makeinstall_target() {
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/freetype-config
  ln -v -sf $SYSROOT_PREFIX/usr/include/freetype2 $SYSROOT_PREFIX/usr/include/freetype

  rm -rf $INSTALL/usr/bin
}
