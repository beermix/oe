# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libaio"
PKG_VERSION="0.3.111"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="http://lse.sourceforge.net/io/aio.html"
PKG_URL="http://http.debian.net/debian/pool/main/liba/libaio/${PKG_NAME}_${PKG_VERSION}.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="-lto -gold -parallel"

make_target() {
  make -C src
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR src/libaio.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PR src/libaio.h $SYSROOT_PREFIX/usr/include
}

make_host() {
  make -C src
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib
    cp -PR src/libaio.a $TOOLCHAIN/lib

  mkdir -p $TOOLCHAIN/include
    cp -PR src/libaio.h $TOOLCHAIN/include
}
