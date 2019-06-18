# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
#PKG_VERSION="d1c35e4"
#PKG_SHA256="6dedc127fb4d6fbd199a74133cd72c89a63a52dbb3659a7f9820330f39c4fccc"
PKG_VERSION="1.2.11.1_jtkv6.3"
PKG_SHA256="897980569aa46d20a4ed9fd63e2e7ce9465e0dd4742a135603db397f168f7f01"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://github.com//jtkukunas/zlib/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
}

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

#post_makeinstall_target() {
#  cd $PKG_BUILD/.$TARGET_NAME
#  make test all
#}
