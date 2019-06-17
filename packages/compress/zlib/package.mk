# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="d1c35e4"
PKG_SHA256="6dedc127fb4d6fbd199a74133cd72c89a63a52dbb3659a7f9820330f39c4fccc"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
			-DZLIB_COMPAT=1 \
			-DWITH_OPTIM=1 \
			-DWITH_NATIVE_INSTRUCTIONS=0"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DZLIB_COMPAT=1 \
			  -DWITH_OPTIM=1 \
			  -DWITH_NATIVE_INSTRUCTIONS=0"
