# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bzip2"
PKG_VERSION="78aa9c86238fdffd8dcb6e8a7b45909e29fae22f"
PKG_SHA256="fddc7f804cd6040d28b29c96ba768cd0ec79ec6b14f63eb4e01503609e288361"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/federicomenaquintero/bzip2"
PKG_URL="https://gitlab.com/federicomenaquintero/bzip2/-/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="gcc:host cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-quality bzip2 data compressor."
PKG_TOOLCHAIN="cmake-make"

pre_configure_host() {
  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections"
  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections"
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections"
  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections"
}

PKG_CMAKE_OPTS_HOST="-DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"