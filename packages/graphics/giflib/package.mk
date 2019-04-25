# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="giflib"
PKG_VERSION="5.1.9"
PKG_SHA256=""
PKG_LICENSE="OSS"
PKG_SITE="http://giflib.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/giflib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="giflib: giflib service library"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"
PKG_CONFIGURE_OPTS_TARGET="--with-sysroot=$SYSROOT_PREFIX"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
