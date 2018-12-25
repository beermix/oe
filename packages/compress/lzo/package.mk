# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="lzo"
PKG_VERSION="2.10"
PKG_SHA256="c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"
PKG_LICENSE="GPL"
PKG_SITE="http://www.oberhumer.com/opensource/lzo"
PKG_URL="http://www.oberhumer.com/opensource/lzo/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host ninja:host"
PKG_DEPENDS_TARGET="toolchain"
#PKG_TOOLCHAIN="configure"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition"
#  export CXXFLAGS="$CXXFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition"
#}

PKG_CMAKE_OPTS_HOST="-DENABLE_SHARED=OFF -DENABLE_STATIC=ON"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=ON -DENABLE_STATIC=ON"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/libexec
}

PKG_CONFIGURE_OPTS_TARGET="--disable-static --enable-shared"
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"