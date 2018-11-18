# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libaio"
PKG_VERSION="0.3.111"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://lse.sourceforge.net/io/aio.html"
PKG_URL="http://http.debian.net/debian/pool/main/liba/libaio/${PKG_NAME}_${PKG_VERSION}.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="libaio: Kernel Asynchronous I/O (AIO) Support for Linux"
PKG_LONGDESC="AIO enables even a single application thread to overlap I/O operations with other processing, by providing an interface for submitting one or more I/O requests in one system call (io_submit()) without waiting for completion, and a separate interface (io_getevents()) to reap completed I/O operations associated with a given completion group."
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
