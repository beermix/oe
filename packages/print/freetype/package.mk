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
PKG_VERSION="2.8"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freetype.org"
PKG_URL="http://download.savannah.gnu.org/releases/freetype/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="zlib freetype:host"
PKG_DEPENDS_HOST="zlib:host"
PKG_SECTION="print"
PKG_SHORTDESC="freetype: TrueType font rendering library"
PKG_LONGDESC="The FreeType engine is a free and portable TrueType font rendering engine. It has been developed to provide TT support to a great variety of platforms and environments."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"

# target specific configure options
PKG_CONFIGURE_OPTS_TARGET="LIBPNG_CFLAGS=-I$SYSROOT_PREFIX/usr/include \
                           LIBPNG_LDFLAGS=-L$SYSROOT_PREFIX/usr/lib \
                           --with-zlib --with-harfbuzz=no --with-bzip2=no --with-png=no --disable-shared"

# host specific configure options
PKG_CONFIGURE_OPTS_HOST="LIBPNG_CFLAGS=-I$ROOT/$TOOLCHAIN/include \
			    LIBPNG_LDFLAGS=-L$ROOT/$TOOLCHAIN/lib \
			    --with-zlib --with-harfbuzz=no --with-bzip2=no  --with-png=no --disable-shared"

post_makeinstall_target() {
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/freetype-config
  ln -v -sf $SYSROOT_PREFIX/usr/include/freetype2 $SYSROOT_PREFIX/usr/include/freetype

  rm -rf $INSTALL/usr/bin
}

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  # unset LIBTOOL because freetype uses its own
    ( cd ..
      unset LIBTOOL
      sh autogen.sh
    )
}

pre_configure_host() {
  CFLAGS="$CFLAGS -fPIC"
  # unset LIBTOOL because freetype uses its own
    ( cd ..
      unset LIBTOOL
      sh autogen.sh
    )
}
