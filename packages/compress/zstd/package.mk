# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.4.2"
PKG_SHA256="12730983b521f9a604c6789140fcb94fadf9a3ca99199765e33c56eb65b643c9"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="http://www.zstd.net"
PKG_URL="https://github.com/facebook/zstd/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="gcc:host cmake:host"
PKG_DEPENDS_TARGET="toolchain zlib xz lz4"
PKG_LONGDESC="A fast real-time compression algorithm."
PKG_TOOLCHAIN="cmake-make"

configure_package() {
  PKG_CMAKE_SCRIPT="${PKG_BUILD}/build/cmake/CMakeLists.txt"

  PKG_CMAKE_OPTS_HOST="-DZSTD_BUILD_SHARED=0 -DZSTD_BUILD_STATIC=1"
  PKG_CMAKE_OPTS_TARGET="-DZSTD_BUILD_SHARED=0 -DZSTD_BUILD_STATIC=1"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}