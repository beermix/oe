# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="lz4"
PKG_VERSION="1.8.3"
PKG_SHA256="33af5936ac06536805f9745e0b6d61da606a1f8b4cc5c04dd3cbaca3b9b4fc43"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lz4/lz4/releases"
PKG_URL="https://github.com/lz4/lz4/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="lz4 data compressor/decompressor"

configure_package() {
  PKG_CMAKE_SCRIPT="$PKG_BUILD/contrib/cmake_unofficial/CMakeLists.txt"

  PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=0"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}
