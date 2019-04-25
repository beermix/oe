# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.4.0"
PKG_SHA256="63be339137d2b683c6d19a9e34f4fb684790e864fee13c7dd40e197a64c705c1"
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
