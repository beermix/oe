# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# PKG_VERSION="af9ef2e"
# $PKG_SHA256="625b1c4dfaeac5d470bebb55d00a49d1e8db2299750fd00548191b9994a39b72"
# PKG_URL="https://github.com/cloudflare/zlib/archive/$PKG_VERSION.tar.gz"

PKG_NAME="zlib"
PKG_VERSION="1.2.11.1_jtkv6.3"
PKG_SHA256="897980569aa46d20a4ed9fd63e2e7ce9465e0dd4742a135603db397f168f7f01"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/jtkukunas/zlib/releases"
PKG_URL="https://github.com/jtkukunas/zlib/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+lto +speed"

#LTO_SUPPORT="yes"
#GOLD_SUPPORT="yes"

post_unpack() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME

  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./configure --prefix=/usr --libdir=/usr/lib --static --shared
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=$TOOLCHAIN --libdir=$TOOLCHAIN/lib --static --shared
}
