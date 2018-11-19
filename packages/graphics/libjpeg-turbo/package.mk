# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libjpeg-turbo"
PKG_VERSION="2.0.0"
PKG_SHA256="778876105d0d316203c928fd2a0374c8c01f755d0a00b12a1c8934aeccff8868"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libjpeg-turbo.virtualgl.org/"
PKG_URL="$SOURCEFORGE_SRC/libjpeg-turbo/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="nasm:host"
PKG_DEPENDS_TARGET="toolchain nasm:host"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic -hardening"

configure_host() {
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$TOOLCHAIN \
  	 -DWITH_JPEG8=ON \
        -DENABLE_SHARED=OFF \
        -DWITH_SIMD=OFF \
        -DCMAKE_INSTALL_LIBDIR:PATH=lib \
  	 ..
}

PKG_CMAKE_OPTS_TARGET="-DWITH_JPEG8=ON -DENABLE_SHARED=ON -DENABLE_STATIC=ON"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
