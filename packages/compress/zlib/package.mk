# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="6f6bdcb"
PKG_SHA256="d660f81ba17027509a410b8dcfc161fb872bdcd4d924265be2f9774e0ea3de22"
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
#PKG_BUILD_FLAGS="+speed"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=1 -DCMAKE_VERBOSE_MAKEFILE=1"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DZLIB_COMPAT=1 -DCMAKE_VERBOSE_MAKEFILE=1"

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