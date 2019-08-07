# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="fbd3315"
PKG_SHA256=""
#PKG_VERSION="1.2.11.1_jtkv6.3"
#PKG_SHA256="897980569aa46d20a4ed9fd63e2e7ce9465e0dd4742a135603db397f168f7f01"
#PKG_VERSION="af9ef2e"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
#PKG_URL="https://github.com//cloudflare/zlib/archive/$PKG_VERSION.tar.gz"
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

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
			-DZLIB_COMPAT=ON \
			-DWITH_OPTIM=1 \
			-DCMAKE_VERBOSE_MAKEFILE=1 \
			-DWITH_NATIVE_INSTRUCTIONS=1 \
			-DZLIB_ENABLE_TESTS=0"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DZLIB_COMPAT=ON \
			  -DWITH_OPTIM=1 \
			  -DCMAKE_VERBOSE_MAKEFILE=1 \
			  -DZLIB_ENABLE_TESTS=0"