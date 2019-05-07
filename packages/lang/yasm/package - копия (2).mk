# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="e256985"
PKG_SHA256="8309e82abce883f3adb54866bb45dfd12f631e7b8274bf603021865d3a23ef16"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host gperf:host re2c:host nasm:host"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_TOOLCHAIN="autotools"
#PKG_TOOLCHAIN="cmake-make"

pre_configure_host() {
  export CCACHE_DISABLE=true
}

configure_package() {
  PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0"
  PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_HOST"
  PKG_CONFIGURE_OPTS_HOST="--disable-debug \
  			      --disable-warnerror \
  			      --disable-profiling \
  			      --disable-gcov \
  			      --disable-python-bindings \
  			      --without-libiconv-prefix \
  			      --without-libintl-prefix"
}

