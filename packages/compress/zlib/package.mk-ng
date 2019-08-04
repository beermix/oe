# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="f06c71f"
PKG_SHA256="04864be3db5ca900c88a2ef4cc5192fb49b3b4021dbefd5221d7ca5c88b0993a"
#PKG_VERSION="1.2.11.1_jtkv6.3"
#PKG_SHA256="897980569aa46d20a4ed9fd63e2e7ce9465e0dd4742a135603db397f168f7f01"
#PKG_VERSION="af9ef2e"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/zlib-ng/zlib-ng"
PKG_URL="https://github.com/zlib-ng/zlib-ng/archive/$PKG_VERSION.tar.gz"
#PKG_URL="https://github.com//cloudflare/zlib/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+lto"

LTO_SUPPORT="yes"
GOLD_SUPPORT="yes"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON -DWITH_OPTIM=ON -DCMAKE_VERBOSE_MAKEFILE=0"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=ON -DWITH_OPTIM=ON -DCMAKE_VERBOSE_MAKEFILE=0"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#  export CXXFLAGS="$CXXFLAGS -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#}

#post_unpack() {
#  mkdir -p $PKG_BUILD/.$HOST_NAME
#  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
#
#  mkdir -p $PKG_BUILD/.$TARGET_NAME
#  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
#}

#configure_target() {
#  cd $PKG_BUILD/.$TARGET_NAME
#  ./configure --prefix=/usr --libdir=/usr/lib --static --shared
#}

#configure_host() {
#  cd $PKG_BUILD/.$HOST_NAME
#  ./configure --prefix=$TOOLCHAIN --libdir=$TOOLCHAIN/lib --static --shared
#}

#post_makeinstall_target() {
#  cd $PKG_BUILD/.$TARGET_NAME
#  make test all
#}