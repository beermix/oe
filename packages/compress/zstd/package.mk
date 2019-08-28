# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.4.3"
PKG_SHA256="e88ec8d420ff228610b77fba4fbf22b9f8b9d3f223a40ef59c9c075fcdad5767"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="http://www.zstd.net"
PKG_URL="https://github.com/facebook/zstd/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="gcc:host cmake:host ninja:host"
PKG_DEPENDS_TARGET="toolchain xz zlib lz4"
PKG_LONGDESC="A fast real-time compression algorithm."

configure_package() {
  PKG_CMAKE_SCRIPT="$PKG_BUILD/build/cmake/CMakeLists.txt"

  PKG_CMAKE_OPTS_HOST="-DZSTD_BUILD_SHARED=0 -DZSTD_BUILD_STATIC=1"
  PKG_CMAKE_OPTS_TARGET="-DZSTD_BUILD_SHARED=0 -DZSTD_BUILD_STATIC=1 -DZSTD_MULTITHREAD_SUPPORT=1"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}