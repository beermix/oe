# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="freetype"
PKG_VERSION="2.10.0"
PKG_SHA256="fccc62928c65192fff6c98847233b28eb7ce05f12d2fea3f6cc90e8b4e5fbe06"
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
                           --with-zlib \
                           --with-bzip2=yes \
                           --with-png=yes \
                           --enable-freetype-config \
                           --with-harfbuzz=no"

# host specific configure options
PKG_CONFIGURE_OPTS_HOST="LIBPNG_CFLAGS=-I$TOOLCHAIN/include \
                           LIBPNG_LDFLAGS=-L$TOOLCHAIN/lib \
                           --with-zlib \
                           --with-bzip2=yes \
                           --with-png=yes \
                           --enable-freetype-config \
                           --with-harfbuzz=no"

pre_configure_target() {
  # unset LIBTOOL because freetype uses its own
    ( cd ..
      unset LIBTOOL
      sh autogen.sh
    )

# export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
# export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
}

post_makeinstall_target() {
  sed -e "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/freetype-config
  ln -v -sf $SYSROOT_PREFIX/usr/include/freetype2 $SYSROOT_PREFIX/usr/include/freetype

  rm -rf $INSTALL/usr/bin
}
