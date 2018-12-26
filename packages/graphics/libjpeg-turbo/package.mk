# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libjpeg-turbo"
PKG_VERSION="2.0.1"
PKG_SHA256="e5f86cec31df1d39596e0cca619ab1b01f99025a27dafdfc97a30f3a12f866ff"
PKG_LICENSE="GPL"
PKG_SITE="http://libjpeg-turbo.virtualgl.org/"
PKG_URL="$SOURCEFORGE_SRC/libjpeg-turbo/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="nasm:host"
PKG_DEPENDS_TARGET="toolchain nasm:host"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic +hardening"

configure_host() {
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$TOOLCHAIN \
  	 -DWITH_JPEG8=ON \
        -DENABLE_SHARED=OFF \
        -DWITH_SIMD=OFF \
        -DCMAKE_INSTALL_LIBDIR:PATH=lib \
  	 ..
}

PKG_CMAKE_OPTS_TARGET="-DWITH_JPEG8=ON -DENABLE_SHARED=ON -DENABLE_STATIC=ON"

pre_configure_target() {
  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
