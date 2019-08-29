# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="195ff00"
PKG_SHA256="9a4465d5c40f34fddd9cc02fc62815c525e95df5695ece9a059e1a2e750eb118"
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

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON -DCMAKE_VERBOSE_MAKEFILE=ON"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DZLIB_COMPAT=ON \
			  -DCMAKE_VERBOSE_MAKEFILE=ON"