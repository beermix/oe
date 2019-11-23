# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="3fb5f57"
PKG_SHA256="b0e80b97a3273dacf77dc5ea1c93bd9dff4f1497967a0a05c9f91f54d77c963f"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON -DWITH_NATIVE_INSTRUCTIONS=ON"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON"