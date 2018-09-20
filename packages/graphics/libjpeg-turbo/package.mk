# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libjpeg-turbo"
PKG_VERSION="2.0.0"
PKG_SHA256="778876105d0d316203c928fd2a0374c8c01f755d0a00b12a1c8934aeccff8868"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libjpeg-turbo.virtualgl.org/"
PKG_URL="$SOURCEFORGE_SRC/libjpeg-turbo/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_SHORTDESC="libjpeg-turbo: a high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD instructions (MMX, SSE2, etc.) to accelerate baseline JPEG compression and decompression."
PKG_LONGDESC="libjpeg-turbo is a high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD instructions (MMX, SSE2, etc.) to accelerate baseline JPEG compression and decompression. libjpeg-turbo is generally 2-4x as fast as the unmodified version of libjpeg, all else being equal."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host"

configure_host() {
  cmake -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
  	 -DWITH_JPEG8=ON \
  	 -DENABLE_STATIC=ON \
        -DENABLE_SHARED=OFF \
        -DWITH_SIMD=OFF \
  	 ..
}

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_JPEG8=ON \
        -DENABLE_STATIC=OFF \
        -DENABLE_SHARED=ON \
        -DWITH_SIMD=ON \
        ..
}

post_makeinstall_host() {
  mv -f $TOOLCHAIN/lib64/pkgconfig/* $TOOLCHAIN/lib/pkgconfig/
  rm -rf $TOOLCHAIN/lib64/pkgconfig
  mv -f $TOOLCHAIN/lib64/* $TOOLCHAIN/lib/
  rm -rf $TOOLCHAIN/lib64
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
