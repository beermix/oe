# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="743def4"
PKG_SHA256="5622621176d6cc4f45b1fc4cfb72d8e9e6facdd11b236ce55bbc2884a7ce4bc8"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON -DWITH_NATIVE_INSTRUCTIONS=ON"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DZLIB_COMPAT=ON \
			  -DWITH_FUZZERS=OFF \
			  -DWITH_GZFILEOP=OFF \
			  -DWITH_MSAN=OFF \
			  -DWITH_NEW_STRATEGIES=ON \
			  -DWITH_OPTIM=ON \
			  -DWITH_SANITIZERS=OFF \
			  -DZLIB_ENABLE_TESTS=ON \
			  -DWITH_NATIVE_INSTRUCTIONS=OFF \
			  -DCMAKE_VERBOSE_MAKEFILE=ON"