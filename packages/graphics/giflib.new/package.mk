# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="giflib"
PKG_VERSION="5.2.1"
PKG_SHA256=""
PKG_LICENSE="OSS"
PKG_SITE="http://giflib.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/giflib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="giflib: giflib service library"
PKG_BUILD_FLAGS="+pic:host"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

make_target() {
  PKG_MAKE_OPTS_TARGET="PREFIX=/usr shared-lib"
  PKG_MAKEINSTALL_OPTS_TARGET="PREFIX=/usr install-shared-lib"
}

make_host() {
  cd $PKG_BUILD/.$HOST_NAME
  make PREFIX=${TOOLCHAIN} static-lib
} 

makeinstall_host() {
  cd $PKG_BUILD/.$HOST_NAME
  make PREFIX=${TOOLCHAIN} install-static-lib
}
