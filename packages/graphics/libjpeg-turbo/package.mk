# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libjpeg-turbo"
PKG_VERSION="2.0.1"
PKG_SHA256="a30db8bcc8a0fab56998ea134233a8cdcb7ac81170e7d87f8bc900f02dda39d4"
PKG_LICENSE="GPL"
PKG_SITE="http://libjpeg-turbo.virtualgl.org/"
PKG_URL="https://github.com/libjpeg-turbo/libjpeg-turbo/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD."
PKG_BUILD_FLAGS="+pic:host"

PKG_CMAKE_OPTS_HOST="-DENABLE_STATIC=ON \
                     -DENABLE_SHARED=OFF \
                     -DWITH_JPEG8=ON \
                     -DWITH_SIMD=OFF"

PKG_CMAKE_OPTS_TARGET="-DENABLE_STATIC=ON \
                       -DENABLE_SHARED=ON \
                       -DWITH_JPEG8=ON"

if target_has_feature "(neon|sse)"; then
  PKG_CMAKE_OPTS_TARGET+=" -DWITH_SIMD=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DWITH_SIMD=OFF"
fi

if [ $TARGET_ARCH = "x86_64" ]; then
  PKG_DEPENDS_HOST+=" nasm:host"
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
