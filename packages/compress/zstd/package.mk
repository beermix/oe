# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.3.8"
PKG_SHA256="90d902a1282cc4e197a8023b6d6e8d331c1fd1dfe60f7f8e4ee9da40da886dc3"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd/releases"
PKG_URL="https://github.com/facebook/zstd/archive/v${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR=$PKG_NAME-$PKG_VERSION
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A fast real-time compression algorithm."

configure_package() {
  PKG_CMAKE_SCRIPT="$PKG_BUILD/build/cmake/CMakeLists.txt"
  PKG_CMAKE_OPTS_HOST="-DZSTD_BUILD_SHARED=0"
  PKG_CMAKE_OPTS_TARGET="-DZSTD_BUILD_SHARED=0"
}
