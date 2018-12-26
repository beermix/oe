# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="80bc804"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host gperf:host re2c:host nasm:host"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="cmake-make"

pre_configure_host() {
  export CCACHE_DISABLE=true
}

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DYASM_BUILD_TESTS=0"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DYASM_BUILD_TESTS=0"