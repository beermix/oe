# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="80bc804"
PKG_SHA256="d9f828a2e059012c697154a054a87f344a5d8c479c5eb59fed81bbc52ef7205f"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host gperf:host re2c:host nasm:host"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_TOOLCHAIN="autotools"
#PKG_TOOLCHAIN="cmake-make"

configure_package() {
  export CCACHE_DISABLE=true
  PKG_CONFIGURE_OPTS_HOST="--disable-debug \
  			      --disable-warnerror \
  			      --disable-profiling \
  			      --disable-gcov \
  			      --disable-python-bindings \
  			      --without-libiconv-prefix \
  			      --without-libintl-prefix"
}

