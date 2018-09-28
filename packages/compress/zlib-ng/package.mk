# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zlib-ng"
PKG_VERSION="9992d3b"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
#PKG_VERSION="a17fefa"
#PKG_URL="https://github.com/mtl1979/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="compress"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_OPTS_TARGET="-DZLIB_COMPAT=1 -DWITH_GZFILEOP=1 -DWITH_OPTIM=1"

configure_host() {
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$TOOLCHAIN \
  	 -DZLIB_COMPAT=1 \
  	 -DWITH_GZFILEOP=1 \
  	 -DWITH_OPTIM=1 \
  	 ..
}