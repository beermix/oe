# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bzip2"
PKG_VERSION="ef31e2d0"
PKG_SHA256="44b3e911505716972813b6793bee9d232deb1e6c5dbc71a44f098f5a6850eb34"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/federicomenaquintero/bzip2"
PKG_URL="https://gitlab.com/federicomenaquintero/bzip2/-/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="gcc:host cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-quality bzip2 data compressor."
PKG_TOOLCHAIN="cmake-make"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections"
#  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections"
#}

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC_LIB=1 -DCMAKE_VERBOSE_MAKEFILE=0"