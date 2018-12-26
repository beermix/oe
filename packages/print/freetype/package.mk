# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="freetype"
PKG_VERSION="2.9.1"
PKG_SHA256="db8d87ea720ea9d5edc5388fc7a0497bb11ba9fe972245e0f7f4c7e8b1e1e84d"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freetype.org"
PKG_URL="http://download.savannah.gnu.org/releases/freetype/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib bzip2 libpng"
PKG_DEPENDS_HOST="zlib:host zlib:host bzip2:host libpng:host"
PKG_LONGDESC="The FreeType engine is a free and portable TrueType font rendering engine."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+hardening"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="LIBPNG_CFLAGS=-I$SYSROOT_PREFIX/usr/include \
                           LIBPNG_LDFLAGS=-L$SYSROOT_PREFIX/usr/lib \
                           --with-zlib=yes \
                           --with-bzip2=yes \
                           --with-png=yes \
                           --enable-freetype-config \
                           --with-harfbuzz=no"

# host specific configure options
PKG_CONFIGURE_OPTS_HOST="LIBPNG_CFLAGS=-I$TOOLCHAIN/include \
                           LIBPNG_LDFLAGS=-L$TOOLCHAIN/lib \
                           --with-zlib=yes \
                           --with-bzip2=yes \
                           --with-png=yes \
                           --enable-freetype-config \
                           --with-harfbuzz=no"

pre_configure_target() {
  # unset LIBTOOL because freetype uses its own
    ( cd ..
      unset LIBTOOL
      sh autogen.sh

  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"    )
}

post_makeinstall_target() {
  sed -e "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/freetype-config
  ln -v -sf $SYSROOT_PREFIX/usr/include/freetype2 $SYSROOT_PREFIX/usr/include/freetype

  rm -rf $INSTALL/usr/bin
}
