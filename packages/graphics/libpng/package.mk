# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# --enable-hardware-optimization

PKG_NAME="libpng"
PKG_VERSION="1.6.35"
PKG_SHA256="23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7"
PKG_LICENSE="OSS"
PKG_SITE="http://www.libpng.org/"
PKG_URL="$SOURCEFORGE_SRC/libpng/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SHORTDESC="libpng: Portable Network Graphics (PNG) Reference Library"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic +pic:host +hardening"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_z_zlibVersion=yes \
                           --enable-static \
                           --enable-shared \
                           --enable-hardware-optimizations \
                           --enable-arm-neon=no \
                           --enable-mips-msa=no \
                           --enable-intel-sse=yes \
                           --enable-powerpc-vsx=no --disable-silent-rules"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"

pre_configure_host() {
  export CPPFLAGS="$CPPFLAGS -I$TOOLCHAIN/include"
}

pre_configure_target() {
  export CPPFLAGS="$CPPFLAGS -I$SYSROOT_PREFIX/usr/include"
}

post_makeinstall_target() {
  sed -e "s:\([\"'= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" \
      -e "s:libs=\"-lpng16\":libs=\"-lpng16 -lz\":g" \
      -i $SYSROOT_PREFIX/usr/bin/libpng*-config

  rm -rf $INSTALL/usr/bin
}
