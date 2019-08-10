# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libaacs"
PKG_VERSION="9da2b68"
PKG_LICENSE="GPL"
PKG_SITE="http://www.videolan.org/developers/libaacs.html"
PKG_URL="ftp://ftp.videolan.org/pub/videolan/libaacs/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgcrypt"
PKG_LONGDESC="libaacs is a research project to implement the Advanced Access Content System specification."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-werror \
                           --disable-extra-warnings \
                           --disable-optimizations \
                           --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr \
                           --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/aacs
    cp -P ../KEYDB.cfg $INSTALL/usr/config/aacs
}
