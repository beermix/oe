# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bzip2"
PKG_VERSION="3eff3392"
PKG_SHA256="e48fab35e462aa4f4045bfe8d2d3949edb55700d10b1034cd03f6cb52e132b5f"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/federicomenaquintero/bzip2"
PKG_URL="https://gitlab.com/federicomenaquintero/bzip2/-/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="gcc:host cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-quality bzip2 data compressor."
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections"
  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections"
}

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"