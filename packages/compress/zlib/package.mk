# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="74a3e05"
PKG_SHA256="72e4f99869b6b34455c1f1bebd348e43865c948566dedf5fd2bfaed245a2a0b3"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"
#PKG_BUILD_FLAGS="+lto"

#LTO_SUPPORT="yes"
#GOLD_SUPPORT="yes"
# -DWITH_OPTIM=ON 

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#}

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DZLIB_COMPAT=ON \
			  -DWITH_OPTIM=ON \
			  -DWITH_NATIVE_INSTRUCTIONS=OFF \
			  -DCMAKE_VERBOSE_MAKEFILE=ON"
			  
makeinstall_host() {
  : # nop
}