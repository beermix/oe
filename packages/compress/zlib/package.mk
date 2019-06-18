# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
#PKG_VERSION="d1c35e4"
#PKG_SHA256="6dedc127fb4d6fbd199a74133cd72c89a63a52dbb3659a7f9820330f39c4fccc"
PKG_VERSION="1.2.11.1_jtkv6.3"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://github.com//jtkukunas/zlib/archive/v$PKG_VERSION.tar.gz"
#PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed +lto"
LTO_SUPPORT="yes"
#GOLD_SUPPORT="yes"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCMAKE_VERBOSE_MAKEFILE=ON"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DCMAKE_VERBOSE_MAKEFILE=ON"

post_unpack() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME

  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./configure --prefix=/usr --libdir=/usr/lib --static --shared
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=$TOOLCHAIN --libdir=$TOOLCHAIN/lib --static --shared
}
