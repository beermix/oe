# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="freetype"
PKG_VERSION="2.10.1"
PKG_SHA256="16dbfa488a21fe827dc27eaf708f42f7aa3bb997d745d31a19781628c36ba26f"
PKG_LICENSE="GPL"
PKG_SITE="http://download.savannah.gnu.org/releases/freetype/?C=M&O=D"
PKG_URL="http://download.savannah.gnu.org/releases/freetype/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gcc:host"
PKG_DEPENDS_TARGET="toolchain zlib libpng"
PKG_LONGDESC="The FreeType engine is a free and portable TrueType font rendering engine."
PKG_TOOLCHAIN="configure"

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
}

post_makeinstall_target() {
  sed -e "s#prefix=/usr#prefix=${SYSROOT_PREFIX}/usr#" -i "${SYSROOT_PREFIX}/usr/lib/pkgconfig/freetype2.pc"

  cp -P "${PKG_BUILD}/.${TARGET_NAME}/freetype-config" "${SYSROOT_PREFIX}/usr/bin"
}
